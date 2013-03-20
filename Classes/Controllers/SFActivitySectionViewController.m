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
#import "UIScrollView+SVPullToRefresh.h"
#import "SFSegmentedViewController.h"
#import "SFMixedTableViewController.h"
#import "SFBillService.h"
#import "SFBill.h"
#import "SFBillSegmentedViewController.h"
#import "SFBillCell.h"

@interface SFActivitySectionViewController ()

@end

@implementation SFActivitySectionViewController
{
    BOOL _updating;
    SFMixedTableViewController *_allActivityVC;
    SFMixedTableViewController *_followedActivityVC;
    SFSegmentedViewController *_segmentedVC;
}

- (id)init
{
    self = [super init];

    if (self) {
        [self _initialize];
        self.trackedViewName = @"Activity List Screen";
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

    _segmentedVC.view.frame = self.view.frame;
    [self.view addSubview:_segmentedVC.view];
    [_segmentedVC didMoveToParentViewController:self];
    [_segmentedVC displayViewForSegment:0];

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
                 [strongVC.tableView.pullToRefreshView stopAnimating];
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
                    [strongVC.items addObjectsFromArray:resultsArray];
                    [strongVC.tableView reloadData];
                }
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
                 [strongVC.tableView.pullToRefreshView stopAnimating];

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
                 [strongVC.tableView.infiniteScrollingView stopAnimating];
             }];

        } name:@"_followedActivityVC-InfiniteScroll" limit:2.0f];

        if (!executed) {
            [strongVC.tableView.infiniteScrollingView stopAnimating];
        }
        
    }];

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
    self.navigationItem.backBarButtonItem = [UIBarButtonItem backButton];

    self->_updating = NO;
    _segmentedVC = [[SFSegmentedViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:_segmentedVC];

    _allActivityVC = [[SFMixedTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _followedActivityVC = [[SFMixedTableViewController alloc] initWithStyle:UITableViewStylePlain];

    [_segmentedVC setViewControllers:@[_allActivityVC, _followedActivityVC] titles:@[@"All", @"Followed"]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSegmentedViewChange:) name:@"SegmentedViewDidChange" object:_segmentedVC];
}

@end
