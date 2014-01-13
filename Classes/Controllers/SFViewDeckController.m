//
//  SFViewDeckController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 6/9/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFViewDeckController.h"
#import "SFBillSegmentedViewController.h"
#import "SFLegislatorSegmentedViewController.h"
#import "SFCommitteeSegmentedViewController.h"
#import "SFNavTableCell.h"
#import "SFImageButton.h"

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
@synthesize followingViewController = _followingViewController;
@synthesize legislatorsViewController = _legislatorsViewController;
@synthesize hearingsViewController = _hearingsViewController;
@synthesize committeesViewController = _committeesViewController;
@synthesize settingsViewController = _settingsViewController;
@synthesize informationViewController = _informationViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    _followingViewController = [SFFollowingSectionViewController new];
    _legislatorsViewController = [SFLegislatorsSectionViewController new];
    _committeesViewController = [SFCommitteesSectionViewController new];
    _hearingsViewController = [SFHearingsSectionViewController new];
    _settingsViewController = [SFSettingsSectionViewController new];
    _informationViewController = [SFInformationSectionViewController new];
    
    controllerLabels = @[@"Latest Activity", @"Following", @"Bills", @"Legislators", @"Committees", @"Hearings"];
    controllers = @[_activityViewController,
                    _followingViewController,
                    _billsViewController,
                    _legislatorsViewController,
                    _committeesViewController,
                    _hearingsViewController];
    
    _menuViewController = [[SFMenuViewController alloc] initWithControllers:controllers
                                                                 menuLabels:controllerLabels
                                                                   settings:_settingsViewController
                                                                       info:_informationViewController];
    [_menuViewController.tableView setDelegate:self];
    [_menuViewController.settingsButton addTarget:self action:@selector(navigateToSettings) forControlEvents:UIControlEventTouchUpInside];
    [_menuViewController.infoButton addTarget:self action:@selector(navigateToInformation) forControlEvents:UIControlEventTouchUpInside];
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
    [self navigateToBill:bill segment:nil];
}

- (void)navigateToBill:(SFBill *)bill segment:(NSString *)segmentName
{
    [self selectViewController:_billsViewController];
    if (bill) {
        SFBillSegmentedViewController *controller = [SFBillSegmentedViewController new];
        [controller setBill:bill];
        if (segmentName) {
            [controller setVisibleSegment:segmentName];
        }
        [_navigationController pushViewController:controller animated:NO];
    }
}

- (void)navigateToLegislator:(SFLegislator *)legislator
{
    [self navigateToLegislator:legislator segment:nil];
}

- (void)navigateToLegislator:(SFLegislator *)legislator segment:(NSString *)segmentName
{
    [self selectViewController:_legislatorsViewController];
    if (legislator) {
        SFLegislatorSegmentedViewController *controller = [SFLegislatorSegmentedViewController new];
        if (segmentName) {
            [controller setVisibleSegment:segmentName];
        }
        [controller setLegislator:legislator];
        [_navigationController pushViewController:controller animated:NO];
    }

}

- (void)navigateToCommittee:(SFCommittee *)committee
{
    [self navigateToCommittee:committee segment:nil];
}

- (void)navigateToCommittee:(SFCommittee *)committee segment:(NSString *)segmentName
{
    [self selectViewController:_committeesViewController];
    if (committee) {
        SFCommitteeSegmentedViewController *controller = [[SFCommitteeSegmentedViewController alloc] initWithCommittee:committee];
        if (segmentName) {
            [controller setVisibleSegment:segmentName];
        }
        [_navigationController pushViewController:controller animated:NO];
    }

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
    [self selectViewController:_followingViewController];
}

- (void)navigateToSettings
{
    [self selectViewController:_settingsViewController];
}

- (void)navigateToInformation
{
    [self selectViewController:_informationViewController];
}

#pragma mark - UITableViewDelegate

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
    else if ([viewControllerClassName isEqualToString:@"SFFollowingSectionViewController"]) {
        restorationViewController = _followingViewController;
    }
    if (restorationViewController) {
        [_menuViewController selectMenuItemForController:restorationViewController animated:YES];
        restorationViewController = nil;
    }
}

@end
