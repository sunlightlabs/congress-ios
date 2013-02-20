//
//  SFActivityListViewController.m
//  Congress
//
//  Created by Daniel Cloud on 11/30/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFActivityListViewController.h"
#import "IIViewDeckController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "SFSegmentedViewController.h"
#import "SFMixedTableViewController.h"
#import "SFBillService.h"
#import "SFBill.h"
#import "SFBillSegmentedViewController.h"
#import "SFBillCell.h"

@interface SFActivityListViewController ()

@end

@implementation SFActivityListViewController
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

    _segmentedVC.view.frame = self.view.frame;
    [self.view addSubview:_segmentedVC.view];
    [_segmentedVC didMoveToParentViewController:self];
    [_segmentedVC displayViewForSegment:0];

    // infinite scroll with rate limit.
    __weak SFActivityListViewController *weakSelf = self;
    __weak SFMixedTableViewController *weakAllActivityVC = _allActivityVC;
    __weak SFMixedTableViewController *weakFollowedVC = _followedActivityVC;
    [_allActivityVC.tableView addInfiniteScrollingWithActionHandler:^{
        BOOL executed = [SSRateLimit executeBlock:^{
            [weakSelf setIsUpdating:YES];
            NSUInteger pageNum = 1 + [weakAllActivityVC.items count]/20;
            [SFBillService recentlyActedOnBillsWithPage:[NSNumber numberWithInt:pageNum] completionBlock:^(NSArray *resultsArray)
            {
                if (resultsArray) {
                    [weakAllActivityVC.items addObjectsFromArray:resultsArray];
                    [weakAllActivityVC.tableView reloadData];
                    NSPredicate *isPersisted = [NSPredicate predicateWithFormat:@"persist == TRUE"];
                    NSArray *followedObjects = [weakAllActivityVC.items filteredArrayUsingPredicate:isPersisted];
                    [weakFollowedVC.items addObjectsFromArray:followedObjects];
                    [weakFollowedVC.tableView reloadData];
                }
                [weakAllActivityVC.tableView.infiniteScrollingView stopAnimating];
                [weakSelf setIsUpdating:NO];

            }];
        } name:@"SFActivityListViewController-InfiniteScroll" limit:2.0f];

        if (!executed & ![weakSelf isUpdating]) {
            [weakAllActivityVC.tableView.infiniteScrollingView stopAnimating];
        }

    }];

    [_allActivityVC.tableView triggerInfiniteScrolling];
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

#pragma mark - Private/Internal

- (void)_initialize
{
    self.title = @"Latest Activity";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem settingsButtonWithTarget:self.viewDeckController action:@selector(toggleLeftView)];
    self.navigationItem.backBarButtonItem = [UIBarButtonItem backButton];

    self->_updating = NO;
    _segmentedVC = [[SFSegmentedViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:_segmentedVC];

    _allActivityVC = [[SFMixedTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _followedActivityVC = [[SFMixedTableViewController alloc] initWithStyle:UITableViewStylePlain];

    [_segmentedVC setViewControllers:@[_allActivityVC, _followedActivityVC] titles:@[@"All", @"Followed"]];
}

@end
