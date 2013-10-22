//
//  SFLegislatorSegmentedViewController.m
//  Congress
//
//  Created by Daniel Cloud on 6/3/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorSegmentedViewController.h"
#import "SFLegislator.h"
#import "SFLegislatorService.h"
#import "SFLegislatorDetailViewController.h"
#import "SFBillService.h"
#import "SFRollCallVoteService.h"
#import "SFSegmentedViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "SVPullToRefreshView+Congress.h"
#import "SFLegislatorBillsTableViewController.h"
#import "SFLegislatorVotingRecordTableViewController.h"
#import "SFLegislatorActivityItemSource.h"

@interface SFLegislatorSegmentedViewController ()

@end

@implementation SFLegislatorSegmentedViewController
{
    NSArray *_sectionTitles;
    NSInteger *_currentSegmentIndex;
    NSString *_restorationBioguideId;
    SFLegislatorDetailViewController *_legislatorDetailVC;
    SFLegislatorBillsTableViewController *_sponsoredBillsVC;
    SFLegislatorVotingRecordTableViewController *_votesVC;
    SFSegmentedViewController *_segmentedVC;
//    SSLoadingView *_loadingView;
}

static NSString * const CongressLegislatorBillsTableVC = @"CongressLegislatorBillsTableVC";
static NSString * const CongressLegislatorDetailVC = @"CongressLegislatorDetailVC";
static NSString * const CongressLegislatorVotesVC = @"CongressLegislatorVotesVC";
static NSString * const CongressSegmentedLegislatorVC = @"CongressSegmentedLegislatorVC";

static NSString * const LegislatorFetchErrorMessage = @"Unable to fetch legislator";

