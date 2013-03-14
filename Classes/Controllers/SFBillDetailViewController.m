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
#import "SFLegislatorDetailViewController.h"
#import "SFLegislatorListViewController.h"
#import "SFCongressURLService.h"
#import "SFLegislatorService.h"

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
    [_billDetailView.linkOutButton addTarget:self action:@selector(handleLinkOutPress) forControlEvents:UIControlEventTouchUpInside];
    [_billDetailView.sponsorButton addTarget:self action:@selector(handleSponsorPress) forControlEvents:UIControlEventTouchUpInside];
    [_billDetailView.cosponsorsButton addTarget:self action:@selector(handleCosponsorsPress) forControlEvents:UIControlEventTouchUpInside];
}


- (void)updateBillView
{
    self.title = _bill.displayName;

    _billDetailView.titleLabel.text = self.bill.officialTitle;
    if (_bill.introducedOn) {
        NSString *descriptorString = @"Introduced";
        NSString *dateString = [_bill.introducedOn stringWithMediumDateOnly];
        NSString *subtitleString = [NSString stringWithFormat:@"%@ %@", descriptorString, dateString];
        NSMutableAttributedString *subtitleAttrString = [[NSMutableAttributedString alloc] initWithString:subtitleString];
        NSRange introRange = [subtitleString rangeOfString:descriptorString];
        NSRange postIntroRange = [subtitleString rangeOfString:dateString];
        [subtitleAttrString addAttribute:NSFontAttributeName value:[UIFont h2EmFont] range:introRange];
        [subtitleAttrString addAttribute:NSFontAttributeName value:[UIFont h2Font] range:postIntroRange];
        _billDetailView.subtitleLabel.attributedText = subtitleAttrString;
    }
    if (_bill.sponsor != nil)
    {
        NSMutableAttributedString *sponsorButtonString = [NSMutableAttributedString linkStringFor:_bill.sponsor.fullName];
        [_billDetailView.sponsorButton setAttributedTitle:sponsorButtonString forState:UIControlStateNormal];
        sponsorButtonString = [NSMutableAttributedString highlightedLinkStringFor:_bill.sponsor.fullName];
        [_billDetailView.sponsorButton setAttributedTitle:sponsorButtonString forState:UIControlStateHighlighted];
    }
    if (_bill.cosponsorIds) {
        NSString *coSponsorDesc = [NSString stringWithFormat:@"+ %lu others", (unsigned long)[_bill.cosponsorIds count]];
        NSMutableAttributedString *attribString = [NSMutableAttributedString linkStringFor:coSponsorDesc];
        [_billDetailView.cosponsorsButton setAttributedTitle:attribString forState:UIControlStateNormal];
        attribString = [NSMutableAttributedString highlightedLinkStringFor:coSponsorDesc];
        [_billDetailView.cosponsorsButton setAttributedTitle:attribString forState:UIControlStateHighlighted];
        [_billDetailView.cosponsorsButton show];
        _billDetailView.cosponsorsButton.enabled = YES;
    }
    else
    {
        [_billDetailView.cosponsorsButton hide];
        _billDetailView.cosponsorsButton.enabled = NO;
    }
    _billDetailView.summary.text = _bill.shortSummary ? _bill.shortSummary : @"No summary available";

    [self.view layoutSubviews];
}

- (void)handleLinkOutPress
{
    BOOL urlOpened = [[UIApplication sharedApplication] openURL:self.bill.shareURL];
    if (!urlOpened) {
        NSLog(@"Unable to open phone url %@", [self.bill.shareURL absoluteString]);
    }
}

- (void)handleSponsorPress
{
    SFLegislatorDetailViewController *detailViewController = [[SFLegislatorDetailViewController alloc] initWithNibName:nil bundle:nil];
    detailViewController.legislator = self.bill.sponsor;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)handleCosponsorsPress
{
    SFLegislatorListViewController *cosponsorsListVC = [[SFLegislatorListViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:cosponsorsListVC animated:YES];
    cosponsorsListVC.title = @"Co-Sponsors";
    __weak SFLegislatorListViewController *weakCosponsorsListVC = cosponsorsListVC;
    [SFLegislatorService legislatorsWithIds:_bill.cosponsorIds completionBlock:^(NSArray *resultsArray) {
        weakCosponsorsListVC.items = [resultsArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"stateName" ascending:YES]]];
        [weakCosponsorsListVC reloadTableView];
    }];
}

@end
