//
//  SFBillSegmentedViewController.m
//  Congress
//
//  Created by Daniel Cloud on 12/4/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFBillSegmentedViewController.h"
#import "SFBillDetailView.h"
#import "SFBillService.h"
#import "SFSegmentedViewController.h"
#import "SFBillDetailViewController.h"
#import "SFActionTableViewController.h"
#import "SFBill.h"
#import "SFLegislatorService.h"
#import "SFLegislator.h"
#import "SFRollCallVoteService.h"


@implementation SFBillSegmentedViewController
{
    NSArray *_sectionTitles;
    SFActionTableViewController *_actionListVC;
    SFBillDetailViewController *_billDetailVC;
    SFSegmentedViewController *_segmentedVC;
    SSLoadingView *_loadingView;
}

@synthesize bill = _bill;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        [self _initialize];
    }
    return self;
}

-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.view = view;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.backBarButtonItem = [UIBarButtonItem backButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessors

-(void)setBill:(SFBill *)bill
{
    _bill = bill;
    _shareableObjects = [NSMutableArray array];
    [_shareableObjects addObject:bill];
    [_shareableObjects addObject:bill.shareURL];

    [self.view addSubview:_loadingView];
    [self.view bringSubviewToFront:_loadingView];

    __weak SFBillSegmentedViewController *weakSelf = self;
    [SFBillService billWithId:self.bill.billId completionBlock:^(SFBill *bill) {
        __strong SFBillSegmentedViewController *strongSelf = weakSelf;
        if (bill) {
            strongSelf->_bill = bill;
        }
        strongSelf->_billDetailVC.bill = bill;
        _actionListVC.items = [bill.actions sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"actedAt" ascending:NO]]];

        [strongSelf.view layoutSubviews];
        [_loadingView fadeOutAndRemoveFromSuperview];
        [SFRollCallVoteService votesForBill:bill.billId completionBlock:^(NSArray *resultsArray) {
            strongSelf->_bill.rollCallVotes = resultsArray;
            strongSelf->_actionListVC.items = bill.actionsAndVotes;
            [strongSelf->_actionListVC sortItemsIntoSectionsAndReload];
        }];

    }];

    self.title = bill.displayName;
    [self.view layoutSubviews];
}

#pragma mark - Private

-(void)_initialize{
    _sectionTitles = @[@"Summary", @"Activity"];

    _segmentedVC = [[SFSegmentedViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:_segmentedVC];
    _segmentedVC.view.frame = self.view.frame;
    [self.view addSubview:_segmentedVC.view];
    [_segmentedVC didMoveToParentViewController:self];

    
    _actionListVC = [[SFActionTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _billDetailVC = [[SFBillDetailViewController alloc] initWithNibName:nil bundle:nil];
    [_segmentedVC setViewControllers:@[_billDetailVC, _actionListVC] titles:_sectionTitles];
    [_segmentedVC displayViewForSegment:0];

    CGSize size = self.view.frame.size;
    _loadingView = [[SSLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    _loadingView.backgroundColor = [UIColor primaryBackgroundColor];
    _loadingView.textLabel.text = @"Loading bill info.";
    [self.view addSubview:_loadingView];
}

@end
