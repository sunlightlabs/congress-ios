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

    [SFBillService getBillWithId:_bill.bill_id success:^(AFJSONRequestOperation *operation, id responseObject) {
        self->_bill = (SFBill *)responseObject;
        [SFLegislatorService getLegislatorWithId:_bill.sponsor_id success:^(AFJSONRequestOperation *operation, id responseObject) {
            SFLegislator *sponsor = (SFLegislator *)responseObject;
            _bill.sponsor = sponsor;
            [self updateBillView];
        } failure:^(AFJSONRequestOperation *operation, NSError *error) {
            NSLog(@"SFLegislatorService Error: %@", error.localizedDescription);
        }];
    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
        NSLog(@"SFBillService Error: %@", error.localizedDescription);
    }];
    
}

- (void) updateBillView
{
    if (self.billDetailView) {
        self.billDetailView.titleLabel.text = self.bill.official_title;
        NSString *dateDescr = @"Introduced on: ";
        self.billDetailView.dateLabel.text = [dateDescr stringByAppendingString:[self.bill.introduced_on stringWithMediumDateOnly]];
        self.billDetailView.sponsorName.text = self.bill.sponsor.name;
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
