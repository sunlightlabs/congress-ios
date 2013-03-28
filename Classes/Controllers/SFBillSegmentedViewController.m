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

@interface SFBillSegmentedViewController () <UIViewControllerRestoration>

@end

@implementation SFBillSegmentedViewController
{
    NSArray *_sectionTitles;
    SFActionTableViewController *_actionListVC;
    SFBillDetailViewController *_billDetailVC;
    SFSegmentedViewController *_segmentedVC;
    SSLoadingView *_loadingView;
}

static NSString * const CongressActionTableVC = @"CongressActionTableVC";
static NSString * const CongressBillDetailVC = @"CongressBillDetailVC";
static NSString * const CongressSegmentedBillVC = @"CongressSegmentedBillVC";

@synthesize bill = _bill;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        [self _initialize];
        self.restorationIdentifier = NSStringFromClass(self.class);
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

    _segmentedVC = [[self class] newSegmentedViewController];
    [self addChildViewController:_segmentedVC];
    _segmentedVC.view.frame = self.view.frame;
    [self.view addSubview:_segmentedVC.view];
    [_segmentedVC didMoveToParentViewController:self];

    
    _actionListVC = [[self class] newActionTableController];
    _billDetailVC = [[self class] newBillDetailViewController];
    [_segmentedVC setViewControllers:@[_billDetailVC, _actionListVC] titles:_sectionTitles];
    [_segmentedVC displayViewForSegment:0];

    CGSize size = self.view.frame.size;
    _loadingView = [[SSLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    _loadingView.backgroundColor = [UIColor primaryBackgroundColor];
    _loadingView.textLabel.text = @"Loading bill info.";
    [self.view addSubview:_loadingView];
}

+ (SFSegmentedViewController *)newSegmentedViewController
{
    SFSegmentedViewController *vc = [SFSegmentedViewController new];
    vc.restorationIdentifier = CongressSegmentedBillVC;
    vc.restorationClass = [self class];
    return vc;
}

+ (SFActionTableViewController *)newActionTableController
{
    SFActionTableViewController *vc = [[SFActionTableViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.restorationIdentifier = CongressActionTableVC;
    vc.restorationClass = [self class];
    return vc;
}

+ (SFBillDetailViewController *)newBillDetailViewController
{
    SFBillDetailViewController *vc = [SFBillDetailViewController new];
    vc.restorationIdentifier = CongressBillDetailVC;
    vc.restorationClass = [self class];
    return vc;
}

#pragma mark - Application state

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {

    if (_segmentedVC.restorationIdentifier) {
        [coder encodeObject:_segmentedVC forKey:_segmentedVC.restorationIdentifier];
    }
    if (_actionListVC.restorationIdentifier) {
        [coder encodeObject:_actionListVC forKey:_actionListVC.restorationIdentifier];
    }
    if (_billDetailVC.restorationIdentifier) {
        [coder encodeObject:_billDetailVC forKey:_billDetailVC.restorationIdentifier];
    }
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {

    [super decodeRestorableStateWithCoder:coder];
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    NSString *lastObjectName = [identifierComponents lastObject];

    if ([lastObjectName isEqualToString:CongressActionTableVC]) {
        return [[self class] newActionTableController];
    }
    if ([lastObjectName isEqualToString:CongressBillDetailVC]) {
        return [[self class] newBillDetailViewController];
    }
    if ([lastObjectName isEqualToString:CongressSegmentedBillVC]) {
        return [[self class] newSegmentedViewController];
    }

    return nil;
}

@end
