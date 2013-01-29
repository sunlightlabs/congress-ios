//
//  SFAppDelegate.m
//  Congress
//
//  Created by Daniel Cloud on 11/15/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFAppDelegate.h"
#import <Crashlytics/Crashlytics.h>
#import "IIViewDeckController.h"
#import "SFMenuViewController.h"
#import "SFActivityListViewController.h"
#import "SFBillListViewController.h"
#import "SFLegislatorsSectionViewController.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "SFDataArchiver.h"
#import "SFLegislator.h"
#import "SFBill.h"

@implementation SFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

#if CONFIGURATION_Beta
    [TestFlight takeOff:kTFTeamToken];
#endif

#if CONFIGURATION_Release
    #define MR_ENABLE_ACTIVE_RECORD_LOGGING 0
#endif

    [Crashlytics startWithAPIKey:kCrashlyticsApiKey];

    // Let AFNetworking manage NetworkActivityIndicator
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];


    // Set up default viewControllers
    [self setUpControllers];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self unarchiveObjects];
    });


    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    dispatch_async(dispatch_get_main_queue(), ^{
        [self archiveObjects];
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    dispatch_async(dispatch_get_main_queue(), ^{
        [self archiveObjects];
    });
}

#pragma mark - Private setup

-(void)setUpControllers
{
    self.mainController = [[UINavigationController alloc] initWithRootViewController:[[SFActivityListViewController alloc] init]];

    self.leftController = [[SFMenuViewController alloc] initWithControllers:@[
                           self.mainController,
                           [[UINavigationController alloc] initWithRootViewController:[[SFBillListViewController alloc] init]],
                           [[UINavigationController alloc] initWithRootViewController:[[SFLegislatorsSectionViewController alloc] init]]
                           ] menuLabels:@[@"All Activity", @"Bills", @"Legislators"]];
    IIViewDeckController *deckController = [[IIViewDeckController alloc] initWithCenterViewController:self.mainController leftViewController:self.leftController];
    deckController.navigationControllerBehavior = IIViewDeckNavigationControllerContained;
    deckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    [deckController setLeftSize:80.0f];

    self.window.rootViewController = deckController;
}

#pragma mark - Data persistence

-(void)archiveObjects
{
    NSMutableArray *archiveObjects = [NSMutableArray array];
    [archiveObjects addObjectsFromArray:[SFLegislator allObjectsToPersist]];
    [archiveObjects addObjectsFromArray:[SFBill allObjectsToPersist]];
    SFDataArchiver *archiver = [SFDataArchiver initWithObjectsToSave:archiveObjects];
    [archiver save];
}

-(void)unarchiveObjects
{
    SFDataArchiver *archiver = [[SFDataArchiver alloc] init];
    NSArray* objectList = [archiver load];
    for (id object in objectList) {
        [object addObjectToCollection];
    }
}

@end
