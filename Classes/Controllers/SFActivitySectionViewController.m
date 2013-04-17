//
//  SFActivityListViewController.m
//  Congress
//
//  Created by Daniel Cloud on 11/30/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFActivitySectionViewController.h"
#import "IIViewDeckController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "SVPullToRefreshView+Congress.h"
#import "SFSegmentedViewController.h"
#import "SFMixedTableViewController.h"
#import "SFBillService.h"
#import "SFBill.h"
#import "SFBillSegmentedViewController.h"

@interface SFActivitySectionViewController () <UIViewControllerRestoration>

@end

@implementation SFActivitySectionViewController
{
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
        __strong SFMixedTableViewController *strongVC = weakAllActivityVC;
        BOOL executed = [SSRateLimit executeBlock:^{
            [strongVC.tableView.infiniteScrollingView stopAnimating];
            [SFBillService recentlyActedOnBillsWithCompletionBlock:^(NSArray *resultsArray)
             {
                 if (resultsArray) {
                     strongVC.items = [NSMutableArray arrayWithArray:resultsArray];
                     [strongVC.tableView reloadData];
                 }
                 [strongVC.tableView.pullToRefreshView stopAnimatingAndSetLastUpdatedNow];
             }];
        } name:@"_allActivityVC-PullToRefresh" limit:5.0f];

        if (!executed) {
            [strongVC.tableView.pullToRefreshView stopAnimating];
        }
    }];
    [_allActivityVC.tableView addInfiniteScrollingWithActionHandler:^{
        __strong SFMixedTableViewController *strongVC = weakAllActivityVC;
        BOOL executed = [SSRateLimit executeBlock:^{
            NSUInteger pageNum = 1 + [strongVC.items count]/20;
            [SFBillService recentlyActedOnBillsWithPage:[NSNumber numberWithInt:pageNum] completionBlock:^(NSArray *resultsArray)
            {
                if (resultsArray) {
                    NSMutableArray *modifyItems = [NSMutableArray arrayWithArray:strongVC.items];
                    [modifyItems addObjectsFromArray:resultsArray];
                    strongVC.items = [NSArray arrayWithArray:modifyItems];
                    [strongVC.tableView reloadData];
                }
                [strongVC.tableView.pullToRefreshView setLastUpdatedNow];
                [strongVC.tableView.infiniteScrollingView stopAnimating];

            }];
        } name:@"_allActivityVC-InfiniteScroll" limit:2.0f];

        if (!executed) {
            [strongVC.tableView.infiniteScrollingView stopAnimating];
        }

    }];

    __weak SFMixedTableViewController *weakFollowedVC = _followedActivityVC;
    [_followedActivityVC.tableView addPullToRefreshWithActionHandler:^{
        __strong SFMixedTableViewController *strongVC = weakFollowedVC;
        BOOL executed = [SSRateLimit executeBlock:^{
            [strongVC.tableView.infiniteScrollingView stopAnimating];
            NSArray *followedBills = [SFBill allObjectsToPersist];
            NSArray *followedBillIds = [followedBills valueForKeyPath:@"billId"];
            [SFBillService billsWithIds:followedBillIds  completionBlock:^(NSArray *resultsArray)
             {
                 if (resultsArray) {
                     strongVC.items = [NSMutableArray arrayWithArray:resultsArray];
                     [strongVC.tableView reloadData];
                 }
                 [strongVC.tableView.pullToRefreshView stopAnimatingAndSetLastUpdatedNow];
             }];
        } name:@"_followedActivityVC-PullToRefresh" limit:5.0f];

        if (!executed) {
            [strongVC.tableView.pullToRefreshView stopAnimating];
        }
    }];
    [_followedActivityVC.tableView addInfiniteScrollingWithActionHandler:^{
        __strong SFMixedTableViewController *strongVC = weakFollowedVC;
        BOOL executed = [SSRateLimit executeBlock:^{
//            NSUInteger pageNum = 1 + [strongVC.items count]/20;
            NSArray *followedBills = [SFBill allObjectsToPersist];
            NSArray *followedBillIds = [followedBills valueForKeyPath:@"billId"];
            [SFBillService billsWithIds:followedBillIds  completionBlock:^(NSArray *resultsArray)
             {
                 if (resultsArray) {
                     strongVC.items = [NSMutableArray arrayWithArray:resultsArray];
                     [strongVC.tableView reloadData];
                 }
                 [strongVC.tableView.pullToRefreshView setLastUpdatedNow];
                 [strongVC.tableView.infiniteScrollingView stopAnimating];
             }];

        } name:@"_followedActivityVC-InfiniteScroll" limit:2.0f];

        if (!executed) {
            [strongVC.tableView.infiniteScrollingView stopAnimating];
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

    _allActivityVC = [[self class] newAllActivityViewController];
    _followedActivityVC = [[self class] newFollowedActivityViewController];

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

#pragma mark - Application state

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {

    if (_segmentedVC.restorationIdentifier) {
        [coder encodeObject:_segmentedVC forKey:_segmentedVC.restorationIdentifier];
    }
    if (_allActivityVC.restorationIdentifier) {
        [coder encodeObject:_allActivityVC forKey:_allActivityVC.restorationIdentifier];
    }
    if (_followedActivityVC.restorationIdentifier) {
        [coder encodeObject:_followedActivityVC forKey:_followedActivityVC.restorationIdentifier];
    }
//    [coder encodeInteger:_segmentedVC.currentSegmentIndex forKey:@"currentSegmentIndex"];
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
//    NSInteger currentSegmentIndex = [coder decodeIntegerForKey:@"currentSegmentIndex"];
//    [_segmentedVC displayViewForSegment:currentSegmentIndex];
    [super decodeRestorableStateWithCoder:coder];
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    NSLog(@"\n===SFActivitySectionViewController===\n%@\n========================", [identifierComponents componentsJoinedByString:@"/"]);
    NSString *lastObjectName = [identifierComponents lastObject];

    if ([lastObjectName isEqualToString:CongressSegmentedActivityVC]) {
        return [[self class] newSegmentedViewController];
    }
    if ([lastObjectName isEqualToString:CongressAllActivityVC]) {
        return [[self class] newAllActivityViewController];
    }
    if ([lastObjectName isEqualToString:CongressFollowedActivityVC]) {
        return [[self class] newFollowedActivityViewController];
    }

    return nil;
}

@end
