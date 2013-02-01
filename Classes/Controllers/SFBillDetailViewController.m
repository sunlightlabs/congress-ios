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
#import "SFLegislator.h"


@implementation SFBillDetailViewController
{
    SFBillDetailView *_billDetailView;
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
    [self updateBillView];
}

#pragma mark - Private

-(void)_initialize{
    _billDetailView = [[SFBillDetailView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = _billDetailView;
}


- (void)updateBillView
{
    self.title = _bill.displayName;

    _billDetailView.titleLabel.text = self.bill.officialTitle;
    NSString *dateDescr = @"Introduced on: ";
    if (_bill.introducedOn) {
        NSString *dateString = [_bill.introducedOn stringWithMediumDateOnly];
        if (dateString != nil) {
            dateDescr = [dateDescr stringByAppendingString:dateString];
        }
    }
    _billDetailView.dateLabel.text = dateDescr;
    if (_bill.sponsor != nil)
    {
        _billDetailView.sponsorName.text =  _bill.sponsor.fullName;
    }
    _billDetailView.summary.text = _bill.summary ? _bill.summary : @"No summary available";

    [self.view layoutSubviews];
}

@end
