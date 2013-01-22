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
#import "Bill.h"
#import "SFLegislatorService.h"
#import "Legislator.h"


@implementation SFBillDetailViewController

@synthesize bill = _bill;
@synthesize billDetailView = _billDetailView;

#pragma mark - Accessors

-(void)setBill:(Bill *)bill
{
    _bill = bill;
    _shareableObjects = [NSMutableArray array];
    [_shareableObjects addObject:bill];

    [SFBillService getBillWithId:self.bill.bill_id success:^(AFJSONRequestOperation *operation, id responseObject) {
        self->_bill = (Bill *)responseObject;
        [self updateBillView];
    } failure:^(AFJSONRequestOperation *operation, NSError *error) {
        NSLog(@"SFBillService Error: %@", error.localizedDescription);
    }];
    
}

- (void) updateBillView
{
    if (self.billDetailView) {
        self.billDetailView.titleLabel.text = self.bill.official_title;
        NSString *dateDescr = @"Introduced on: ";
        if (self.bill.introduced_on) {
            NSString *dateString = [self.bill.introduced_on stringWithMediumDateOnly];
            if (dateString != nil) {
                dateDescr = [dateDescr stringByAppendingString:dateString];
            }
        }
        self.billDetailView.dateLabel.text = dateDescr;
        if (self.bill.sponsor != nil)
        {
            self.billDetailView.sponsorName.text =  self.bill.sponsor.full_name;
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
