//
//  SFBillDetailViewController.m
//  Congress
//
//  Created by Daniel Cloud on 12/4/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFBillDetailViewController.h"
#import "SFBillDetailView.h"
#import "SFBillService.h"
#import "SFBill.h"

@interface SFBillDetailViewController ()


@end


@implementation SFBillDetailViewController

@synthesize bill = _bill;
@synthesize billDetailView = _billDetailView;

#pragma mark - Accessors

-(void)setBill:(SFBill *)bill
{
    _bill = bill;

    [SFBillService getBillWithId:_bill.bill_id success:^(AFJSONRequestOperation *operation, id responseObject) {
        self->_bill = (SFBill *)responseObject;
        [self updateBillView];
    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
        NSLog(@"SFBillService Error: %@", error.localizedDescription);
    }];
    
}

- (void) updateBillView
{
    if (self.billDetailView) {
        self.billDetailView.billTitleLabel.text = self.bill.official_title;
        self.billDetailView.billIdLabel.text = self.bill.bill_id;
        self.billDetailView.billSummary.text = self.bill.official_title; // For now...
        //        _billDetailView.billSummary.text = (_bill.summary ? _bill.summary : @"Summary unavailable");
        [self.billDetailView layoutSubviews];
    }

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        [self _initialize];
    }
    return self;
}

- (void) loadView {
    _billDetailView.frame = [[UIScreen mainScreen] applicationFrame];
    _billDetailView.autoresizesSubviews = YES;
    self.view = _billDetailView;
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

#pragma mark - Private

-(void)_initialize{
    if (!_billDetailView) {
        _billDetailView = [[SFBillDetailView alloc] initWithFrame:CGRectZero];
        _billDetailView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
}

@end
