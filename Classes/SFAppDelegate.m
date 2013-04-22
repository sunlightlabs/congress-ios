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
#import "SFCongressNavigationController.h"
#import "SFMenuViewController.h"
#import "AFHTTPClient.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "SFDataArchiver.h"
#import "SFLegislator.h"
#import "SFBill.h"
#import "SFCongressAppStyle.h"
#import "GAI.h"

@implementation SFAppDelegate
{
    UIAlertView *_networkUnreachableAlert;
    SFCongressNavigationController *_navigationController;

}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor primaryBackgroundColor];
    // Set up default viewControllers
    [self setUpControllers];
    [SFCongressAppStyle setUpGlobalStyles];

#if CONFIGURATION_Beta
    #define NSLog(__FORMAT__, ...) TFLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
    [TestFlight takeOff:kTFTeamToken];
#endif

#if CONFIGURATION_Release
    #define NSLog(...)
    #define MR_ENABLE_ACTIVE_RECORD_LOGGING 0
#endif

#if CONFIGURATION_Debug
    NSLog(@"Running in debug configuration");
#endif

    [Crashlytics startWithAPIKey:kCrashlyticsApiKey];
    
//    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
#if (CONFIGURATION_Debug || CONFIGURATION_Beta)
    [GAI sharedInstance].debug = NO;
    [[GAI sharedInstance] trackerWithTrackingId:kGoogleAnalyticsID];
#endif

    // Let AFNetworking manage NetworkActivityIndicator
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    self.wasLastUnreachable = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAPIReachabilityChange:)
                                                 name:AFNetworkingReachabilityDidChangeNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataSaveRequest:)
                                                 name:SFDataArchiveRequestNotification object:nil];


    __weak SFAppDelegate *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.dataArchiver = [[SFDataArchiver alloc] init];
        [weakSelf unarchiveObjects];
    });

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
    [self archiveObjects];
    self.backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundTask];
    }];
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
    if (!self.backgroundTaskIdentifier) {
        [self archiveObjects];
        self.backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^{
            [self endBackgroundTask];
        }];
    }
}

#pragma mark - Private setup

-(void)setUpControllers
{
    _navigationController = [[SFCongressNavigationController alloc] init];
    self.mainController = _navigationController;
    
    NSArray *viewControllers = [[NSArray alloc]
        initWithObjects:_navigationController.activityViewController, _navigationController.favoritesViewController, _navigationController.billsViewController, _navigationController.legislatorsViewController, nil];
    NSArray *labels = [[NSArray alloc]
        initWithObjects:@"Latest Activity", @"Following", @"Bills", @"Legislators", nil];

    self.leftController = [[SFMenuViewController alloc] initWithControllers:viewControllers
                                                                 menuLabels:labels
                                                                   settings:_navigationController.settingsViewController];

    IIViewDeckController *deckController = [[IIViewDeckController alloc] initWithCenterViewController:self.mainController leftViewController:self.leftController];
    deckController.restorationIdentifier = NSStringFromClass(deckController.class);
    deckController.navigationControllerBehavior = IIViewDeckNavigationControllerContained;
    deckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    [deckController setLeftSize:80.0f];

    self.window.rootViewController = deckController;
}

#pragma mark - Data persistence

-(void)archiveObjects
{
    if (!self.dataArchiver) {
        self.dataArchiver = [[SFDataArchiver alloc] init];
    }
    NSMutableArray *archiveObjects = [NSMutableArray array];
    [archiveObjects addObjectsFromArray:[SFLegislator allObjectsToPersist]];
    [archiveObjects addObjectsFromArray:[SFBill allObjectsToPersist]];
    self.dataArchiver.archiveObjects = archiveObjects;
    BOOL saved = [self.dataArchiver save];
    NSLog(@"Data saved: %@", (saved ? @"YES" : @"NO"));
}

-(void)unarchiveObjects
{
    if (!self.dataArchiver) {
        self.dataArchiver = [[SFDataArchiver alloc] init];
    }
    NSArray* objectList = [self.dataArchiver load];
    for (id object in objectList) {
        [object addObjectToCollection];
    }
}

#pragma mark - Background Task

-(void)endBackgroundTask
{
    __weak SFAppDelegate *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        SFAppDelegate *strongSelf = weakSelf;
        if (strongSelf != nil) {
            [[UIApplication sharedApplication] endBackgroundTask:strongSelf.backgroundTaskIdentifier];
            strongSelf.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        }
    });

}

#pragma mark - API reachability alert

- (void)handleAPIReachabilityChange:(NSNotification*)notification
{
    NSNumber *statusCode = [notification.userInfo objectForKey:AFNetworkingReachabilityNotificationStatusItem];
    if ([statusCode integerValue] == AFNetworkReachabilityStatusNotReachable) {
        if (!self.wasLastUnreachable && _networkUnreachableAlert == nil) {
            NSString *alertMessage = @"Congress was unable to connect to our servers. Please try again later.";
            _networkUnreachableAlert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:alertMessage
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [_networkUnreachableAlert show];
        }
        self.wasLastUnreachable = YES;
    }
    else{
        self.wasLastUnreachable = NO;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([alertView isEqual:_networkUnreachableAlert] && buttonIndex == alertView.cancelButtonIndex) {
        _networkUnreachableAlert = nil;
    }
}

#pragma mark - Data save notification

- (void)handleDataSaveRequest:(NSNotification*)notification
{
    __weak SFAppDelegate *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        SFAppDelegate *strongSelf = weakSelf;
        [strongSelf archiveObjects];
    });

}

#pragma mark - Application state restoration

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    NSString *rootViewClass = NSStringFromClass([IIViewDeckController class]);
    NSString *menuViewClass = NSStringFromClass([SFMenuViewController class]);
    NSString *navControllerClass = NSStringFromClass([SFCongressNavigationController class]);
    NSString *lastObjectName = [identifierComponents lastObject];
    NSLog(@"\n===App identifierComponents===\n%@\n========================", [identifierComponents componentsJoinedByString:@"/"]);

    if ([lastObjectName isEqualToString:rootViewClass]) {
        return self.window.rootViewController;
    }
    else if ([lastObjectName isEqualToString:menuViewClass]) {
        return self.leftController;
    }
    else if ([lastObjectName isEqualToString:navControllerClass]) {
        IIViewDeckController *controller = (IIViewDeckController *) self.window.rootViewController;
        return controller.centerController;
    }
    else if ([lastObjectName isEqualToString:@"SFSettingsSectionViewController"]) {
        return _navigationController.settingsViewController;
    }
    else if ([lastObjectName isEqualToString:@"SFActivitySectionViewController"]) {
        return _navigationController.activityViewController;
    }
    else if ([lastObjectName isEqualToString:@"SFBillsSectionViewController"]) {
        return _navigationController.billsViewController;
    }
    else if ([lastObjectName isEqualToString:@"SFLegislatorsSectionViewController"]) {
        return _navigationController.legislatorsViewController;
    }
    else if ([lastObjectName isEqualToString:@"SFFavoritesSectionViewController"]) {
        return _navigationController.favoritesViewController;
    }
    return nil;
}

@end
