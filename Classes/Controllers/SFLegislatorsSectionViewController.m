//
//  SFLegislatorsSectionViewController.m
//  Congress
//
//  Created by Daniel Cloud on 12/5/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorsSectionViewController.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "SFLegislatorsSectionView.h"
#import "SFLegislatorService.h"
#import "SFLegislator.h"
#import "SFLegislatorListViewController.h"
#import "SFLegislatorDetailViewController.h"

@interface SFLegislatorsSectionViewController ()
{
    BOOL _updating;
    NSArray *_scopeBarSegments;
}

@end

@implementation SFLegislatorsSectionViewController

@synthesize legislatorList = _legislatorList;
@synthesize legislatorsSectionView = _legislatorsSectionView;
@synthesize currentListVC = _currentListVC;
@synthesize listViewControllers = _listViewControllers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void) loadView {
    _legislatorsSectionView.frame = [[UIScreen mainScreen] applicationFrame];
    _legislatorsSectionView.autoresizesSubviews = YES;
    self.view = _legislatorsSectionView;
    [self.view layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self.viewDeckController action:@selector(toggleLeftView)];

    [self.currentListVC.tableView triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setIsUpdating:(BOOL )updating
{
    self->_updating = updating;
}

-(BOOL)isUpdating
{
    return self->_updating;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFLegislatorDetailViewController *detailViewController = [[SFLegislatorDetailViewController alloc] initWithNibName:nil bundle:nil];
    detailViewController.legislator = (SFLegislator *)[[_currentListVC.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - scopeBar

- (void)handleScopeBarChangeEvent:(UISegmentedControl *)segmentedControl
{
    if ([segmentedControl isEqual:_legislatorsSectionView.scopeBar]) {
        NSInteger index = [segmentedControl selectedSegmentIndex];
        NSString *segmentName = [segmentedControl titleForSegmentAtIndex:index];
        [self displayListViewForSegment:segmentName];
    }
}

#pragma mark - Private/Internal

- (void)_initialize
{
    _scopeBarSegments = @[@"States", @"House", @"Senate"];
    self.title = @"Legislators";
    self.legislatorList = [NSMutableArray array];

    // Set up viewcontrollers for the list segments and give them pull-to-refresh handlers
    NSMutableDictionary *segmentViewControllers = [NSMutableDictionary dictionaryWithCapacity:[_scopeBarSegments count]];
    __weak SFLegislatorsSectionViewController *weakSelf = self;

    for (NSString *key in _scopeBarSegments) {
        SFLegislatorListViewController *vc = [[SFLegislatorListViewController alloc] initWithStyle:UITableViewStylePlain];
        [vc.tableView addPullToRefreshWithActionHandler:^{
            [SFLegislatorService getAllLegislatorsInOfficeWithCompletionBlock:^(NSArray *resultsArray) {
                if (resultsArray) {
                    weakSelf.legislatorList = [NSArray arrayWithArray:resultsArray];
                    [weakSelf divvyLegislators];
                }
                [weakSelf.currentListVC.tableView.pullToRefreshView stopAnimating];
            }];
            
        }];
        [segmentViewControllers setObject:vc forKey:key];
    }
    _listViewControllers = [NSDictionary dictionaryWithDictionary:segmentViewControllers];

    
    if (!_legislatorsSectionView) {
        _legislatorsSectionView = [[SFLegislatorsSectionView alloc] initWithFrame:CGRectZero];
        _legislatorsSectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        _legislatorsSectionView.scopeBarSegmentTitles = _scopeBarSegments;
        [_legislatorsSectionView.scopeBar addTarget:self action:@selector(handleScopeBarChangeEvent:) forControlEvents:UIControlEventValueChanged];

        [self displayListViewForSegment:@"States"];
    }
}


- (void)displayListViewForSegment:(NSString *)segmentName
{
    if (_currentListVC) {
        [_currentListVC willMoveToParentViewController:nil];
        [_currentListVC removeFromParentViewController];
    }
    _currentListVC = _listViewControllers[segmentName];
    [self addChildViewController:_currentListVC];
    _currentListVC.tableView.delegate = self;
    _legislatorsSectionView.tableView = _currentListVC.tableView;
    [_currentListVC didMoveToParentViewController:self];
}

- (void)divvyLegislators
{
    // Set up States list viewcontrollers
    NSSet *sectionTitlesSet = [NSSet setWithArray:[_legislatorList valueForKeyPath:@"stateName"]];
    SFLegislatorListViewController *legislatorVC = _listViewControllers[@"States"];
    legislatorVC.legislatorList = _legislatorList;
    legislatorVC.sectionTitles = [[sectionTitlesSet allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    [legislatorVC setUpSectionsUsingSectionTitlePredicate:[NSPredicate predicateWithFormat:@"stateName == $sectionTitle"]];

    
    // Prep for chamber list viewcontrollers
    NSPredicate *chamberFilterPredicate = [NSPredicate predicateWithFormat:@"chamber MATCHES[c] $chamber"];
    id (^lastNameSingleLetter)(id obj) = ^id(id obj) {
        if (obj) { obj = [(NSString *)obj substringToIndex:1]; }
        return obj;
    };
    NSPredicate *lastNamePredicate = [NSPredicate predicateWithFormat:@"lastName BEGINSWITH $sectionTitle"];

    for (NSString *chamber in @[@"House", @"Senate"]) {
        legislatorVC = _listViewControllers[chamber];
        legislatorVC.legislatorList = [_legislatorList filteredArrayUsingPredicate:
                                       [chamberFilterPredicate predicateWithSubstitutionVariables:@{@"chamber": chamber}]];
        sectionTitlesSet = [[NSSet setWithArray:[legislatorVC.legislatorList valueForKeyPath:@"lastName"]] mtl_mapUsingBlock:lastNameSingleLetter];
        legislatorVC.sectionTitles = [[sectionTitlesSet allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        [legislatorVC setUpSectionsUsingSectionTitlePredicate:lastNamePredicate];
    }
}

@end
