//
//  SFActivityListViewController.m
//  Congress
//
//  Created by Daniel Cloud on 11/30/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFActivitySectionViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "SVPullToRefreshView+Congress.h"
#import "SFSegmentedViewController.h"
#import "SFMixedTableViewController.h"
#import "SFBillService.h"
#import "SFBill.h"
#import "SFBillSegmentedViewController.h"
#import "SFDateFormatterUtil.h"

@interface SFActivitySectionViewController ()

@end

@implementation SFActivitySectionViewController
{
    NSInteger *_currentSegment;
    SFMixedTableViewController *_allActivityVC;
    SFMixedTableViewController *_followedActivityVC;
    SFSegmentedViewController *_segmentedVC;
}

static NSString * const CongressAllActivityVC = @"CongressAllActivityVC";
static NSString * const CongressFollowedActivityVC = @"CongressFollowedActivityVC";
static NSString * const CongressSegmentedActivityVC = @"CongressSegmentedActivityVC";

- (id)init
{
    self = [super init];

    if (self) {
        [self _initialize];
        self.trackedViewName = @"Activity List Screen";
        self.restorationIdentifier = NSStringFromClass(self.class);
    }
    return self;
}

-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor primaryBackgroundColor];
	self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _segmentedVC.view.frame = [[UIScreen mainScreen] bounds];
    [self.view addSubview:_segmentedVC.view];
    [_segmentedVC didMoveToParentViewController:self];
    [_segmentedVC displayViewForSegment:_segmentedVC.currentSegmentIndex];

    // infinite scroll with rate limit.
    __weak SFMixedTableViewController *weakAllActivityVC = _allActivityVC;
    [_allActivityVC.tableView addPullToRefreshWithActionHandler:^{
        BOOL executed = [SSRateLimit executeBlock:^{
            [weakAllActivityVC.tableView.infiniteScrollingView stopAnimating];
            [SFBillService recentlyActedOnBillsWithCompletionBlock:^(NSArray *resultsArray)
             {
                 if (resultsArray) {
                     weakAllActivityVC.items = [NSMutableArray arrayWithArray:resultsArray];
                     [weakAllActivityVC sortItemsIntoSectionsAndReload];
                 }
                 [weakAllActivityVC.tableView.pullToRefreshView stopAnimatingAndSetLastUpdatedNow];
             }];
        } name:@"_allActivityVC-PullToRefresh" limit:5.0f];

        if (!executed) {
            [weakAllActivityVC.tableView.pullToRefreshView stopAnimating];
        }
    }];
    [_allActivityVC.tableView addInfiniteScrollingWithActionHandler:^{
        BOOL executed = [SSRateLimit executeBlock:^{
            NSUInteger pageNum = 1 + [weakAllActivityVC.items count]/20;
            [SFBillService recentlyActedOnBillsWithPage:[NSNumber numberWithInt:pageNum] completionBlock:^(NSArray *resultsArray)
            {
                if (resultsArray) {
                    NSMutableArray *modifyItems = [NSMutableArray arrayWithArray:weakAllActivityVC.items];
                    [modifyItems addObjectsFromArray:resultsArray];
                    weakAllActivityVC.items = [NSArray arrayWithArray:modifyItems];
                    [weakAllActivityVC sortItemsIntoSectionsAndReload];
                }
                [weakAllActivityVC.tableView.pullToRefreshView setLastUpdatedNow];
                [weakAllActivityVC.tableView.infiniteScrollingView stopAnimating];

            }];
        } name:@"_allActivityVC-InfiniteScroll" limit:2.0f];

        if (!executed) {
            [weakAllActivityVC.tableView.infiniteScrollingView stopAnimating];
        }

    }];

    __weak SFMixedTableViewController *weakFollowedVC = _followedActivityVC;
    [_followedActivityVC.tableView addPullToRefreshWithActionHandler:^{
        BOOL executed = [SSRateLimit executeBlock:^{
            [weakFollowedVC.tableView.infiniteScrollingView stopAnimating];
            NSArray *followedBills = [SFBill allObjectsToPersist];
            NSArray *followedBillIds = [followedBills valueForKeyPath:@"billId"];
            [SFBillService billsWithIds:followedBillIds  completionBlock:^(NSArray *resultsArray)
             {
                 if (resultsArray) {
                     NSSortDescriptor *lastActionSort = [NSSortDescriptor sortDescriptorWithKey:@"lastActionAt" ascending:NO];
                     weakFollowedVC.items = [[NSMutableArray arrayWithArray:resultsArray] sortedArrayUsingDescriptors:@[lastActionSort]];
                 }
                 [weakFollowedVC.tableView.pullToRefreshView stopAnimatingAndSetLastUpdatedNow];
                 [weakFollowedVC.tableView setContentOffset:CGPointMake(weakFollowedVC.tableView.contentOffset.x, 0) animated:YES];
             }];
        } name:@"_followedActivityVC-PullToRefresh" limit:15.0f];

        if (!executed) {
            NSArray *followedBills = [SFBill allObjectsToPersist];
            NSSortDescriptor *lastActionSort = [NSSortDescriptor sortDescriptorWithKey:@"lastActionAt" ascending:NO];
            weakFollowedVC.items = [followedBills sortedArrayUsingDescriptors:@[lastActionSort]];
            [weakFollowedVC.tableView.pullToRefreshView stopAnimatingAndSetLastUpdatedNow];
            [weakFollowedVC.tableView setContentOffset:CGPointMake(weakFollowedVC.tableView.contentOffset.x, 0) animated:YES];
        }
        if (weakFollowedVC.items && [weakFollowedVC.items count] > 0) [weakFollowedVC sortItemsIntoSectionsAndReload];
    }];
    [_followedActivityVC.tableView addInfiniteScrollingWithActionHandler:^{
        BOOL executed = [SSRateLimit executeBlock:^{
            NSArray *followedBills = [SFBill allObjectsToPersist];
            NSArray *followedBillIds = [followedBills valueForKeyPath:@"billId"];
            [SFBillService billsWithIds:followedBillIds  completionBlock:^(NSArray *resultsArray)
             {
                 if (resultsArray) {
                     NSSortDescriptor *lastActionSort = [NSSortDescriptor sortDescriptorWithKey:@"lastActionAt" ascending:NO];
                     weakFollowedVC.items = [[NSMutableArray arrayWithArray:resultsArray] sortedArrayUsingDescriptors:@[lastActionSort]];
                     [weakFollowedVC sortItemsIntoSectionsAndReload];
                 }
                 [weakFollowedVC.tableView.pullToRefreshView setLastUpdatedNow];
                 [weakFollowedVC.tableView.infiniteScrollingView stopAnimating];
             }];

        } name:@"_followedActivityVC-InfiniteScroll" limit:2.0f];

        if (!executed) {
            [weakFollowedVC.tableView.infiniteScrollingView stopAnimating];
        }
        
    }];
    
    [_followedActivityVC.tableView.pullToRefreshView setSubtitle:@"Followed Activity" forState:SVPullToRefreshStateAll];
    [_allActivityVC.tableView.pullToRefreshView setSubtitle:@"All Activity" forState:SVPullToRefreshStateAll];
    [_allActivityVC.tableView triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SegmentedViewController notification handler

-(void)handleSegmentedViewChange:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"SegmentedViewDidChange"]) {
        // Ensure _followedActivityVC gets loaded.
        if ([_segmentedVC.currentViewController isEqual:_followedActivityVC]) {
            [_followedActivityVC.tableView triggerPullToRefresh];
        }
    }
}

