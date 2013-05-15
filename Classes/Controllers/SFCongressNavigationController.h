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

@interface SFCongressNavigationController : UINavigationController <UINavigationControllerDelegate>

@property (nonatomic, retain) UIViewController *activityViewController;
@property (nonatomic, retain) UIViewController *favoritesViewController;
@property (nonatomic, retain) UIViewController *billsViewController;
@property (nonatomic, retain) UIViewController *legislatorsViewController;
@property (nonatomic, retain) UIViewController *settingsViewController;

- (void)setBackButtonForNavigationController:(UINavigationController *)navigationController;

- (void)navigateToBill:(SFBill *)bill;
- (void)navigateToLegislator:(SFLegislator *)legislator;

@end
