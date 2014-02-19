//
//  SFPeoplePickerNavigationController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 5/29/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFPeoplePickerNavigationController.h"

@interface SFPeoplePickerNavigationController ()

@end

@implementation SFPeoplePickerNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDelegate:self];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self setBackButtonForNavigationController:navigationController];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self setBackButtonForNavigationController:navigationController];
}

- (void)setBackButtonForNavigationController:(UINavigationController *)navigationController {
    NSArray *viewControllers = navigationController.viewControllers;
    for (UIViewController *vc in viewControllers) {
        vc.navigationItem.backBarButtonItem = [UIBarButtonItem clearButton];
        [vc.navigationItem.backBarButtonItem setTintColor:[UIColor navigationBarTextColor]];
        [vc.navigationItem.backBarButtonItem setAccessibilityLabel:@"Back"];
    }
}

@end
