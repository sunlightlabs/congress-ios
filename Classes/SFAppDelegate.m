//
//  SFAppDelegate.m
//  Congress
//
//  Created by Daniel Cloud on 11/15/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFAppDelegate.h"
#import <JLRoutes.h>
#import "SFBillService.h"
#import "SFLegislatorService.h"
#import "SFLocalLegislatorsViewController.h"
#import "AFHTTPClient.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "SFDataArchiver.h"
#import "SFLegislator.h"
#import "SFBill.h"
#import "SFCommittee.h"
#import "SFCongressAppStyle.h"

#if defined(__has_include)
#  if __has_include("Reveal.h")
#    warning "Reveal.framework included"
#    if CONFIGURATION_Release || CONFIGURATION_Beta
#      error "Building for release or Adhoc with Reveal.framework included! Please comment out podfile include and rerun 'pod install'."
#    endif
#  endif
#endif

@implementation SFAppDelegate
{
    UIAlertView *_networkUnreachableAlert;
}

@synthesize mainController = _mainController;

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor primaryBackgroundColor];
    self.window.tintColor = [UIColor defaultTintColor];
    // Set up default viewControllers
    [self setUpControllers];
    [SFCongressAppStyle setUpGlobalStyles];

#if CONFIGURATION_Beta
    #define NSLog(__FORMAT__, ...) TFLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
    [TestFlight takeOff:kTFTeamToken];
#endif

#if CONFIGURATION_Release
    #define NSLog(...)
#endif

#if CONFIGURATION_Debug
    NSLog(@"Running in debug configuration");
#endif

    // Let AFNetworking manage NetworkActivityIndicator
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    self.wasLastUnreachable = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAPIReachabilityChange:)
                                                 name:AFNetworkingReachabilityDidChangeNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataSaveRequest:)
                                                 name:SFDataArchiveSaveRequestNotification object:nil];


    __weak SFAppDelegate *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.dataArchiver = [[SFDataArchiver alloc] init];
        [weakSelf unarchiveObjects];
    });

    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:kCrashlyticsApiKey];
    [SFAppSettings configureDefaults];
    [self setUpGoogleAnalytics];
    [self setUpRoutes];
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
    _mainController = [[SFViewDeckController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = _mainController;
}

- (void)setUpGoogleAnalytics
{
    [[GAI sharedInstance] setDispatchInterval:30];
    [[GAI sharedInstance] setOptOut:[[SFAppSettings sharedInstance] googleAnalyticsOptOut]];
#if CONFIGURATION_Debug
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
#endif
    
    id tracker = nil;
    
#if CONFIGURATION_Beta
    if (kGoogleAnalyticsBetaID) {
        tracker = [[GAI sharedInstance] trackerWithTrackingId:kGoogleAnalyticsBetaID];
    }
#endif
#if CONFIGURATION_Release
    tracker = [[GAI sharedInstance] trackerWithTrackingId:kGoogleAnalyticsID];
#endif
    
    if (tracker) {
        NSDictionary *dict = [[GAIDictionaryBuilder createEventWithCategory:@"UX" action:@"appstart" label:nil value:nil] build];
        [dict setValue:@"start" forKey:kGAISessionControl];
        [tracker send:dict];
    }
}

- (void)setUpRoutes
{
    [JLRoutes addRoute:@"/bills" handler:^BOOL(NSDictionary *parameters) {
        NSString *query = [parameters objectForKey:@"q"];
        [_mainController navigateToBill:nil];
        [_mainController.billsViewController searchFor:query withKeyboard:NO];
        return YES;
    }];
    [JLRoutes addRoute:@"/bills/:billId" handler:^BOOL(NSDictionary *parameters) {
        [SFBillService billWithId:parameters[@"billId"] completionBlock:^(SFBill *bill) {
            [_mainController navigateToBill:bill];
            [_mainController.billsViewController searchFor:nil withKeyboard:NO];
        }];
        return YES;
    }];
    [JLRoutes addRoute:@"/legislators" handler:^BOOL(NSDictionary *parameters) {
        [_mainController navigateToLegislator:nil];
        return YES;
    }];
    [JLRoutes addRoute:@"/legislators/:bioguideId" handler:^BOOL(NSDictionary *parameters) {
        if ([parameters[@"bioguideId"] isEqualToString:@"local"]) {
            [_mainController navigateToLegislator:nil];
            [_mainController.navigationController pushViewController:[SFLocalLegislatorsViewController new] animated:NO];
        } else {
            [SFLegislatorService legislatorWithId:parameters[@"bioguideId"] completionBlock:^(SFLegislator *legislator) {
                [_mainController navigateToLegislator:legislator];
            }];
        }
        return YES;
    }];
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
    [archiveObjects addObjectsFromArray:[SFCommittee allObjectsToPersist]];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:SFDataArchiveLoadedNotification object:self];
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
            [SFMessage showInternetError];
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

#pragma mark - URL scheme

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([[url scheme] isEqualToString:@"congress"]) {
        [JLRoutes routeURL:url];
        return YES;
    }
    return NO;
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
    NSString *lastObjectName = [identifierComponents lastObject];
    
    NSLog(@"\n===App identifierComponents===\n%@\n========================", [identifierComponents componentsJoinedByString:@"/"]);

    if ([lastObjectName isEqualToString:@"SFViewDeckController"]) {
        return self.window.rootViewController;
    }
    else if ([lastObjectName isEqualToString:@"SFMenuViewController"]) {
        return _mainController.menuViewController;
    }
    else if ([lastObjectName isEqualToString:@"SFCongressNavigationController"]) {
        return _mainController.navigationController;
    }
    else if ([lastObjectName isEqualToString:@"SFSettingsSectionViewController"]) {
        return _mainController.settingsViewController;
    }
    else if ([lastObjectName isEqualToString:@"SFActivitySectionViewController"]) {
        return _mainController.activityViewController;
    }
    else if ([lastObjectName isEqualToString:@"SFBillsSectionViewController"]) {
        return _mainController.billsViewController;
    }
    else if ([lastObjectName isEqualToString:@"SFLegislatorsSectionViewController"]) {
        return _mainController.legislatorsViewController;
    }
    else if ([lastObjectName isEqualToString:@"SFFavoritesSectionViewController"]) {
        return _mainController.favoritesViewController;
    }
    else if ([lastObjectName isEqualToString:@"SFCommitteesSectionViewController"]) {
        return _mainController.committeesViewController;
    }
    else if ([lastObjectName isEqualToString:@"SFHearingsSectionViewController"]) {
        return _mainController.hearingsViewController;
    }
    return nil;
}

@end
