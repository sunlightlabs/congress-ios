//
//  SFLegislatorsSectionViewController.m
//  Congress
//
//  Created by Daniel Cloud on 12/5/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorsSegmentedViewController.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "SFSegmentedViewController.h"
#import "SFLegislatorService.h"
#import "SFLegislator.h"
#import "SFLegislatorListViewController.h"
#import "SFLegislatorDetailViewController.h"

@implementation SFLegislatorsSegmentedViewController
{
    BOOL _updating;
    NSArray *_sectionTitles;
    SFLegislatorListViewController *_statesLegislatorListVC;
    SFLegislatorListViewController *_houseLegislatorListVC;
    SFLegislatorListViewController *_senateLegislatorListVC;
    SFSegmentedViewController *_segmentedVC;
}

@synthesize legislatorList = _legislatorList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _initialize];
    }
    return self;
}

-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor whiteColor];
	self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem settingsButtonWithTarget:self.viewDeckController action:@selector(toggleLeftView)];
    self.navigationItem.backBarButtonItem = [UIBarButtonItem backButton];

    // View has been loaded, so put _segmentedVC's view into it and display
    _segmentedVC.view.frame = self.view.frame;
    [self.view addSubview:_segmentedVC.view];
    [_segmentedVC didMoveToParentViewController:self];
    [_segmentedVC displayViewForSegment:0];

    SFLegislatorListViewController *initialListVC = _segmentedVC.currentViewController;
    [initialListVC.tableView triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private/Internal

- (void)_initialize
{
    self.title = @"Legislators";
    self.legislatorList = [NSMutableArray array];

    _sectionTitles = @[@"States", @"House", @"Senate"];

    _segmentedVC = [[SFSegmentedViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:_segmentedVC];

    _statesLegislatorListVC = [[SFLegislatorListViewController alloc] initWithStyle:UITableViewStylePlain];\
    _houseLegislatorListVC = [[SFLegislatorListViewController alloc] initWithStyle:UITableViewStylePlain];
    _senateLegislatorListVC = [[SFLegislatorListViewController alloc] initWithStyle:UITableViewStylePlain];

    [_segmentedVC setViewControllers:@[_statesLegislatorListVC, _houseLegislatorListVC, _senateLegislatorListVC] titles:_sectionTitles];

    // Set up viewcontrollers for the list segments and give them pull-to-refresh handlers
    __weak SFLegislatorsSegmentedViewController *weakSelf = self;
    for (__weak SFLegislatorListViewController *vc in _segmentedVC.viewControllers) {
        [vc.tableView addPullToRefreshWithActionHandler:^{
            for (SFLegislatorListViewController *tempvc in _segmentedVC.viewControllers) {
                [tempvc.tableView.pullToRefreshView startAnimating];
            }
            [SFLegislatorService allLegislatorsInOfficeWithCompletionBlock:^(NSArray *resultsArray) {
                if (resultsArray) {
                    weakSelf.legislatorList = [NSArray arrayWithArray:resultsArray];
                    [weakSelf divvyLegislators];
                }
                for (SFLegislatorListViewController *tempvc in _segmentedVC.viewControllers) {
                    [tempvc.tableView.pullToRefreshView stopAnimating];
                }
            }];
            
        }];
    }
}

- (void)divvyLegislators
{
    // Set up States list viewcontrollers
    NSSet *sectionTitlesSet = [NSSet setWithArray:[_legislatorList valueForKeyPath:@"stateName"]];
    _statesLegislatorListVC.legislatorList = _legislatorList;
    _statesLegislatorListVC.sectionTitles = [[sectionTitlesSet allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    [_statesLegislatorListVC setUpSectionsUsingSectionTitlePredicate:[NSPredicate predicateWithFormat:@"stateName == $sectionTitle"]];

    
    // Prep for chamber list viewcontrollers
    NSPredicate *chamberFilterPredicate = [NSPredicate predicateWithFormat:@"chamber MATCHES[c] $chamber"];
    id (^lastNameSingleLetter)(id obj) = ^id(id obj) {
        if (obj) { obj = [(NSString *)obj substringToIndex:1]; }
        return obj;
    };
    NSPredicate *lastNamePredicate = [NSPredicate predicateWithFormat:@"lastName BEGINSWITH $sectionTitle"];

    for (NSString *chamber in @[@"House", @"Senate"]) {
        SFLegislatorListViewController *chamberListVC = [_segmentedVC viewControllerForSegmentTitle:chamber];
        chamberListVC.legislatorList = [_legislatorList filteredArrayUsingPredicate:
                                       [chamberFilterPredicate predicateWithSubstitutionVariables:@{@"chamber": chamber}]];
        sectionTitlesSet = [[NSSet setWithArray:[chamberListVC.legislatorList valueForKeyPath:@"lastName"]] mtl_mapUsingBlock:lastNameSingleLetter];
        chamberListVC.sectionTitles = [[sectionTitlesSet allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        [chamberListVC setUpSectionsUsingSectionTitlePredicate:lastNamePredicate];
    }
}

@end
