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
#import "SFLegislatorService.h"
#import "SFLegislator.h"


@implementation SFBillDetailViewController

@synthesize bill = _bill;
@synthesize billDetailView = _billDetailView;

#pragma mark - Accessors

-(void)setBill:(SFBill *)bill
{
    _bill = bill;
    _shareableObjects = [NSMutableArray array];
    [_shareableObjects addObject:bill];

    [SFBillService getBillWithId:self.bill.billId completionBlock:^(SFBill *bill) {
        self->_bill = bill;
        [self updateBillView];
    }];
    
}

- (void) updateBillView
{
    if (self.billDetailView) {
        self.billDetailView.titleLabel.text = self.bill.officialTitle;
        NSString *dateDescr = @"Introduced on: ";
        if (self.bill.introducedOn) {
            NSString *dateString = [self.bill.introducedOn stringWithMediumDateOnly];
            if (dateString != nil) {
                dateDescr = [dateDescr stringByAppendingString:dateString];
            }
        }
        self.billDetailView.dateLabel.text = dateDescr;
        if (self.bill.sponsor != nil)
        {
            self.billDetailView.sponsorName.text =  self.bill.sponsor.fullName;
        }
        self.billDetailView.summary.text = self.bill.summary ? self.bill.summary : @"No summary available";
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
