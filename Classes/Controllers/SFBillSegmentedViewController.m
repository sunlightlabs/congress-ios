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
#import "SFActionListViewController.h"
#import "SFBill.h"
#import "SFLegislatorService.h"
#import "SFLegislator.h"


@implementation SFBillSegmentedViewController
{
    NSArray *_sectionTitles;
    SFActionListViewController *_actionListVC;
    SFBillDetailViewController *_billDetailVC;
    SFSegmentedViewController *_segmentedVC;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

    [SFBillService getBillWithId:self.bill.billId completionBlock:^(SFBill *bill) {
        if (bill) {
            self->_bill = bill;
        }
        _billDetailVC.bill = bill;
        _actionListVC.dataArray = bill.actions;
    }];
    [self.view layoutSubviews];
}

#pragma mark - Private

-(void)_initialize{
    _sectionTitles = @[@"Summary", @"Activities"];


    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];

    _segmentedVC = [[SFSegmentedViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:_segmentedVC];
    _segmentedVC.view.frame = self.view.frame;
    [self.view addSubview:_segmentedVC.view];
    [_segmentedVC didMoveToParentViewController:self];

    
    _actionListVC = [[SFActionListViewController alloc] initWithNibName:nil bundle:nil];
    _billDetailVC = [[SFBillDetailViewController alloc] initWithNibName:nil bundle:nil];
    [_segmentedVC setViewControllers:@[_billDetailVC, _actionListVC] titles:_sectionTitles];
    [_segmentedVC displayViewForSegment:0];
}

@end
