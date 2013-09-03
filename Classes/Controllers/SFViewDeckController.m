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
#import "SFNavTableCell.h"

@interface SFViewDeckController ()

@end

@implementation SFViewDeckController {
    NSArray *controllers;
    NSArray *controllerLabels;
    UIViewController *restorationViewController;
}

@synthesize navigationController = _navigationController;
@synthesize menuViewController = _menuViewController;

@synthesize activityViewController = _activityViewController;
@synthesize billsViewController = _billsViewController;
@synthesize favoritesViewController = _favoritesViewController;
@synthesize legislatorsViewController = _legislatorsViewController;
@synthesize hearingsViewController = _hearingsViewController;
@synthesize committeesViewController = _committeesViewController;
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
    if (restorationViewController) {
        [self selectViewController:restorationViewController];
        restorationViewController = nil;
    } else {
        [self selectViewController:_activityViewController];
    }
}

#pragma mark - SFViewDeckController private

- (void)_initialize
{
    _activityViewController = [SFActivitySectionViewController new];
    _billsViewController = [SFBillsSectionViewController new];
    _favoritesViewController = [SFFavoritesSectionViewController new];
    _legislatorsViewController = [SFLegislatorsSectionViewController new];
    _committeesViewController = [SFCommitteesSectionViewController new];
    _hearingsViewController = [SFHearingsSectionViewController new];
    _settingsViewController = [SFSettingsSectionViewController new];
    
    controllerLabels = @[@"Latest Activity", @"Following", @"Bills", @"Legislators", @"Committees", @"Hearings"];
    controllers = @[_activityViewController,
                    _favoritesViewController,
                    _billsViewController,
                    _legislatorsViewController,
                    _committeesViewController,
                    _hearingsViewController];
    
    _menuViewController = [[SFMenuViewController alloc] initWithControllers:controllers
                                                                 menuLabels:controllerLabels
                                                                   settings:_settingsViewController];
    [_menuViewController.tableView setDelegate:self];
    [_menuViewController.settingsButton addTarget:self action:@selector(navigateToSettings) forControlEvents:UIControlEventTouchUpInside];
    [self addChildViewController:_menuViewController];
    
    _navigationController = [[SFCongressNavigationController alloc] init];
    
    [self setLeftController:_menuViewController];
    [self setCenterController:_navigationController];
    [self setNavigationControllerBehavior:IIViewDeckNavigationControllerContained];
    [self setCenterhiddenInteractivity:IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose];
    [self setLeftSize:80.0f];
}

- (void)selectViewController:(UIViewController *)selectedViewController
{
    [_navigationController popToRootViewControllerAnimated:NO];
    if (selectedViewController != _navigationController.visibleViewController) {
        [_navigationController.visibleViewController removeFromParentViewController];
        [_navigationController setViewControllers:[NSArray arrayWithObject:selectedViewController] animated:NO];
    }
    [_menuViewController selectMenuItemForController:selectedViewController animated:NO];
    [self closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {}];
}

#pragma mark - SFViewDeckController public

- (void)navigateToBill:(SFBill *)bill
{
    [self selectViewController:_billsViewController];
    if (bill) {
        SFBillSegmentedViewController *controller = [SFBillSegmentedViewController new];
        [controller setBill:bill];
        [_navigationController pushViewController:controller animated:NO];
    }
}

- (void)navigateToLegislator:(SFLegislator *)legislator
{
    [self selectViewController:_legislatorsViewController];
    if (legislator) {
        SFLegislatorDetailViewController *controller = [SFLegislatorDetailViewController new];
        [controller setLegislator:legislator];
        [_navigationController pushViewController:controller animated:NO];
    }
}

- (void)navigateToCommittee:(SFCommittee *)committee
{
    [self selectViewController:_committeesViewController];
}

- (void)navigateToHearing:(SFHearing *)hearing
{
    [self selectViewController:_hearingsViewController];
}

- (void)navigateToActivity
{
    [self selectViewController:_activityViewController];
}

- (void)navigateToFollowing
{
    [self selectViewController:_favoritesViewController];
}

- (void)navigateToSettings
{
    [self selectViewController:_settingsViewController];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SFNavTableCell";
    SFNavTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[SFNavTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    NSString *label = [controllerLabels objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:label];
    if ([label isEqualToString:@"Following"])
    {
        [cell.imageView setImage:[UIImage favoriteNavImage]];
    }
    else
    {
        [cell.imageView setImage:nil];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFNavTableCell *menuCell = (SFNavTableCell *)cell;
    [menuCell toggleFontFaceForSelected:menuCell.selected];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectViewController:[controllers objectAtIndex:indexPath.row]];
}

#pragma mark - UIViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Application state

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    UIViewController *viewController = [_navigationController.childViewControllers objectAtIndex:0];
    if (viewController) {
        NSString *viewControllerClassName = NSStringFromClass([viewController class]);
        [coder encodeObject:viewControllerClassName forKey:@"selectedViewController"];
    }
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    NSString *viewControllerClassName = [coder decodeObjectForKey:@"selectedViewController"];
    if ([viewControllerClassName isEqualToString:@"SFSettingsSectionViewController"]) {
        restorationViewController = _settingsViewController;
    }
    else if ([viewControllerClassName isEqualToString:@"SFActivitySectionViewController"]) {
        restorationViewController = _activityViewController;
    }
    else if ([viewControllerClassName isEqualToString:@"SFBillsSectionViewController"]) {
        restorationViewController = _billsViewController;
    }
    else if ([viewControllerClassName isEqualToString:@"SFCommitteesSectionViewController"]) {
        restorationViewController = _committeesViewController;
    }
    else if ([viewControllerClassName isEqualToString:@"SFHearingsSectionViewController"]) {
        restorationViewController = _hearingsViewController;
    }
    else if ([viewControllerClassName isEqualToString:@"SFLegislatorsSectionViewController"]) {
        restorationViewController = _legislatorsViewController;
    }
    else if ([viewControllerClassName isEqualToString:@"SFFavoritesSectionViewController"]) {
        restorationViewController = _favoritesViewController;
    }
    if (restorationViewController) {
        [_menuViewController selectMenuItemForController:restorationViewController animated:YES];
        restorationViewController = nil;
    }
}

@end
