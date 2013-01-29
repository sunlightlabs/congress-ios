//
//  SFLegislatorListViewController.m
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
#import "SFLegislatorDetailViewController.h"

@interface SFLegislatorsSectionViewController ()
{
    BOOL _updating;
    NSArray *_scopeBarSegments;
}

@end

@implementation SFLegislatorsSectionViewController

@synthesize legislatorsSectionView = _legislatorSectionsView;
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void) loadView {
    _legislatorSectionsView.frame = [[UIScreen mainScreen] applicationFrame];
    _legislatorSectionsView.autoresizesSubviews = YES;
    self.view = _legislatorSectionsView;
    [self.view layoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self.viewDeckController action:@selector(toggleLeftView)];

    self.legislatorList = [NSMutableArray arrayWithCapacity:[_perPage integerValue]];

    __weak SFLegislatorsSectionViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [SFLegislatorService getAllLegislatorsInOfficeWithCompletionBlock:^(NSArray *resultsArray) {
            if (resultsArray) {
                weakSelf.legislatorList = [NSArray arrayWithArray:resultsArray];
                [weakSelf setVisibleLegislatorsUsingScope:nil];
            }
            [weakSelf.tableView.pullToRefreshView stopAnimating];
        }];

    }];

    [self.tableView triggerPullToRefresh];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_sectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([_sectionTitles count]) {
        return [_sectionTitles objectAtIndex:section];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.sections objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    // Configure the cell...
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    SFLegislator *leg = (SFLegislator *)[[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [[cell textLabel] setText:leg.titledByLastName];
    NSString *detailText = @"";
    if (leg.party && ![leg.party isEqualToString:@""]) {
        detailText = [detailText stringByAppendingFormat:@"(%@) ", leg.party];
    }
    detailText = [detailText stringByAppendingString:leg.stateName];
    if (leg.district) {
        detailText = [detailText stringByAppendingFormat:@" - District %@", leg.district];
    }
    [[cell detailTextLabel] setText:detailText];

    return cell;
}


-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableOrderedSet *indices = [NSMutableOrderedSet orderedSet];

    for (NSString *sectionTitle in self->_sectionTitles) {
        [indices addObject:[sectionTitle substringToIndex:1]];
    }

    return [indices array];
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSPredicate *alphaPredicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@", [title substringToIndex:1]];
    NSArray *filteredTitles = [self.sectionTitles filteredArrayUsingPredicate:alphaPredicate];
    NSInteger position = (NSInteger)[self.sectionTitles indexOfObject:[filteredTitles firstObject]];
    return position;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFLegislatorDetailViewController *detailViewController = [[SFLegislatorDetailViewController alloc] initWithNibName:nil bundle:nil];
    detailViewController.legislator = (SFLegislator *)[[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - scopeBar

- (void)handleScopeBarChangeEvent:(UISegmentedControl *)segmentedControl
{
    if ([segmentedControl isEqual:_legislatorSectionsView.scopeBar]) {
        NSInteger index = [segmentedControl selectedSegmentIndex];
        NSString  *selectedSegmentText = [segmentedControl titleForSegmentAtIndex:index];
        [self setVisibleLegislatorsUsingScope:selectedSegmentText];
    }
}

#pragma mark - Private/Internal

- (void)_initialize
{
    _scopeBarSegments = @[@"States", @"House", @"Senate"];
    self.title = @"Legislators";
    if (!_legislatorSectionsView) {
        _legislatorSectionsView = [[SFLegislatorsSectionView alloc] initWithFrame:CGRectZero];
        _legislatorSectionsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        _legislatorSectionsView.scopeBarSegmentTitles = _scopeBarSegments;
        [_legislatorSectionsView.scopeBar addTarget:self action:@selector(handleScopeBarChangeEvent:) forControlEvents:UIControlEventValueChanged];

        self.tableView = _legislatorSectionsView.tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    
    _sectionTitles = @[];
    _perPage = @50;
}


- (void)setVisibleLegislatorsUsingScope:(NSString *)scopeTitle
{
    NSString *titlePath = @"stateName";
    NSArray *visibleLegislators = self.legislatorList;
    NSSet *titlesSet = [NSSet setWithArray:[visibleLegislators valueForKeyPath:titlePath]];
    
    if ([scopeTitle isEqualToString:@"House"] || [scopeTitle isEqualToString:@"Senate"]) {
        titlePath = @"lastName";
        NSPredicate *chamberFilterPredicate = [NSPredicate predicateWithFormat:@"chamber MATCHES[c] %@", scopeTitle];
        visibleLegislators = [self.legislatorList filteredArrayUsingPredicate:chamberFilterPredicate];
        titlesSet = [NSSet setWithArray:[visibleLegislators valueForKeyPath:titlePath]];
        titlesSet = [titlesSet mtl_mapUsingBlock:^id(id obj) {
            if (obj) {
                obj = [(NSString *)obj substringToIndex:1];

            }
            return obj;
        }];
    }

    NSSet *currentTitles = [titlesSet objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        if (obj == nil) {
            *stop = YES;
            return false;
        }
        return true;
    }];
    self.sectionTitles = [[currentTitles allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSUInteger sectionTitleCount = [currentTitles count];

    NSMutableArray *mutableSections = [NSMutableArray arrayWithCapacity:sectionTitleCount];
    for (int i = 0; i < sectionTitleCount; i++) {
        [mutableSections addObject:[NSMutableArray array]];
    }

    for (SFLegislator *object in visibleLegislators) {
        // titlePath no longer works when it is lastName and the sectionTitles are alfa letters
        id titleComparator = [object valueForKeyPath:titlePath];
        NSUInteger index;
        if ([titlePath isEqualToString:@"lastName"]) {
//            Must FINd a single sectionTitle based on first letter of comparator
            index = [self.sectionTitles indexOfObject:[(NSString *)titleComparator substringToIndex:1]];
        }
        else
        {
            index = [self.sectionTitles indexOfObject:titleComparator];
        }
        [[mutableSections objectAtIndex:index] addObject:object];
    }

    self.sections = mutableSections;
    [self.tableView reloadData];

}


@end
