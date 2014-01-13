//
//  SFViewDeckController.h
//  Congress
//
//  Created by Jeremy Carbaugh on 6/9/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "IIViewDeckController.h"

#import "SFBill.h"
#import "SFCommittee.h"
#import "SFHearing.h"
#import "SFLegislator.h"

#import "SFCongressNavigationController.h"
#import "SFMenuViewController.h"

#import "SFActivitySectionViewController.h"
#import "SFFollowingSectionViewController.h"
#import "SFBillsSectionViewController.h"
#import "SFLegislatorsSectionViewController.h"
#import "SFCommitteesSectionViewController.h"
#import "SFHearingsSectionViewController.h"
#import "SFSettingsSectionViewController.h"
#import "SFInformationSectionViewController.h"

@interface SFViewDeckController : IIViewDeckController <UITableViewDelegate, UIViewControllerRestoration>

@property (nonatomic, retain) SFCongressNavigationController *navigationController;
@property (nonatomic, retain) SFMenuViewController *menuViewController;

@property (nonatomic, retain) SFActivitySectionViewController *activityViewController;
@property (nonatomic, retain) SFFollowingSectionViewController *followingViewController;
@property (nonatomic, retain) SFBillsSectionViewController *billsViewController;
@property (nonatomic, retain) SFLegislatorsSectionViewController *legislatorsViewController;
@property (nonatomic, retain) SFCommitteesSectionViewController *committeesViewController;
@property (nonatomic, retain) SFHearingsSectionViewController *hearingsViewController;
@property (nonatomic, retain) SFSettingsSectionViewController *settingsViewController;
@property (nonatomic, retain) SFInformationSectionViewController *informationViewController;

- (void)navigateToBill:(SFBill *)bill;
- (void)navigateToBill:(SFBill *)bill segment:(NSString *)segmentName;
- (void)navigateToLegislator:(SFLegislator *)legislator;
- (void)navigateToLegislator:(SFLegislator *)legislator segment:(NSString *)segmentName;
- (void)navigateToActivity;
- (void)navigateToCommittee:(SFCommittee *)committee;
- (void)navigateToCommittee:(SFCommittee *)committee segment:(NSString *)segmentName;
- (void)navigateToHearing:(SFHearing *)hearing;
- (void)navigateToFollowing;
- (void)navigateToSettings;

@end
