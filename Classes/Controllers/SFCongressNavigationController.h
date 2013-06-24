//
//  SFCongressNavigationController.h
//  Congress
//
//  Created by Daniel Cloud on 3/21/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFBill.h"
#import "SFLegislator.h"
#import "SFBillsSectionViewController.h"
#import "SFMenuViewController.h"

@interface SFCongressNavigationController : UINavigationController <UINavigationControllerDelegate>

@property (nonatomic, strong) UIViewController *activityViewController;
@property (nonatomic, strong) UIViewController *favoritesViewController;
@property (nonatomic, strong) SFBillsSectionViewController *billsViewController;
@property (nonatomic, strong) UIViewController *legislatorsViewController;
@property (nonatomic, strong) UIViewController *settingsViewController;
@property (nonatomic, strong) SFMenuViewController *menu;

- (void)setBackButtonForNavigationController:(UINavigationController *)navigationController;

- (void)navigateToBill:(SFBill *)bill;
- (void)navigateToLegislator:(SFLegislator *)legislator;

@end
