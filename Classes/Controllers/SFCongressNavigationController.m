//
//  SFCongressNavigationController.m
//  Congress
//
//  Created by Daniel Cloud on 3/21/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCongressNavigationController.h"

@interface SFCongressNavigationController () // <UIViewControllerRestoration>

@end

@implementation SFCongressNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = self;
        self.restorationIdentifier = NSStringFromClass(self.class);
    }
    return self;
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
