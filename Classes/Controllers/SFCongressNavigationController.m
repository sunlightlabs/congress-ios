//
//  SFCongressNavigationController.m
//  Congress
//
//  Created by Daniel Cloud on 3/21/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCongressNavigationController.h"

#import "SFActivitySectionViewController.h"
#import "SFBillsSectionViewController.h"
#import "SFFavoritesSectionViewController.h"
#import "SFLegislatorsSectionViewController.h"
#import "SFSettingsSectionViewController.h"

#import "SFBillSegmentedViewController.h"
#import "SFLegislatorDetailViewController.h"

@interface SFCongressNavigationController () // <UIViewControllerRestoration>

@end

@implementation SFCongressNavigationController

@synthesize activityViewController = _activityViewController;
@synthesize billsViewController = _billsViewController;
@synthesize favoritesViewController = _favoritesViewController;
@synthesize legislatorsViewController = _legislatorsViewController;
@synthesize settingsViewController = _settingsViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = self;
        self.restorationIdentifier = NSStringFromClass(self.class);
        
        _activityViewController = [SFActivitySectionViewController new];
        _billsViewController = [SFBillsSectionViewController new];
        _favoritesViewController = [SFFavoritesSectionViewController new];
        _legislatorsViewController = [SFLegislatorsSectionViewController new];
        _settingsViewController = [SFSettingsSectionViewController new];
        
        [self setViewControllers:[NSArray arrayWithObject:_activityViewController]];
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

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self setBackButtonForNavigationController:navigationController];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self setBackButtonForNavigationController:navigationController];
}

- (void)setBackButtonForNavigationController:(UINavigationController *)navigationController
{
    NSArray *viewControllers = navigationController.viewControllers;
    for (UIViewController *vc in viewControllers) {
        [vc.navigationItem setBackBarButtonItem:[UIBarButtonItem backButton]];
        [vc.navigationItem.backBarButtonItem setTitle:@"."];
    }
}

#pragma mark - Application state

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    [coder encodeObject:NSStringFromClass([self.visibleViewController class]) forKey:@"visibleViewController"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    NSString *viewControllerClassName = [coder decodeObjectForKey:@"visibleViewController"];
    if ([viewControllerClassName isEqualToString:@"SFSettingsSectionViewController"]) {
        [self setViewControllers:[NSArray arrayWithObject:_settingsViewController]];
    }
    else if ([viewControllerClassName isEqualToString:@"SFActivitySectionViewController"]) {
        [self setViewControllers:[NSArray arrayWithObject:_activityViewController]];
    }
    else if ([viewControllerClassName isEqualToString:@"SFBillsSectionViewController"]) {
        [self setViewControllers:[NSArray arrayWithObject:_billsViewController]];
    }
    else if ([viewControllerClassName isEqualToString:@"SFLegislatorsSectionViewController"]) {
        [self setViewControllers:[NSArray arrayWithObject:_legislatorsViewController]];
    }
    else if ([viewControllerClassName isEqualToString:@"SFFavoritesSectionViewController"]) {
        [self setViewControllers:[NSArray arrayWithObject:_favoritesViewController]];
    }
}

#pragma mark - SFCongressNavigationController

- (void)selectViewController:(UIViewController *)selectedViewController
{
    [self popToRootViewControllerAnimated:NO];
    if (selectedViewController != self.visibleViewController) {
        [self.visibleViewController removeFromParentViewController];
        [self setViewControllers:[NSArray arrayWithObject:selectedViewController] animated:NO];
    }
}

- (void)navigateToBill:(SFBill *)bill
{
    [self selectViewController:_billsViewController];
    if (bill) {
        SFBillSegmentedViewController *controller = [SFBillSegmentedViewController new];
        [controller setBill:bill];
        [self pushViewController:controller animated:YES];
    }
}

- (void)navigateToLegislator:(SFLegislator *)legislator
{
    [self selectViewController:_legislatorsViewController];
    if (legislator) {
        SFLegislatorDetailViewController *controller = [SFLegislatorDetailViewController new];
        [controller setLegislator:legislator];
        [self pushViewController:controller animated:YES];
    }
}

@end
