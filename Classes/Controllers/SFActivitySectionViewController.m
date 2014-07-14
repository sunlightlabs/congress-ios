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
#import "SFDataArchiver.h"
#import "SFFollowHowToView.h"
#import <SAMRateLimit/SAMRateLimit.h>

@interface SFActivitySectionViewController ()

@end

@implementation SFActivitySectionViewController
{
    NSInteger *_currentSegment;
    SFMixedTableViewController *_allActivityVC;
//    SFMixedTableViewController *_followedActivityVC;
//    SFSegmentedViewController *_segmentedVC;
//    SFFollowHowToView *_howToView;
}

static NSString *const CongressAllActivityVC = @"CongressAllActivityVC";
static NSString *const CongressFollowedActivityVC = @"CongressFollowedActivityVC";
static NSString *const CongressSegmentedActivityVC = @"CongressSegmentedActivityVC";

- (id)init {
    self = [super init];

    if (self) {
        [self _initialize];
        self.screenName = @"Activity List Screen";
        self.restorationIdentifier = NSStringFromClass(self.class);
    }
    return self;
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor primaryBackgroundColor];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    /*
       // Set up segmented view
       _segmentedVC.view.frame = [[UIScreen mainScreen] bounds];
       [self.view addSubview:_segmentedVC.view];
       [_segmentedVC didMoveToParentViewController:self];
       [_segmentedVC displayViewForSegment:_segmentedVC.currentSegmentIndex];

       // add howto view
       [self.view addSubview:_howToView];
     */

    // Add _allActivityVC to this controller.
    // In place of segmented view
    [self addChildViewController:_allActivityVC];
    _allActivityVC.view.frame = [[UIScreen mainScreen] bounds];
    [self.view addSubview:_allActivityVC.tableView];
    [_allActivityVC didMoveToParentViewController:self];
    // In place of segmented view

    __weak SFActivitySectionViewController *weakSelf = self;
    // infinite scroll with rate limit.
    __weak SFMixedTableViewController *weakAllActivityVC = _allActivityVC;
    [_allActivityVC.tableView addPullToRefreshWithActionHandler: ^{
        __strong SFActivitySectionViewController *strongSelf = weakSelf;
        BOOL executed = [SAMRateLimit executeBlock: ^{
                [weakAllActivityVC.tableView.infiniteScrollingView stopAnimating];
                [SFBillService recentlyActedOnBillsWithCompletionBlock: ^(NSArray *resultsArray)
                    {
                        if (!resultsArray) {
                            // Network or other error returns nil
                            [SFMessage showErrorMessageInViewController:strongSelf withMessage:@"Unable to fetch latest actvity"];
                            CLS_LOG(@"Unable to load bills");
                            [weakAllActivityVC.tableView.pullToRefreshView stopAnimating];
                        }
                        else if ([resultsArray count] > 0) {
                            weakAllActivityVC.dataProvider.items = [NSMutableArray arrayWithArray:resultsArray];
                            [weakAllActivityVC sortItemsIntoSectionsAndReload];
                            [weakAllActivityVC.tableView.pullToRefreshView stopAnimatingAndSetLastUpdatedNow];
                        }
                        else {
                            [weakAllActivityVC.tableView.pullToRefreshView stopAnimating];
                        }
                    }];
            } name:@"_allActivityVC-PullToRefresh" limit:5.0f];

        if (!executed) {
            [weakAllActivityVC.tableView.pullToRefreshView stopAnimating];
        }
    }];
    [_allActivityVC.tableView addInfiniteScrollingWithActionHandler: ^{
        __strong SFActivitySectionViewController *strongSelf = weakSelf;
        BOOL executed = [SAMRateLimit executeBlock: ^{
                NSUInteger pageNum = 1 + [weakAllActivityVC.dataProvider.items count] / 20;
                [SFBillService recentlyActedOnBillsWithPage:[NSNumber numberWithUnsignedInteger:pageNum] completionBlock: ^(NSArray *resultsArray)
                    {
                        if (!resultsArray) {
                            // Network or other error returns nil
                            NSString *errorMessage = @"Unable to fetch recently acted on bills.";
                            [SFMessage showErrorMessageInViewController:strongSelf withMessage:errorMessage];
                            CLS_LOG(@"%@", errorMessage);
                        }
                        else if ([resultsArray count] > 0) {
                            NSMutableArray *modifyItems = [NSMutableArray arrayWithArray:weakAllActivityVC.dataProvider.items];
                            [modifyItems addObjectsFromArray:resultsArray];
                            weakAllActivityVC.dataProvider.items = [NSArray arrayWithArray:modifyItems];
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

    /*
       __weak SFMixedTableViewController *weakFollowedVC = _followedActivityVC;
       [_followedActivityVC.tableView addPullToRefreshWithActionHandler:^{
        BOOL executed = [SAMRateLimit executeBlock:^{
            [weakFollowedVC.tableView.infiniteScrollingView stopAnimating];
            NSArray *followedObjects = [weakSelf _getFollowedObjects];
            NSArray *followedBillIds = [followedObjects valueForKeyPath:@"billId"];
            [SFBillService billsWithIds:followedBillIds  completionBlock:^(NSArray *resultsArray)
             {
                 if (resultsArray) {
                     NSSortDescriptor *lastActionSort = [NSSortDescriptor sortDescriptorWithKey:@"lastActionAt" ascending:NO];
                     weakFollowedVC.dataTableDataSource.items = [[NSMutableArray arrayWithArray:resultsArray] sortedArrayUsingDescriptors:@[lastActionSort]];
                 }
                 [weakFollowedVC.tableView.pullToRefreshView stopAnimatingAndSetLastUpdatedNow];
                 [weakFollowedVC.tableView setContentOffset:CGPointMake(weakFollowedVC.tableView.contentOffset.x, 0) animated:YES];
             }];
        } name:@"_followedActivityVC-PullToRefresh" limit:15.0f];

        if (!executed) {
            NSArray *followedObjects = [weakSelf _getFollowedObjects];
            NSSortDescriptor *lastActionSort = [NSSortDescriptor sortDescriptorWithKey:@"lastActionAt" ascending:NO];
            weakFollowedVC.dataTableDataSource.items = [followedObjects sortedArrayUsingDescriptors:@[lastActionSort]];
            [weakFollowedVC.tableView.pullToRefreshView stopAnimatingAndSetLastUpdatedNow];
            [weakFollowedVC.tableView setContentOffset:CGPointMake(weakFollowedVC.tableView.contentOffset.x, 0) animated:YES];
        }
        if (weakFollowedVC.dataTableDataSource.items && [weakFollowedVC.dataTableDataSource.items count] > 0) [weakFollowedVC sortItemsIntoSectionsAndReload];
       }];
       [_followedActivityVC.tableView addInfiniteScrollingWithActionHandler:^{
        BOOL executed = [SAMRateLimit executeBlock:^{
            NSArray *followedObjects = [weakSelf _getFollowedObjects];
            NSArray *followedBillIds = [followedObjects valueForKeyPath:@"billId"];
            [SFBillService billsWithIds:followedBillIds  completionBlock:^(NSArray *resultsArray)
             {
                 if (resultsArray) {
                     NSSortDescriptor *lastActionSort = [NSSortDescriptor sortDescriptorWithKey:@"lastActionAt" ascending:NO];
                     weakFollowedVC.dataTableDataSource.items = [[NSMutableArray arrayWithArray:resultsArray] sortedArrayUsingDescriptors:@[lastActionSort]];
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
     */
    [_allActivityVC.tableView.pullToRefreshView setSubtitle:@"All Activity" forState:SVPullToRefreshStateAll];
    [_allActivityVC.tableView triggerPullToRefresh];
}

- (void)viewDidAppear:(BOOL)animated {
    /*
       BOOL isFollowingObjects = ([[self _getFollowedObjects] count] > 0);
       CGRect contentRect = [self.view convertRect:_segmentedVC.segmentedView.contentView.frame fromView:_segmentedVC.segmentedView];
       _howToView.frame = contentRect;
       _howToView.hidden = isFollowingObjects;
       if (isFollowingObjects) [_followedActivityVC.tableView triggerPullToRefresh];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SegmentedViewController notification handler

/*
   -(void)handleSegmentedViewChange:(NSNotification *)notification
   {
    if ([notification.name isEqualToString:@"SegmentedViewDidChange"]) {
        // Ensure _followedActivityVC gets loaded.
        if ([_segmentedVC.currentViewController isEqual:_followedActivityVC]) {
            BOOL isFollowingObjects = ([[self _getFollowedObjects] count] > 0);
            _howToView.hidden = isFollowingObjects;
            if (isFollowingObjects) [_followedActivityVC.tableView triggerPullToRefresh];
        }
        else
        {
            _howToView.hidden = YES;
        }
    }
   }
 */

#pragma mark - Private/Internal

- (void)_initialize {
    self.title = @"Latest Activity";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem menuButtonWithTarget:self.viewDeckController action:@selector(toggleLeftView)];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    /*
       // Create segmented view
       _segmentedVC = [[self class] newSegmentedViewController];
       [self addChildViewController:_segmentedVC];
     */

    // TODO: Update this to handle variable sort keyPaths when we have multiple models in activity section.
    SFDataTableSectionTitleGenerator lastActionAtTitleBlock = ^NSArray *(NSArray *items) {
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
    SFDataTableSortIntoSectionsBlock lastActionAtSorterBlock = ^NSUInteger (id item, NSArray *sectionTitles) {
        NSDateFormatter *dateFormatter = [SFDateFormatterUtil mediumDateNoTimeFormatter];
        NSString *lastActionAtString = [dateFormatter stringFromDate:((SFBill *)item).lastActionAt];
        NSUInteger index = [sectionTitles indexOfObject:lastActionAtString];
        if (index != NSNotFound) {
            return index;
        }
        return 0;
    };

    _allActivityVC = [[self class] newAllActivityViewController];
    _allActivityVC.dataProvider.sectionTitleGenerator = lastActionAtTitleBlock;
    _allActivityVC.dataProvider.sortIntoSectionsBlock = lastActionAtSorterBlock;

    /*
       _followedActivityVC = [[self class] newFollowedActivityViewController];
       _followedActivityVC.dataTableDataSource.sectionTitleGenerator = lastActionAtTitleBlock;
       _followedActivityVC.dataTableDataSource.sortIntoSectionsBlock = lastActionAtSorterBlock;
     */


//    [_segmentedVC setViewControllers:@[_allActivityVC, _followedActivityVC] titles:@[@"All", @"Followed"]];

//    _howToView = [[SFFollowHowToView alloc] initWithFrame:CGRectZero];
//    _howToView.hidden = YES;


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataLoaded) name:SFDataArchiveLoadedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSegmentedViewChange:) name:@"SegmentedViewDidChange" object:_segmentedVC];
}

- (NSArray *)_getFollowedObjects {
    return [SFBill allObjectsToPersist];
}

+ (SFMixedTableViewController *)newAllActivityViewController {
    SFMixedTableViewController *vc = [[SFMixedTableViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.restorationIdentifier = CongressAllActivityVC;
    vc.restorationClass = [self class];
    return vc;
}

+ (SFMixedTableViewController *)newFollowedActivityViewController {
    SFMixedTableViewController *vc = [[SFMixedTableViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.restorationIdentifier = CongressFollowedActivityVC;
    vc.restorationClass = [self class];
    return vc;
}

+ (SFSegmentedViewController *)newSegmentedViewController {
    SFSegmentedViewController *vc = [SFSegmentedViewController new];
    vc.restorationIdentifier = CongressSegmentedActivityVC;
    vc.restorationClass = [self class];
    return vc;
}

- (void)handleDataLoaded {
//    [_followedActivityVC.tableView triggerPullToRefresh];
}

#pragma mark - UIViewControllerRestoration

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
//    [coder encodeInteger:_segmentedVC.currentSegmentIndex forKey:@"currentSegment"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
//    NSInteger currentSegmentIndex = [coder decodeIntegerForKey:@"currentSegment"];
//    [_segmentedVC displayViewForSegment:currentSegmentIndex];
}

@end
