//
//  SFViewDeckController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 6/9/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFViewDeckController.h"
#import "SFBillSegmentedViewController.h"
#import "SFLegislatorDetailViewController.h"

@interface SFViewDeckController ()

@end

@implementation SFViewDeckController

@synthesize navigationController = _navigationController;
@synthesize menuViewController = _menuViewController;

@synthesize activityViewController = _activityViewController;
@synthesize billsViewController = _billsViewController;
@synthesize favoritesViewController = _favoritesViewController;
@synthesize legislatorsViewController = _legislatorsViewController;
@synthesize settingsViewController = _settingsViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.restorationClass = self.class;
        self.restorationIdentifier = NSStringFromClass(self.class);
        [self _initialize];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - SFViewDeckController private

- (void)_initialize
{
    _activityViewController = [SFActivitySectionViewController new];
    _billsViewController = [SFBillsSectionViewController new];
    _favoritesViewController = [SFFavoritesSectionViewController new];
    _legislatorsViewController = [SFLegislatorsSectionViewController new];
    _settingsViewController = [SFSettingsSectionViewController new];
    
    NSArray *labels = @[@"Latest Activity", @"Following", @"Bills", @"Legislators"];
    NSArray *viewControllers = @[_activityViewController,
                                 _favoritesViewController,
                                 _billsViewController,
                                 _legislatorsViewController];
    
    _menuViewController = [[SFMenuViewController alloc] initWithControllers:viewControllers
                                                                 menuLabels:labels
                                                                   settings:_settingsViewController];
    
    _navigationController = [[SFCongressNavigationController alloc] init];
    
    [self setLeftController:_menuViewController];
    [self setCenterController:_navigationController];
    [self setNavigationControllerBehavior:IIViewDeckNavigationControllerContained];
    [self setCenterhiddenInteractivity:IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose];
    [self setLeftSize:80.0f];
    
    // set default view to activity view
    [self selectViewController:_activityViewController];
}

- (void)selectViewController:(UIViewController *)selectedViewController
{
    [_navigationController popToRootViewControllerAnimated:NO];
    if (selectedViewController != _navigationController.visibleViewController) {
        [_navigationController.visibleViewController removeFromParentViewController];
        [_navigationController setViewControllers:[NSArray arrayWithObject:selectedViewController] animated:NO];
    }
}

#pragma mark - SFViewDeckController public

- (void)navigateToBill:(SFBill *)bill
{
    [self selectViewController:_billsViewController];
    [_menuViewController selectMenuItemForController:_billsViewController];
    if (bill) {
        SFBillSegmentedViewController *controller = [SFBillSegmentedViewController new];
        [controller setBill:bill];
        [_navigationController pushViewController:controller animated:NO];
    }
}

- (void)navigateToLegislator:(SFLegislator *)legislator
{
    [self selectViewController:_legislatorsViewController];
    [_menuViewController selectMenuItemForController:_legislatorsViewController];
    if (legislator) {
        SFLegislatorDetailViewController *controller = [SFLegislatorDetailViewController new];
        [controller setLegislator:legislator];
        [_navigationController pushViewController:controller animated:NO];
    }
}

- (void)navigateToActivity
{
    [self selectViewController:_activityViewController];
    [_menuViewController selectMenuItemForController:_activityViewController];
}

- (void)navigateToFollowing
{
    [self selectViewController:_favoritesViewController];
    [_menuViewController selectMenuItemForController:_favoritesViewController];
}

- (void)navigateToSettings
{
    [_menuViewController selectMenuItemForController:nil];
}

#pragma mark - Application state

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    [coder encodeObject:NSStringFromClass([_navigationController.presentedViewController class]) forKey:@"selectedViewController"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    NSString *viewControllerClassName = [coder decodeObjectForKey:@"selectedViewController"];
    if ([viewControllerClassName isEqualToString:@"SFSettingsSectionViewController"]) {
        [self navigateToSettings];
    }
    else if ([viewControllerClassName isEqualToString:@"SFActivitySectionViewController"]) {
        [self selectViewController:_activityViewController];
    }
    else if ([viewControllerClassName isEqualToString:@"SFBillsSectionViewController"]) {
        [self selectViewController:_billsViewController];
    }
    else if ([viewControllerClassName isEqualToString:@"SFLegislatorsSectionViewController"]) {
        [self selectViewController:_legislatorsViewController];
    }
    else if ([viewControllerClassName isEqualToString:@"SFFavoritesSectionViewController"]) {
        [self selectViewController:_legislatorsViewController];
    }
}

@end
