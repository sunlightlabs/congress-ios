//
//  SFBillDetailViewController.m
//  Congress
//
//  Created by Daniel Cloud on 12/4/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFBillDetailViewController.h"
#import "SFBillDetailView.h"
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
    if (_billDetailView) {
        _billDetailView.billTitleLabel.text = _bill.official_title;
        _billDetailView.billSummary.text = _bill.official_title; // For now...
//        _billDetailView.billSummary.text = (_bill.summary ? _bill.summary : @"Summary unavailable");
        [_billDetailView layoutIfNeeded];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Bill Detail View";
        CGRect initialRect = CGRectMake(10.0f, 10.0f, 100.0f, 160.0f);
        _billDetailView = [[SFBillDetailView alloc] initWithFrame:initialRect];
        [self setView:_billDetailView];
        
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

@end
