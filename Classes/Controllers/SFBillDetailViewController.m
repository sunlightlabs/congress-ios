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
#import "SFFullTextViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "SVPullToRefreshView+Congress.h"
#import <SAMRateLimit/SAMRateLimit.h>

@implementation SFBillDetailViewController
{
    SFBillDetailView *_billDetailView;
    UIScrollView *_scrollView;
    SFLegislatorTableViewController *_cosponsorsListVC;
}

static NSString *const BillSummaryNotAvailableText = @"Bill summary not available: It either has not been processed yet or the Library of Congress did not write one.";

@synthesize bill = _bill;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.screenName = @"Bill Detail Screen";
        self.restorationIdentifier = NSStringFromClass(self.class);
    }
    return self;
}

- (void)loadView {
    CGRect bounds = [[UIScreen mainScreen] bounds];

    _scrollView = [[UIScrollView alloc] initWithFrame:bounds];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;

    _billDetailView = [[SFBillDetailView alloc] initWithFrame:bounds];
    _billDetailView.autoresizesSubviews = NO;
    _billDetailView.translatesAutoresizingMaskIntoConstraints = NO;
    _billDetailView.backgroundColor = [UIColor primaryBackgroundColor];
    [_scrollView addSubview:_billDetailView];

    self.view = _scrollView;
}

- (void)viewDidLoad {
    [_billDetailView.linkOutButton addTarget:self action:@selector(handleLinkOutPress) forControlEvents:UIControlEventTouchUpInside];
    [_billDetailView.sponsorButton addTarget:self action:@selector(handleSponsorPress) forControlEvents:UIControlEventTouchUpInside];
    [_billDetailView.cosponsorsButton addTarget:self action:@selector(handleCosponsorsPress) forControlEvents:UIControlEventTouchUpInside];
    [_billDetailView.followButton addTarget:self action:@selector(handleFollowButtonPress) forControlEvents:UIControlEventTouchUpInside];
    _billDetailView.followButton.selected = NO;

//    Make sure _detailView orients to top of scrollview.
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_billDetailView attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_scrollView attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f constant:0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_billDetailView attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_scrollView attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f constant:0]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self resizeScrollView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.bill) {
        [self updateBillView];
    }
    [self resizeScrollView];
}

#pragma mark - Accessors

- (void)setBill:(SFBill *)bill {
    _bill = bill;
    [self updateBillView];
}

#pragma mark - Private

- (void)updateBillView {
    self.title = _bill.displayName;
    [self.title setAccessibilityLabel:@"Name of bill"];
    [self.title setAccessibilityValue:_bill.displayName];

    _billDetailView.followButton.selected = [_bill isFollowed];
    [_billDetailView.followButton setAccessibilityLabel:@"Follow bill"];
    [_billDetailView.followButton setAccessibilityValue:[_bill isFollowed] ? @"Following":@"Not Following"];
    [_billDetailView.followButton setAccessibilityHint:@"Follow this bill to see the lastest updates in the Following section."];

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
        _billDetailView.dateLabel.attributedText = subtitleAttrString;
        [_billDetailView.dateLabel setAccessibilityValue:dateString];
    }
    if (_bill.sponsor != nil) {
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
        }
        else {
            [_billDetailView.cosponsorsButton setAccessibilityValue:[NSString stringWithFormat:@"%lu co-sponsors", (unsigned long)[_bill.cosponsorIds count]]];
        }
        [_billDetailView.cosponsorsButton setAccessibilityHint:@"View the list of bill co-sponsors"];
        [_billDetailView.cosponsorsButton sam_show];
        _billDetailView.cosponsorsButton.enabled = YES;
    }
    else {
        [_billDetailView.cosponsorsButton sam_hide];
        _billDetailView.cosponsorsButton.enabled = NO;
    }
    [_billDetailView.summary setText:(_bill.shortSummary ? _bill.shortSummary : BillSummaryNotAvailableText) lineSpacing:[NSParagraphStyle lineSpacing]];
    [_billDetailView.summary setAccessibilityValue:_billDetailView.summary.text];

    if ([_bill.lastVersion valueForKeyPath:@"urls.xml"] == nil &&
        [_bill.lastVersion valueForKeyPath:@"urls.html"] == nil &&
        [_bill.lastVersion valueForKeyPath:@"urls.pdf"] == nil) {
        [_billDetailView.linkOutButton setEnabled:NO];
        [_billDetailView.linkOutButton setTitle:@"No Full Text Available" forState:UIControlStateNormal];
    }

    [_billDetailView setNeedsUpdateConstraints];
    [_scrollView layoutIfNeeded];
    [self resizeScrollView];
}