@synthesize legislator = _legislator;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _initialize];
        self.restorationIdentifier = NSStringFromClass(self.class);
        self.restorationClass = [self class];
        _restorationBioguideId = nil;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bioguideId:(NSString *)bioguideId
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _restorationBioguideId = bioguideId;
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

    _segmentedVC = [[self class] newSegmentedViewController];
    [self addChildViewController:_segmentedVC];
    _segmentedVC.view.frame = self.view.frame;
    [self.view addSubview:_segmentedVC.view];
    [_segmentedVC didMoveToParentViewController:self];

    _legislatorDetailVC = [[self class] newLegislatorDetailViewController];
    _sponsoredBillsVC = [[self class] newSponsoredBillsViewController];
    _votesVC = [[self class] newVotesTableViewController];
    _votesVC.sectionTitleGenerator = votedAtTitleBlock;
    _votesVC.sortIntoSectionsBlock = votedAtSorterBlock;

    [_segmentedVC setViewControllers:@[_legislatorDetailVC, _sponsoredBillsVC, _votesVC] titles:_sectionTitles];
    [_segmentedVC displayViewForSegment:0];

    /* layout */

    NSDictionary *viewDict = @{@"segments": _segmentedVC.view,
                               @"detail": _legislatorDetailVC.view,
                               @"bills": _sponsoredBillsVC.view};

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[segments]|" options:0 metrics:nil views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[segments]|" options:0 metrics:nil views:viewDict]];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_restorationBioguideId) {
        [self setLegislatorWithBioguideId:_restorationBioguideId];
        _restorationBioguideId = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessors

- (void)setLegislatorWithBioguideId:(NSString *)bioguideId
{
    if (bioguideId) {
        __weak SFLegislatorSegmentedViewController *weakSelf = self;
        [SFLegislatorService legislatorWithId:bioguideId completionBlock:^(SFLegislator *legislator) {
            __strong SFLegislatorSegmentedViewController *strongSelf = weakSelf;
            if (legislator) {
                [self setLegislator:legislator];
            }
            else {
//                [_loadingView.activityIndicatorView stopAnimating];
                [SFMessage showErrorMessageInViewController:strongSelf withMessage:LegislatorFetchErrorMessage];
                CLS_LOG(@"%@", LegislatorFetchErrorMessage);
            }
        }];
    }
}

- (void)setLegislator:(SFLegislator *)legislator
{
    _legislator = legislator;

    if (_currentSegmentIndex != nil) {
        [_segmentedVC displayViewForSegment:_currentSegmentIndex];
        _currentSegmentIndex = nil;
    }

    _legislatorDetailVC.legislator = _legislator;
    _votesVC.legislator = _legislator;

    __weak SFLegislator *weakLegislator = _legislator;
//    __weak SFLegislatorSegmentedViewController *weakSelf = self;

//    Fetch sponsored bills
    _sponsoredBillsVC.legislator = _legislator;
    __weak SFLegislatorBillsTableViewController *weakSponsoredBillsVC = _sponsoredBillsVC;
    [_sponsoredBillsVC.tableView addInfiniteScrollingWithActionHandler:^{
        NSInteger billsCount = [weakSponsoredBillsVC.items count];
        NSInteger perPage = 20;
        BOOL executed = [SSRateLimit executeBlock:^{
            NSUInteger pageNum = 1 + billsCount/perPage;
            [SFBillService billsWithSponsorId:weakLegislator.bioguideId page:[NSNumber numberWithInt:pageNum] completionBlock:^(NSArray *resultsArray) {
                if (!resultsArray) {
                    // Network or other error returns nil
//                    [SFMessage showErrorMessageInViewController:strongSelf withMessage:BillsFetchErrorMessage];
                    CLS_LOG(@"Unable to load sponsored bills");
                    [weakSponsoredBillsVC.tableView.pullToRefreshView stopAnimating];
                }
                else if ([resultsArray count] > 0) {
                    NSArray *existingIds = [weakSponsoredBillsVC.items valueForKeyPath:@"@distinctUnionOfObjects.remoteID"];
                    NSArray *newBills = [resultsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (remoteID IN %@)", existingIds]];
                    NSMutableArray *distinctBills = [NSMutableArray arrayWithArray:weakSponsoredBillsVC.items];
                    [distinctBills addObjectsFromArray:newBills];
                    weakSponsoredBillsVC.items = distinctBills;
                    [weakSponsoredBillsVC sortItemsIntoSectionsAndReload];
                }
                [weakSponsoredBillsVC.tableView.infiniteScrollingView stopAnimating];
            }];
        } name:@"_sponsoredBillsVC-InfiniteScroll" limit:2.0f];
        if (!executed) {
            [weakSponsoredBillsVC.tableView.infiniteScrollingView stopAnimating];
        }
    }];

//    Fetch legislator votes
    __weak SFLegislatorVotingRecordTableViewController *weakVotesVC = _votesVC;
    [_votesVC.tableView addInfiniteScrollingWithActionHandler:^{
//        __strong SFLegislatorSegmentedViewController *strongSelf = weakSelf;
        NSInteger votesCount = [weakVotesVC.items count];
        NSInteger perPage = 20;
        BOOL executed = [SSRateLimit executeBlock:^{
            NSUInteger pageNum = 1 + votesCount/perPage;
            [SFRollCallVoteService votesForLegislator:weakLegislator.bioguideId page:[NSNumber numberWithInt:pageNum] completionBlock:^(NSArray *resultsArray) {
                if (!resultsArray) {
                    // Network or other error returns nil
//                    [SFMessage showErrorMessageInViewController:strongSelf withMessage:@"Unable to fetch votes"];
                    CLS_LOG(@"Unable to fetch legislator's roll call votes");
                }
                else if ([resultsArray count] > 0) {
                    NSArray *existingIds = [weakVotesVC.items valueForKeyPath:@"@distinctUnionOfObjects.remoteID"];
                    NSArray *newObjects = [resultsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (remoteID IN %@)", existingIds]];
                    NSMutableArray *distinctObjects = [NSMutableArray arrayWithArray:weakVotesVC.items];
                    [distinctObjects addObjectsFromArray:newObjects];
                    weakVotesVC.items = distinctObjects;
                    [weakVotesVC sortItemsIntoSectionsAndReload];
                }
                [weakVotesVC.tableView.infiniteScrollingView stopAnimating];
            }];
        } name:@"_votesVC-InfiniteScroll" limit:2.0f];
        if (!executed) {
            [weakVotesVC.tableView.infiniteScrollingView stopAnimating];
        }
    }];

    self.title = _legislator.titledName;
    [self.view layoutSubviews];
    [_sponsoredBillsVC.tableView triggerInfiniteScrolling];
    [_votesVC.tableView triggerInfiniteScrolling];
}

#pragma mark - SFActivity

- (NSArray *)activityItems {
    if (_legislator) {
        return @[[[SFLegislatorTextActivityItemSource alloc] initWithLegislator:_legislator],
                 [[SFLegislatorURLActivityItemSource alloc] initWithLegislator:_legislator]];
    }
    return nil;
}

#pragma mark - Private

-(void)_initialize{
    _sectionTitles = @[@"About", @"Sponsored", @"Votes"];

}

+ (SFSegmentedViewController *)newSegmentedViewController
{
    SFSegmentedViewController *vc = [SFSegmentedViewController new];
    vc.view.translatesAutoresizingMaskIntoConstraints = NO;
    vc.restorationIdentifier = CongressSegmentedLegislatorVC;
    vc.restorationClass = [self class];
    return vc;
}

+ (SFLegislatorBillsTableViewController *)newSponsoredBillsViewController
{
    SFLegislatorBillsTableViewController *vc = [[SFLegislatorBillsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [vc setSectionTitleGenerator:lastActionAtTitleBlock sortIntoSections:lastActionAtSorterBlock
                           orderItemsInSections:nil cellForIndexPathHandler:nil];
    vc.view.translatesAutoresizingMaskIntoConstraints = NO;
    vc.restorationIdentifier = CongressLegislatorBillsTableVC;
    vc.restorationClass = [self class];
    return vc;
}

+ (SFLegislatorDetailViewController *)newLegislatorDetailViewController
{
    SFLegislatorDetailViewController *vc = [SFLegislatorDetailViewController new];
    vc.view.translatesAutoresizingMaskIntoConstraints = NO;
    vc.restorationIdentifier = CongressLegislatorDetailVC;
    vc.restorationClass = [self class];
    return vc;
}

+ (SFLegislatorVotingRecordTableViewController *)newVotesTableViewController
{
    SFLegislatorVotingRecordTableViewController *vc = [[SFLegislatorVotingRecordTableViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.view.translatesAutoresizingMaskIntoConstraints = NO;
    vc.restorationIdentifier = CongressLegislatorVotesVC;
    vc.restorationClass = [self class];
    return vc;
}

#pragma mark - UIViewControllerRestoration

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[SFLegislatorSegmentedViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    NSString *legislatorId = _legislator ? _legislator.bioguideId : _restorationBioguideId;
    [coder encodeObject:legislatorId forKey:@"bioguideId"];
    [coder encodeInteger:[_segmentedVC currentSegmentIndex] forKey:@"segmentIndex"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    _restorationBioguideId = [coder decodeObjectForKey:@"bioguideId"];
    _currentSegmentIndex = [coder decodeIntegerForKey:@"segmentIndex"];
}

@end
