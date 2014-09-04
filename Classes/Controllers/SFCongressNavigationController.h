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

- (void)setBackButtonForNavigationController:(UINavigationController *)navigationController;

@end
