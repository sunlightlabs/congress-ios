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
#import "SFLegislatorSegmentedViewController.h"
#import "SFLegislatorTableViewController.h"
#import "SFCongressURLService.h"
#import "SFLegislatorService.h"
#import "SFDateFormatterUtil.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "SVPullToRefreshView+Congress.h"
#import <GAI.h>

@implementation SFBillDetailViewController
{
    SFBillDetailView *_billDetailView;
    SFLegislatorTableViewController *_cosponsorsListVC;
}

@synthesize bill = _bill;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
//        [self _initialize];
        self.trackedViewName = @"Bill Detail Screen";
        self.restorationIdentifier = NSStringFromClass(self.class);
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    _billDetailView = [[SFBillDetailView alloc] init];
    [_billDetailView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.view = _billDetailView;
}

- (void)viewDidLoad
{
    NSDictionary *viewDict = @{
        @"scrollview": _billDetailView.scrollView,
        @"callout": _billDetailView.callout,
        @"title": _billDetailView.titleLabel
    };
    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollview]|" options:0 metrics:nil views:viewDict]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollview]|" options:0 metrics:nil views:viewDict]];
//    
//    [self.view.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[callout]|" options:0 metrics:nil views:viewDict]];
//    [self.view.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[callout]" options:0 metrics:nil views:viewDict]];
//    
//    [self.view.callout addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[title]" options:0 metrics:nil views:viewDict]];
//    [self.view.callout addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[title]" options:0 metrics:nil views:viewDict]];
    
    [_billDetailView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[callout(>=300)]" options:0 metrics:nil views:viewDict]];
    [_billDetailView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-4-[callout(>=300)]-4-|" options:0 metrics:nil views:viewDict]];
    
    [_billDetailView.callout addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-4-[title]-4-|" options:0 metrics:nil views:viewDict]];
    [_billDetailView.callout addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[title]" options:0 metrics:nil views:viewDict]];
    
    [_billDetailView.callout layoutSubviews];
}

#pragma mark - Accessors

-(void)setBill:(SFBill *)bill
{
    _bill = bill;
    [self updateBillView];
}

#pragma mark - Private

-(void)_initialize{
    [_billDetailView.linkOutButton addTarget:self action:@selector(handleLinkOutPress) forControlEvents:UIControlEventTouchUpInside];
    [_billDetailView.sponsorButton addTarget:self action:@selector(handleSponsorPress) forControlEvents:UIControlEventTouchUpInside];
    [_billDetailView.cosponsorsButton addTarget:self action:@selector(handleCosponsorsPress) forControlEvents:UIControlEventTouchUpInside];
    [_billDetailView.favoriteButton addTarget:self action:@selector(handleFavoriteButtonPress) forControlEvents:UIControlEventTouchUpInside];
    _billDetailView.favoriteButton.selected = NO;
}


- (void)updateBillView
{
    self.title = _bill.displayName;
    [self.title setAccessibilityLabel:@"Name of bill"];
    [self.title setAccessibilityValue:_bill.displayName];
    
    _billDetailView.favoriteButton.selected = _bill.persist;
    [_billDetailView.favoriteButton setAccessibilityLabel:@"Follow bill"];
    [_billDetailView.favoriteButton setAccessibilityValue:_bill.persist ? @"Following" : @"Not Following"];
    [_billDetailView.favoriteButton setAccessibilityHint:@"Follow this bill to see the lastest updates in the Following section."];

    _billDetailView.titleLabel.text = _bill.officialTitle;
    [_billDetailView.titleLabel setAccessibilityLabel:@"Title of bill"];
    [_billDetailView.titleLabel setAccessibilityValue:_bill.officialTitle];
    
    if (_bill.introducedOn) {
        NSDateFormatter *dateFormatter = [SFDateFormatterUtil mediumDateNoTimeFormatter];
        NSString *descriptorString = @"Introduced";
        NSString *dateString = [dateFormatter stringFromDate:_bill.introducedOn];
        NSString *subtitleString = [NSString stringWithFormat:@"%@ %@", descriptorString, dateString];
        NSMutableAttributedString *subtitleAttrString = [[NSMutableAttributedString alloc] initWithString:subtitleString];
        NSRange introRange = [subtitleString rangeOfString:descriptorString];
        NSRange postIntroRange = [subtitleString rangeOfString:dateString];
        [subtitleAttrString addAttribute:NSFontAttributeName value:[UIFont subitleEmFont] range:introRange];
        [subtitleAttrString addAttribute:NSFontAttributeName value:[UIFont subitleStrongFont] range:postIntroRange];
        _billDetailView.subtitleLabel.attributedText = subtitleAttrString;
        [_billDetailView.subtitleLabel setAccessibilityValue:dateString];
    }
    if (_bill.sponsor != nil)
    {
        NSString *sponsorDesc = [NSString stringWithFormat:@"%@ (%@)", _bill.sponsor.fullName, _bill.sponsor.party];
        NSMutableAttributedString *sponsorButtonString = [NSMutableAttributedString linkStringFor:sponsorDesc];
        [_billDetailView.sponsorButton setAttributedTitle:sponsorButtonString forState:UIControlStateNormal];
        sponsorButtonString = [NSMutableAttributedString highlightedLinkStringFor:sponsorDesc];
        [_billDetailView.sponsorButton setAttributedTitle:sponsorButtonString forState:UIControlStateHighlighted];
        [_billDetailView.sponsorButton setAccessibilityValue:[NSString stringWithFormat:@"%@ %@", _bill.sponsor.partyName, _bill.sponsor.fullName]];
        [_billDetailView.sponsorButton setAccessibilityHint:[NSString stringWithFormat:@"View legislator details of the bill sponsor, %@", _bill.sponsor.fullName]];
    }
    if (_bill.cosponsorIds && [_bill.cosponsorIds count] > 0) {
        NSString *coSponsorDesc = [NSString stringWithFormat:@"+ %lu others", (unsigned long)[_bill.cosponsorIds count]];
        NSMutableAttributedString *attribString = [NSMutableAttributedString linkStringFor:coSponsorDesc];
        [_billDetailView.cosponsorsButton setAttributedTitle:attribString forState:UIControlStateNormal];
        attribString = [NSMutableAttributedString highlightedLinkStringFor:coSponsorDesc];
        [_billDetailView.cosponsorsButton setAttributedTitle:attribString forState:UIControlStateHighlighted];
        if ([_bill.cosponsorIds count] == 1) {
            [_billDetailView.cosponsorsButton setAccessibilityValue:@"1 co-sponsor"];
        } else {
            [_billDetailView.cosponsorsButton setAccessibilityValue:[NSString stringWithFormat:@"%lu co-sponsors", (unsigned long)[_bill.cosponsorIds count]]];
        }
        [_billDetailView.cosponsorsButton setAccessibilityHint:@"View the list of bill co-sponsors"];
        [_billDetailView.cosponsorsButton show];
        _billDetailView.cosponsorsButton.enabled = YES;
    }
    else
    {
        [_billDetailView.cosponsorsButton hide];
        _billDetailView.cosponsorsButton.enabled = NO;
    }
    [_billDetailView.summary setText:(_bill.shortSummary ? _bill.shortSummary : @"No summary available") lineSpacing:[NSParagraphStyle lineSpacing]];
    [_billDetailView.summary setAccessibilityValue:_billDetailView.summary.text];

    [self.view layoutSubviews];
}

- (void)handleLinkOutPress
{
    NSURL *fullTextURL = [SFCongressURLService fullTextPageforBillWithId:self.bill.billId];
    BOOL urlOpened = [[UIApplication sharedApplication] openURL:fullTextURL];
    if (urlOpened) {
        [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"Bill"
                                                          withAction:@"Full Text"
                                                           withLabel:self.bill.displayName
                                                           withValue:nil];
    } else {
        NSLog(@"Unable to open phone url %@", [self.bill.shareURL absoluteString]);
    }
}

- (void)handleSponsorPress
{
    SFLegislatorSegmentedViewController *detailViewController = [[SFLegislatorSegmentedViewController alloc] initWithNibName:nil bundle:nil];
    detailViewController.legislator = self.bill.sponsor;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)handleCosponsorsPress
{
    if (!_cosponsorsListVC) {
        _cosponsorsListVC = [[SFLegislatorTableViewController alloc] initWithStyle:UITableViewStylePlain];
        _cosponsorsListVC.sectionTitleGenerator = lastNameTitlesGenerator;
        _cosponsorsListVC.sortIntoSectionsBlock = byLastNameSorterBlock;
        _cosponsorsListVC.orderItemsInSectionsBlock = lastNameFirstOrderBlock;
    }
    __weak SFLegislatorTableViewController *weakCosponsorsListVC = _cosponsorsListVC;
    __weak SFBill *weakBill = self.bill;
    [_cosponsorsListVC.tableView addInfiniteScrollingWithActionHandler:^{
        NSInteger loc = [weakCosponsorsListVC.items count];
        NSInteger unretrievedCount = [weakBill.cosponsorIds count]-[weakCosponsorsListVC.items count];
        if (unretrievedCount > 0) {
            NSInteger length = unretrievedCount < 50 ? unretrievedCount : 50;
            NSRange idRange = NSMakeRange(loc, length);
            NSIndexSet *retrievalIndexes = [NSIndexSet indexSetWithIndexesInRange:idRange];
            NSArray *retrievalSet = [weakBill.cosponsorIds objectsAtIndexes:retrievalIndexes];
            BOOL didRun = [SSRateLimit executeBlock:^{
                [SFLegislatorService legislatorsWithIds:retrievalSet count:length completionBlock:^(NSArray *resultsArray) {
                    NSArray *newItems = [resultsArray sortedArrayUsingDescriptors:
                                         @[
                                         [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES],
                                         [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES],
                                         [NSSortDescriptor sortDescriptorWithKey:@"stateName" ascending:YES]
                                         ]];
                    weakCosponsorsListVC.items = [weakCosponsorsListVC.items arrayByAddingObjectsFromArray:newItems];
                    [weakCosponsorsListVC sortItemsIntoSectionsAndReload];
                    [weakCosponsorsListVC.tableView.infiniteScrollingView stopAnimating];
                }];
            } name:@"cosponsorsListVC-InfiniteScroll" limit:1.0f];
            if (!didRun) {
                [weakCosponsorsListVC.tableView.infiniteScrollingView stopAnimating];
            }

        }
        else
        {
            [weakCosponsorsListVC.tableView.infiniteScrollingView stopAnimating];
        }
    }];
    [self.navigationController pushViewController:_cosponsorsListVC animated:YES];
    _cosponsorsListVC.title = @"Co-Sponsors";
    [_cosponsorsListVC.tableView triggerInfiniteScrolling];
}

#pragma mark - SFFavoriting protocol

- (void)handleFavoriteButtonPress
{
    self.bill.persist = !self.bill.persist;
    _billDetailView.favoriteButton.selected = self.bill.persist;
    [_billDetailView.favoriteButton setAccessibilityValue:_bill.persist ? @"Following" : @"Not Following"];
    
    if (self.bill.persist) {
        [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"Bill"
                                                          withAction:@"Favorite"
                                                           withLabel:[NSString stringWithFormat:@"%@ (%@)", self.bill.displayName, self.bill.billId]
                                                           withValue:nil];
    }
    
#if CONFIGURATION_Beta
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@avorited bill", (self.bill.persist ? @"F" : @"Unf")]];
#endif
}

#pragma mark - Application state

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {

    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {

    [super decodeRestorableStateWithCoder:coder];
}

@end
