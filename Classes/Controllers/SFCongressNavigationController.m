//
//  SFCongressNavigationController.m
//  Congress
//
//  Created by Daniel Cloud on 3/21/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCongressNavigationController.h"

NSString * const CongressActivityRestorationId = @"CongressActivityRestorationId";
NSString * const CongressFavoritesRestorationId = @"CongressFavoritesRestorationId";
NSString * const CongressBillsRestorationId = @"CongressBillsRestorationId";
NSString * const CongressLegislatorsRestorationId = @"CongressLegislatorsRestorationId";
NSString * const CongressSettingsRestorationId = @"CongressSettingsRestorationId";

@interface SFCongressNavigationController () //<UIViewControllerRestoration>

@end

@implementation SFCongressNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    navigationController.visibleViewController.navigationItem.backBarButtonItem = [UIBarButtonItem backButton];
    [navigationController.visibleViewController.navigationItem.backBarButtonItem setTitle:@" "];
}

#pragma mark - Application state

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
//    for (UIViewController *controller in self.childViewControllers) {
//        NSString *keyName = controller.restorationIdentifier ? controller.restorationIdentifier : NSStringFromClass(controller.class);
//        [coder encodeObject:controller forKey:keyName];
//    }
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
}

@end
