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
#import "SFLegislatorSegmentedViewController.h"
#import "SFLocalLegislatorsViewController.h"

@implementation SFLegislatorsSectionViewController
{
    BOOL _updating;
    NSInteger *_currentSegmentIndex;
    NSArray *_sectionTitles;
    SFLegislatorTableViewController *_statesLegislatorListVC;
    SFLegislatorTableViewController *_houseLegislatorListVC;
    SFLegislatorTableViewController *_senateLegislatorListVC;
    SFSegmentedViewController *_segmentedVC;
    UIActivityIndicatorView *_activityIndicatorView;
    UIBarButtonItem *_locatorButton;
}

static NSString *const LegislatorsFetchErrorMessage = @"Unable to fetch legislators";

@synthesize legislatorList = _legislatorList;
@synthesize legislatorsLoaded;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([view respondsToSelector:@selector(setTintColor:)]) {
        [view setTintColor:[UIColor defaultTintColor]];
    }
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem menuButtonWithTarget:self.viewDeckController action:@selector(toggleLeftView)];
    self.navigationItem.rightBarButtonItem = _locatorButton;

    // View has been loaded, so put _segmentedVC's view into it and display
    _segmentedVC.view.frame = self.view.frame;
    [self.view addSubview:_segmentedVC.view];
    [_segmentedVC didMoveToParentViewController:self];
    [_segmentedVC displayViewForSegment:0];

    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.hidesWhenStopped = YES;
    _activityIndicatorView.center = self.view.center;
    _activityIndicatorView.top = floor(self.view.height / 3.0f);
    [self.view addSubview:_activityIndicatorView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_currentSegmentIndex != nil) {
        [_segmentedVC displayViewForSegment:_currentSegmentIndex];
        _currentSegmentIndex = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.legislatorsLoaded) {
        [self _updateLegislators];
    }
    [self.navigationItem.rightBarButtonItem setAccessibilityLabel:@"Local Legislators"];
    [self.navigationItem.rightBarButtonItem setAccessibilityHint:@"Find who represents your current location"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private/Internal

- (void)_initialize {
    self.restorationIdentifier = NSStringFromClass(self.class);
    self.title = @"Legislators";
    self.legislatorList = [NSMutableArray array];

    self.legislatorsLoaded = NO;
    _currentSegmentIndex = nil;
    _sectionTitles = @[@"States", @"House", @"Senate"];

    _segmentedVC = [[SFSegmentedViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:_segmentedVC];

    _statesLegislatorListVC = [[SFLegislatorTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _statesLegislatorListVC.dataProvider.sectionTitleGenerator = stateTitlesGenerator;
    [_statesLegislatorListVC.dataProvider setSectionIndexTitleGenerator:stateSectionIndexTitleGenerator sectionIndexHandler:legSectionIndexHandler];
    _statesLegislatorListVC.dataProvider.sortIntoSectionsBlock = byStateSorterBlock;

    _houseLegislatorListVC = [[SFLegislatorTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _houseLegislatorListVC.dataProvider.sectionTitleGenerator = lastNameTitlesGenerator;
    [_houseLegislatorListVC.dataProvider setSectionIndexTitleGenerator:stateSectionIndexTitleGenerator sectionIndexHandler:legSectionIndexHandler];
    _houseLegislatorListVC.dataProvider.sortIntoSectionsBlock = byLastNameSorterBlock;
    _houseLegislatorListVC.dataProvider.orderItemsInSectionsBlock = lastNameFirstOrderBlock;

    _senateLegislatorListVC = [[SFLegislatorTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _senateLegislatorListVC.dataProvider.sectionTitleGenerator = lastNameTitlesGenerator;
    [_senateLegislatorListVC.dataProvider setSectionIndexTitleGenerator:stateSectionIndexTitleGenerator sectionIndexHandler:legSectionIndexHandler];
    _senateLegislatorListVC.dataProvider.sortIntoSectionsBlock = byLastNameSorterBlock;
    _senateLegislatorListVC.dataProvider.orderItemsInSectionsBlock = lastNameFirstOrderBlock;

    [_segmentedVC setViewControllers:@[_statesLegislatorListVC, _houseLegislatorListVC, _senateLegislatorListVC] titles:_sectionTitles];

    _locatorButton = [UIBarButtonItem locationButtonWithTarget:self action:@selector(locateLegislators)];
    [_locatorButton setAccessibilityLabel:@"Local Legislators"];
    [_locatorButton setAccessibilityHint:@"Find who represents your current location"];
}

- (void)_updateLegislators {
    [_activityIndicatorView startAnimating];
    __weak SFLegislatorsSectionViewController *weakSelf = self;
    [SFLegislatorService allLegislatorsInOfficeWithCompletionBlock: ^(NSArray *resultsArray) {
        if (!resultsArray) {
            // Network or other error returns nil
            [SFMessage showErrorMessageInViewController:self withMessage:LegislatorsFetchErrorMessage];
            CLS_LOG(@"%@", LegislatorsFetchErrorMessage);
        }
        else if ([resultsArray count] > 0) {
            weakSelf.legislatorList = resultsArray;
            [weakSelf divvyLegislators];
            [weakSelf setLegislatorsLoaded:YES];
        }
        [_activityIndicatorView stopAnimating];
    }];
}

- (void)divvyLegislators {
    // Set up States list viewcontrollers
    _statesLegislatorListVC.dataProvider.items = _legislatorList;
    [_statesLegislatorListVC sortItemsIntoSectionsAndReload];

    // Prep for chamber list viewcontrollers
    NSPredicate *chamberFilterPredicate = [NSPredicate predicateWithFormat:@"chamber MATCHES[c] $chamber"];
    for (NSString *chamber in @[@"House", @"Senate"]) {
        SFLegislatorTableViewController *chamberListVC = [_segmentedVC viewControllerForSegmentTitle:chamber];
        NSArray *chamberLegislators = [_legislatorList filteredArrayUsingPredicate:
                                       [chamberFilterPredicate predicateWithSubstitutionVariables:@{ @"chamber": chamber }]];
        chamberListVC.dataProvider.items = chamberLegislators;
        [chamberListVC sortItemsIntoSectionsAndReload];
    }
}

- (void)locateLegislators {
    SFLocalLegislatorsViewController *localController = [SFLocalLegislatorsViewController new];
    [self.navigationController pushViewController:localController animated:YES];
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