- (void)resizeScrollView {
    UIView *bottomView = _billDetailView.linkOutButton;
    [_scrollView layoutIfNeeded];
    [_scrollView setContentSize:CGSizeMake(_billDetailView.width, bottomView.bottom + _billDetailView.contentInset.bottom)];
    _billDetailView.height = _scrollView.contentSize.height;
}

- (void)updateViewConstraints {
    NSDictionary *views = @{ @"bill": _billDetailView };
    [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bill]|" options:0 metrics:nil views:views]];
    [super updateViewConstraints];
}

#pragma mark - UIControl event handlers

- (void)handleLinkOutPress {
    SFFullTextViewController *vc = [[SFFullTextViewController alloc] initWithBill:_bill];

    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion: ^{
        [[[GAI sharedInstance] defaultTracker] send:
         [[GAIDictionaryBuilder createEventWithCategory:@"Bill"
                                                 action:@"Full Text"
                                                  label:self.bill.displayName
                                                  value:nil] build]];
    }];
}

- (void)handleSponsorPress {
    SFLegislatorSegmentedViewController *detailViewController = [[SFLegislatorSegmentedViewController alloc] initWithNibName:nil bundle:nil
                                                                                                                  bioguideId:self.bill.sponsorId];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)handleCosponsorsPress {
    if (!_cosponsorsListVC) {
        _cosponsorsListVC = [[SFLegislatorTableViewController alloc] initWithStyle:UITableViewStylePlain];
        _cosponsorsListVC.dataProvider.sectionTitleGenerator = lastNameTitlesGenerator;
        _cosponsorsListVC.dataProvider.sortIntoSectionsBlock = byLastNameSorterBlock;
        _cosponsorsListVC.dataProvider.orderItemsInSectionsBlock = lastNameFirstOrderBlock;
    }
    __weak SFLegislatorTableViewController *weakCosponsorsListVC = _cosponsorsListVC;
    __weak SFBill *weakBill = self.bill;
    [_cosponsorsListVC.tableView addInfiniteScrollingWithActionHandler: ^{
        NSInteger loc = [weakCosponsorsListVC.dataProvider.items count];
        NSInteger unretrievedCount = [weakBill.cosponsorIds count] - [weakCosponsorsListVC.dataProvider.items count];
        if (unretrievedCount > 0) {
            NSInteger length = unretrievedCount < 50 ? unretrievedCount : 50;
            NSRange idRange = NSMakeRange(loc, length);
            NSIndexSet *retrievalIndexes = [NSIndexSet indexSetWithIndexesInRange:idRange];
            NSArray *retrievalSet = [weakBill.cosponsorIds objectsAtIndexes:retrievalIndexes];
            BOOL didRun = [SAMRateLimit executeBlock: ^{
                    [SFLegislatorService legislatorsWithIds:retrievalSet count:length completionBlock: ^(NSArray *resultsArray) {
                            NSArray *newItems = [resultsArray sortedArrayUsingDescriptors:
                                                 @[
                                                     [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES],
                                                     [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES],
                                                     [NSSortDescriptor sortDescriptorWithKey:@"stateName" ascending:YES]
                                                 ]];
                            weakCosponsorsListVC.dataProvider.items = [weakCosponsorsListVC.dataProvider.items arrayByAddingObjectsFromArray:newItems];
                            [weakCosponsorsListVC sortItemsIntoSectionsAndReload];
                            [weakCosponsorsListVC.tableView.infiniteScrollingView stopAnimating];
                        }];
                } name:@"cosponsorsListVC-InfiniteScroll" limit:1.0f];
            if (!didRun) {
                [weakCosponsorsListVC.tableView.infiniteScrollingView stopAnimating];
            }
        }
        else {
            [weakCosponsorsListVC.tableView.infiniteScrollingView stopAnimating];
        }
    }];
    [self.navigationController pushViewController:_cosponsorsListVC animated:YES];
    _cosponsorsListVC.title = @"Co-Sponsors";
    [_cosponsorsListVC.tableView triggerInfiniteScrolling];
}

#pragma mark - SFFavoriting protocol

- (void)handleFollowButtonPress {
    self.bill.followed = ![self.bill isFollowed];
    _billDetailView.followButton.selected = [self.bill isFollowed];
    [_billDetailView.followButton setAccessibilityValue:[self.bill isFollowed] ? @"Following":@"Not Following"];

    if ([self.bill isFollowed]) {
        [[[GAI sharedInstance] defaultTracker] send:
         [[GAIDictionaryBuilder createEventWithCategory:@"Bill"
                                                 action:@"Favorite"
                                                  label:[NSString stringWithFormat:@"%@ (%@)", self.bill.displayName, self.bill.billId]
                                                  value:nil] build]];
    }

#if CONFIGURATION_Beta
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@avorited bill", ([self.bill isFollowed] ? @"F" : @"Unf")]];
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
