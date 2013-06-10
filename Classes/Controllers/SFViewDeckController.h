//
//  SFViewDeckController.h
//  Congress
//
//  Created by Jeremy Carbaugh on 6/9/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "IIViewDeckController.h"

#import "SFBill.h"
#import "SFLegislator.h"

#import "SFCongressNavigationController.h"
#import "SFMenuViewController.h"

#import "SFActivitySectionViewController.h"
#import "SFFavoritesSectionViewController.h"
#import "SFBillsSectionViewController.h"
#import "SFLegislatorsSectionViewController.h"
#import "SFSettingsSectionViewController.h"

@interface SFViewDeckController : IIViewDeckController

@property (nonatomic, retain) SFCongressNavigationController *navigationController;
@property (nonatomic, retain) SFMenuViewController *menuViewController;

@property (nonatomic, retain) SFActivitySectionViewController *activityViewController;
@property (nonatomic, retain) SFFavoritesSectionViewController *favoritesViewController;
@property (nonatomic, retain) SFBillsSectionViewController *billsViewController;
@property (nonatomic, retain) SFLegislatorsSectionViewController *legislatorsViewController;
@property (nonatomic, retain) SFSettingsSectionViewController *settingsViewController;

- (void)navigateToBill:(SFBill *)bill;
- (void)navigateToLegislator:(SFLegislator *)legislator;

- (void)navigateToActivity;
- (void)navigateToFollowing;

@end
