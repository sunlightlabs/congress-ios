//
//  SFLegislatorsSectionViewController.m
//  Congress
//
//  Created by Daniel Cloud on 12/5/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorsSectionViewController.h"
#import "SVPullToRefreshView+Congress.h"
#import "SFSegmentedViewController.h"
#import "SFLegislatorService.h"
#import "SFLegislator.h"
#import "SFLegislatorTableViewController.h"
#import "SFLegislatorDetailViewController.h"

@implementation SFLegislatorsSectionViewController
{
    BOOL _updating;
    NSInteger *_currentSegmentIndex;
    NSArray *_sectionTitles;
    SFLegislatorTableViewController *_statesLegislatorListVC;
    SFLegislatorTableViewController *_houseLegislatorListVC;
    SFLegislatorTableViewController *_senateLegislatorListVC;
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
	self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem menuButtonWithTarget:self.viewDeckController action:@selector(toggleLeftView)];

    // View has been loaded, so put _segmentedVC's view into it and display
    _segmentedVC.view.frame = self.view.frame;
    [self.view addSubview:_segmentedVC.view];
    [_segmentedVC didMoveToParentViewController:self];
    [_segmentedVC displayViewForSegment:0];

    SFLegislatorTableViewController *initialListVC = _segmentedVC.currentViewController;
    [initialListVC.tableView triggerPullToRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_currentSegmentIndex != nil) {
        [_segmentedVC displayViewForSegment:_currentSegmentIndex];
        _currentSegmentIndex = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private/Internal

- (void)_initialize
{
    self.restorationIdentifier = NSStringFromClass(self.class);
    self.title = @"Legislators";
    self.legislatorList = [NSMutableArray array];

    _currentSegmentIndex = nil;
    _sectionTitles = @[@"States", @"House", @"Senate"];

    _segmentedVC = [[SFSegmentedViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:_segmentedVC];

    SFDataTableSectionTitleGenerator stateTitlesGenerator = ^NSArray*(NSArray *items) {
        NSSet *sectionTitlesSet = [NSSet setWithArray:[items valueForKeyPath:@"stateName"]];
        return [[sectionTitlesSet allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    };
    SFDataTableSectionIndexTitleGenerator stateSectionIndexTitleGenerator = ^NSArray*(NSArray *sectionTitles)
    {
        id (^singleLetter)(id obj) = ^id(id obj) {
            if (obj) { obj = [(NSString *)obj substringToIndex:1]; }
            return obj;
        };
        NSSet *sectionIndexTitlesSet = [NSSet setWithArray:[sectionTitles mtl_mapUsingBlock:singleLetter]];
        return [[sectionIndexTitlesSet allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    };
    SFDataTableSectionForSectionIndexHandler legSectionIndexHandler = ^NSInteger(NSString *title, NSInteger index, NSArray *sectionTitles)
    {
        NSPredicate *alphaPredicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@", [title substringToIndex:1]];
        NSArray *filteredTitles = [sectionTitles filteredArrayUsingPredicate:alphaPredicate];
        NSInteger position = (NSInteger)[sectionTitles indexOfObject:[filteredTitles firstObject]];
        return position;
    };
    SFDataTableSortIntoSectionsBlock byStateSorterBlock = ^NSUInteger(id item, NSArray *sectionTitles) {
        SFLegislator *legislator = (SFLegislator *)item;
        NSUInteger index = [sectionTitles indexOfObject:legislator.stateName];
        if (index != NSNotFound) {
            return index;
        }
        return 0;
    };
    SFDataTableSectionTitleGenerator lastNameTitlesGenerator = ^NSArray*(NSArray *items) {
        id (^singleLetter)(id obj) = ^id(id obj) {
            if (obj) { obj = [(NSString *)obj substringToIndex:1]; }
            return obj;
        };
        NSSet *sectionTitlesSet = [[NSSet setWithArray:[items valueForKeyPath:@"lastName"]] mtl_mapUsingBlock:singleLetter];
        return [[sectionTitlesSet allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    };
    SFDataTableSortIntoSectionsBlock byLastNameSorterBlock = ^NSUInteger(id item, NSArray *sectionTitles) {
        SFLegislator *legislator = (SFLegislator *)item;
        id (^singleLetter)(id obj) = ^id(id obj) {
            if (obj) { obj = [(NSString *)obj substringToIndex:1]; }
            return obj;
        };
        NSUInteger index = [sectionTitles indexOfObject:singleLetter(legislator.lastName)];
        if (index != NSNotFound) {
            return index;
        }
        return 0;
    };
    SFDataTableOrderItemsInSectionsBlock lastNameFirstOrderBlock = ^NSArray*(NSArray *sectionItems) {
        return [sectionItems sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"stateName" ascending:YES]]];
    };

    _statesLegislatorListVC = [[SFLegislatorTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _statesLegislatorListVC.sectionTitleGenerator = stateTitlesGenerator;
    [_statesLegislatorListVC setSectionIndexTitleGenerator:stateSectionIndexTitleGenerator sectionIndexHandler:legSectionIndexHandler];
    _statesLegislatorListVC.sortIntoSectionsBlock = byStateSorterBlock;
    
    _houseLegislatorListVC = [[SFLegislatorTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _houseLegislatorListVC.sectionTitleGenerator = lastNameTitlesGenerator;
    [_houseLegislatorListVC setSectionIndexTitleGenerator:stateSectionIndexTitleGenerator sectionIndexHandler:legSectionIndexHandler];
    _houseLegislatorListVC.sortIntoSectionsBlock = byLastNameSorterBlock;
    _houseLegislatorListVC.orderItemsInSectionsBlock = lastNameFirstOrderBlock;

    _senateLegislatorListVC = [[SFLegislatorTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _senateLegislatorListVC.sectionTitleGenerator = lastNameTitlesGenerator;
    [_senateLegislatorListVC setSectionIndexTitleGenerator:stateSectionIndexTitleGenerator sectionIndexHandler:legSectionIndexHandler];
    _senateLegislatorListVC.sortIntoSectionsBlock = byLastNameSorterBlock;
    _senateLegislatorListVC.orderItemsInSectionsBlock = lastNameFirstOrderBlock;

    [_segmentedVC setViewControllers:@[_statesLegislatorListVC, _houseLegislatorListVC, _senateLegislatorListVC] titles:_sectionTitles];

    // Set up viewcontrollers for the list segments and give them pull-to-refresh handlers
    __weak SFLegislatorsSectionViewController *weakSelf = self;
    for (__weak SFLegislatorTableViewController *vc in _segmentedVC.viewControllers) {
        [vc.tableView addPullToRefreshWithActionHandler:^{
            for (SFLegislatorTableViewController *tempvc in _segmentedVC.viewControllers) {
                [tempvc.tableView.pullToRefreshView startAnimating];
            }
            [SFLegislatorService allLegislatorsInOfficeWithCompletionBlock:^(NSArray *resultsArray) {
                if (resultsArray) {
                    weakSelf.legislatorList = [NSArray arrayWithArray:resultsArray];
                    [weakSelf divvyLegislators];
                }
                for (SFLegislatorTableViewController *tempvc in _segmentedVC.viewControllers) {
                    [tempvc.tableView.pullToRefreshView stopAnimatingAndSetLastUpdatedNow];
                }
            }];
            
        }];
        [vc.tableView.pullToRefreshView setSubtitle:@"Legislators" forState:SVPullToRefreshStateAll];
    }
}

- (void)divvyLegislators
{
    // Set up States list viewcontrollers
    _statesLegislatorListVC.items = _legislatorList;
    [_statesLegislatorListVC sortItemsIntoSectionsAndReload];

    // Prep for chamber list viewcontrollers
    NSPredicate *chamberFilterPredicate = [NSPredicate predicateWithFormat:@"chamber MATCHES[c] $chamber"];
    for (NSString *chamber in @[@"House", @"Senate"]) {
        SFLegislatorTableViewController *chamberListVC = [_segmentedVC viewControllerForSegmentTitle:chamber];
        chamberListVC.items = [_legislatorList filteredArrayUsingPredicate:
                                       [chamberFilterPredicate predicateWithSubstitutionVariables:@{@"chamber": chamber}]];
        [chamberListVC sortItemsIntoSectionsAndReload];
   }
}

#pragma mark - Application state

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    [coder encodeInteger:[_segmentedVC currentSegmentIndex] forKey:@"segmentIndex"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    _currentSegmentIndex = [coder decodeIntegerForKey:@"segmentIndex"];
}

@end
