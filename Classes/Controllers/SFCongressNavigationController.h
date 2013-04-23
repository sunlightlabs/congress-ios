//
//  SFCongressNavigationController.h
//  Congress
//
//  Created by Daniel Cloud on 3/21/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFCongressNavigationController : UINavigationController <UINavigationControllerDelegate>

@property (nonatomic, retain) UIViewController *activityViewController;
@property (nonatomic, retain) UIViewController *favoritesViewController;
@property (nonatomic, retain) UIViewController *billsViewController;
@property (nonatomic, retain) UIViewController *legislatorsViewController;
@property (nonatomic, retain) UIViewController *settingsViewController;

- (void)setBackButtonForNavigationController:(UINavigationController *)navigationController;

@end
