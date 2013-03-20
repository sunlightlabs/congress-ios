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
	self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem menuButtonWithTarget:self.viewDeckController action:@selector(toggleLeftView)];
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

    _statesLegislatorListVC = [[SFLegislatorListViewController alloc] initWithStyle:UITableViewStylePlain];
    _statesLegislatorListVC.sectionTitleGenerator = stateTitlesGenerator;
    [_statesLegislatorListVC setSectionIndexTitleGenerator:stateSectionIndexTitleGenerator sectionIndexHandler:legSectionIndexHandler];
    _statesLegislatorListVC.sortIntoSectionsBlock = byStateSorterBlock;
    
    _houseLegislatorListVC = [[SFLegislatorListViewController alloc] initWithStyle:UITableViewStylePlain];
    _houseLegislatorListVC.sectionTitleGenerator = lastNameTitlesGenerator;
    [_houseLegislatorListVC setSectionIndexTitleGenerator:stateSectionIndexTitleGenerator sectionIndexHandler:legSectionIndexHandler];
    _houseLegislatorListVC.sortIntoSectionsBlock = byLastNameSorterBlock;
    _houseLegislatorListVC.orderItemsInSectionsBlock = lastNameFirstOrderBlock;

    _senateLegislatorListVC = [[SFLegislatorListViewController alloc] initWithStyle:UITableViewStylePlain];
    _senateLegislatorListVC.sectionTitleGenerator = lastNameTitlesGenerator;
    [_senateLegislatorListVC setSectionIndexTitleGenerator:stateSectionIndexTitleGenerator sectionIndexHandler:legSectionIndexHandler];
    _senateLegislatorListVC.sortIntoSectionsBlock = byLastNameSorterBlock;
    _senateLegislatorListVC.orderItemsInSectionsBlock = lastNameFirstOrderBlock;

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
    _statesLegislatorListVC.items = _legislatorList;
    [_statesLegislatorListVC sortItemsIntoSectionsAndReload];

    // Prep for chamber list viewcontrollers
    NSPredicate *chamberFilterPredicate = [NSPredicate predicateWithFormat:@"chamber MATCHES[c] $chamber"];
    for (NSString *chamber in @[@"House", @"Senate"]) {
        SFLegislatorListViewController *chamberListVC = [_segmentedVC viewControllerForSegmentTitle:chamber];
        chamberListVC.items = [_legislatorList filteredArrayUsingPredicate:
                                       [chamberFilterPredicate predicateWithSubstitutionVariables:@{@"chamber": chamber}]];
        [chamberListVC sortItemsIntoSectionsAndReload];
   }
}

@end