#pragma mark - Private/Internal

- (void)_initialize
{
    self.title = @"Latest Activity";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem menuButtonWithTarget:self.viewDeckController action:@selector(toggleLeftView)];

    _segmentedVC = [[self class] newSegmentedViewController];
    [self addChildViewController:_segmentedVC];

    // TODO: Update this to handle variable sort keyPaths when we have multiple models in activity section.
    SFDataTableSectionTitleGenerator lastActionAtTitleBlock = ^NSArray*(NSArray *items) {
        NSArray *possibleSectionTitleValues = [items valueForKeyPath:@"lastActionAt"];
        possibleSectionTitleValues = [possibleSectionTitleValues sortedArrayUsingDescriptors:
                                      @[[NSSortDescriptor sortDescriptorWithKey:@"timeIntervalSince1970" ascending:NO]]];
        NSMutableArray *sectionTitleStrings = [NSMutableArray array];
        NSDateFormatter *dateFormatter = [SFDateFormatterUtil mediumDateNoTimeFormatter];
        for (NSDate *date in possibleSectionTitleValues) {
            [sectionTitleStrings addObject:[dateFormatter stringFromDate:date]];
        }
        NSOrderedSet *sectionTitlesSet = [NSOrderedSet orderedSetWithArray:sectionTitleStrings];
        return [sectionTitlesSet array];
    };
    SFDataTableSortIntoSectionsBlock lastActionAtSorterBlock = ^NSUInteger(id item, NSArray *sectionTitles) {
        NSDateFormatter *dateFormatter = [SFDateFormatterUtil mediumDateNoTimeFormatter];
        NSString *lastActionAtString = [dateFormatter stringFromDate:((SFBill *)item).lastActionAt];
        NSUInteger index = [sectionTitles indexOfObject:lastActionAtString];
        if (index != NSNotFound) {
            return index;
        }
        return 0;
    };

    _allActivityVC = [[self class] newAllActivityViewController];
    _allActivityVC.sectionTitleGenerator = lastActionAtTitleBlock;
    _allActivityVC.sortIntoSectionsBlock = lastActionAtSorterBlock;

    _followedActivityVC = [[self class] newFollowedActivityViewController];
    _followedActivityVC.sectionTitleGenerator = lastActionAtTitleBlock;
    _followedActivityVC.sortIntoSectionsBlock = lastActionAtSorterBlock;

    
    [_segmentedVC setViewControllers:@[_allActivityVC, _followedActivityVC] titles:@[@"All", @"Followed"]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSegmentedViewChange:) name:@"SegmentedViewDidChange" object:_segmentedVC];
}

+ (SFMixedTableViewController *)newAllActivityViewController
{
    SFMixedTableViewController *vc = [[SFMixedTableViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.restorationIdentifier = CongressAllActivityVC;
    vc.restorationClass = [self class];
    return vc;
}

+ (SFMixedTableViewController *)newFollowedActivityViewController
{
    SFMixedTableViewController *vc = [[SFMixedTableViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.restorationIdentifier = CongressFollowedActivityVC;
    vc.restorationClass = [self class];
    return vc;
}

+ (SFSegmentedViewController *)newSegmentedViewController
{
    SFSegmentedViewController *vc = [SFSegmentedViewController new];
    vc.restorationIdentifier = CongressSegmentedActivityVC;
    vc.restorationClass = [self class];
    return vc;
}

#pragma mark - UIViewControllerRestoration

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    [coder encodeInteger:_segmentedVC.currentSegmentIndex forKey:@"currentSegment"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    NSInteger currentSegmentIndex = [coder decodeIntegerForKey:@"currentSegment"];
    [_segmentedVC displayViewForSegment:currentSegmentIndex];
}

@end
