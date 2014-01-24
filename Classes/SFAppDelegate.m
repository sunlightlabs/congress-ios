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
#import <AFNetworkActivityIndicatorManager.h>
#import <AFNetworkReachabilityManager.h>
#import "SFDataArchiver.h"
#import "SFSynchronizedObjectManager.h"
#import "SFLegislator.h"
#import "SFBill.h"
#import "SFCommittee.h"
#import "SFCommitteeService.h"
#import "SFCongressAppStyle.h"
#import <UAirship.h>
#import <UAConfig.h>
#import <UAPush.h>
#import <UATagUtils.h>
#import "SFPushConfig.h"
#import "SFTagManager.h"
#import "SFFollowButton.h"

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

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Set up default viewControllers
    [self setRootViewController];
    [SFCongressAppStyle setUpGlobalStyles];

#if CONFIGURATION_Beta
    #define NSLog(__FORMAT__, ...) TFLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__)
    [TestFlight takeOff:kTFTeamToken];
#endif

#if CONFIGURATION_Release
    #define NSLog(...)
#endif

#if CONFIGURATION_Debug
    NSLog(@"Running in debug configuration");
#endif

    [self _setupNetworkManagers];

    self.settingsToNotificationTypes = @{
        SFBillActionSetting: SFBillActionNotificationType,
        SFBillUpcomingSetting: SFBillUpcomingNotificationType,
        SFBillVoteSetting: SFBillVoteNotificationType,
        SFLegislatorBillIntroSetting: SFLegislatorBillIntroNotificationType,
        SFLegislatorBillUpcomingSetting: SFLegislatorBillUpcomingNotificationType,
        SFLegislatorVoteSetting: SFLegislatorVoteNotificationType,
        SFCommitteeBillReferredSetting: SFCommitteeBillReferredNotificationType
    };


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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Crashlytics startWithAPIKey:kCrashlyticsApiKey];
    [SFAppSettings configureDefaults];
    [self setUpGoogleAnalytics];
    [self setUpRoutes];

    // Register for remote notifications.
    [self setUpPush];

    // Fetch remote configuration
    [self fetchRemoteConfiguration];

    // Set up observation of object persistence now that data has been loaded.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleObjectFollowed:)
                                                 name:SFSynchronizedObjectFollowedEvent object:nil];

    // Set up observation of app setting changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSettingsChange:)
                                                 name:SFAppSettingChangedNotification object:nil];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    [self archiveObjects];
    [self updateNotificationTypeTags];
    // Attempt to save settings, which can be used to update tags when app becomes active again.
    [[SFAppSettings sharedInstance] synchronize];
    self.backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler: ^{
        [self endBackgroundTask];
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self updateNotificationTypeTags];
    [self fetchRemoteConfiguration];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    if (!self.backgroundTaskIdentifier) {
        [self archiveObjects];
        // Attempt to save settings, which can be used to update tags when app relaunches.
        [[SFAppSettings sharedInstance] synchronize];
        self.backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler: ^{
            [self endBackgroundTask];
        }];
    }
}

#pragma mark - Notifications setup

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Application did register for notifications.");
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
}

#pragma mark - Private setup

- (void)setRootViewController {
    _mainController = [[SFViewDeckController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = _mainController;
}

- (void)setUpGoogleAnalytics {
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

- (NSString *)_pathForClass:(Class)classDef {
    if ([classDef isSubclassOfClass:[SFSynchronizedObject class]]) {
        return [NSString pathWithComponents:@[@"/", [classDef remoteResourceName], [@":" stringByAppendingString:[classDef remoteIdentifierKey]]]];
    }
    return nil;
}

- (void)setUpRoutes {
    NSString *path;
//    MARK: SFBill routes
    path = [self _pathForClass:[SFBill class]];
    [JLRoutes addRoute:[path stringByDeletingLastPathComponent] handler: ^BOOL (NSDictionary *parameters) {
        NSString *query = [parameters objectForKey:@"q"];
        [_mainController navigateToBill:nil];
        [_mainController.billsViewController searchFor:query withKeyboard:NO];
        return YES;
    }];
    [JLRoutes addRoute:path handler: ^BOOL (NSDictionary *parameters) {
        [SFBillService billWithId:parameters[@"billId"] completionBlock: ^(SFBill *bill) {
                [_mainController navigateToBill:bill];
                [_mainController.billsViewController searchFor:nil withKeyboard:NO];
            }];
        return YES;
    }];
    //    SFBill route to segment
    [JLRoutes addRoute:[path stringByAppendingString:@"/:segmentName/"] handler: ^BOOL (NSDictionary *parameters) {
        [SFBillService billWithId:parameters[@"billId"] completionBlock: ^(SFBill *bill) {
                [_mainController navigateToBill:bill segment:parameters[@"segmentName"]];
            }];
        return YES;
    }];
    //    MARK: SFLegislator routes
    path = [self _pathForClass:[SFLegislator class]];
    [JLRoutes addRoute:[path stringByDeletingLastPathComponent] handler: ^BOOL (NSDictionary *parameters) {
        [_mainController navigateToLegislator:nil];
        return YES;
    }];
    [JLRoutes addRoute:path handler: ^BOOL (NSDictionary *parameters) {
        if ([parameters[@"bioguideId"] isEqualToString:@"local"]) {
            [_mainController navigateToLegislator:nil];
            [_mainController.navigationController pushViewController:[SFLocalLegislatorsViewController new] animated:NO];
        }
        else {
            [SFLegislatorService legislatorWithId:parameters[@"bioguideId"] completionBlock: ^(SFLegislator *legislator) {
                    [_mainController navigateToLegislator:legislator];
                }];
        }
        return YES;
    }];
    [JLRoutes addRoute:[path stringByAppendingString:@"/:segmentName/"] handler: ^BOOL (NSDictionary *parameters) {
        [SFLegislatorService legislatorWithId:parameters[@"bioguideId"] completionBlock: ^(SFLegislator *legislator) {
                [_mainController navigateToLegislator:legislator segment:parameters[@"segmentName"]];
            }];
        return YES;
    }];
//    MARK: SFCommittee routes
    path = [self _pathForClass:[SFCommittee class]];
    [JLRoutes addRoute:[path stringByDeletingLastPathComponent] handler: ^BOOL (NSDictionary *parameters) {
        [_mainController navigateToCommittee:nil];
        return YES;
    }];
    [JLRoutes addRoute:path handler: ^BOOL (NSDictionary *parameters) {
        [SFCommitteeService committeeWithId:parameters[@"committeeId"] completionBlock: ^(SFCommittee *committee) {
                [_mainController navigateToCommittee:committee];
            }];
        return YES;
    }];
//    SFCommittee route to segment
    [JLRoutes addRoute:[path stringByAppendingString:@"/:segmentName/"] handler: ^BOOL (NSDictionary *parameters) {
        [SFCommitteeService committeeWithId:parameters[@"committeeId"] completionBlock: ^(SFCommittee *committee) {
                [_mainController navigateToCommittee:committee segment:parameters[@"segmentName"]];
            }];
        return YES;
    }];
//    MARK: settings routes
    [JLRoutes addRoute:@"/configuration/:remoteID" handler: ^BOOL (NSDictionary *parameters) {
        NSLog(@"Configuration URL triggered.");
        [[SFAppSettings sharedInstance] loadRemoteConfiguration:parameters[@"remoteID"]];
        return YES;
    }];
    if (kSFCrashPath) {
        [JLRoutes addRoute:kSFCrashPath handler: ^BOOL (NSDictionary *parameters) {
            [[Crashlytics sharedInstance] crash];
            return YES;
        }];
    }
}

- (void)setUpPush {
    BOOL isSimulator = [[UIDevice currentDevice] isSimulator];
    [UAPush shared].pushNotificationDelegate = self;
    if (isSimulator == NO) {
        UAConfig *config = (UAConfig *)[SFPushConfig defaultConfig];

        BOOL validConfig = [config validate];

        if (validConfig) {
            BOOL isTestingNotifications = [[SFAppSettings sharedInstance] boolForTestingSetting:SFTestingNotificationsSetting];

            [UAirship takeOff:config];

            // Don't enable by default and use testing flag.
            [UAPush setDefaultPushEnabledValue:NO];
            [[UAPush shared] setPushEnabled:isTestingNotifications];

            if (!self.tagManager) {
                self.tagManager = [SFTagManager sharedInstance];
            }
            // Wait for objects to be unarchived before updating tags.
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTagsOnDataLoaded:)
                                                         name:SFDataArchiveLoadedNotification object:nil];
        }
        else {
            NSLog(@"UAConfig is invalid. Push will not work.");
        }
    }
    else {
        NSLog(@"Push not set up. Simulator does not support remote Notifications.");
    }
}

- (void)fetchRemoteConfiguration {
    //Retrieve remote configuration, if kSFDefaultRemoteConfigurationId is set
    if (kSFDefaultRemoteConfigurationId) {
        [[SFAppSettings sharedInstance] loadRemoteConfiguration:kSFDefaultRemoteConfigurationId];
    }
}

#pragma mark - Data persistence

- (void)archiveObjects {
    if (!self.dataArchiver) {
        self.dataArchiver = [[SFDataArchiver alloc] init];
    }
    NSArray *archiveObjects = [[SFSynchronizedObjectManager sharedInstance] allFollowedObjects];
    self.dataArchiver.archiveObjects = archiveObjects;
    BOOL saved = [self.dataArchiver save];
    NSLog(@"Data saved: %@", (saved ? @"YES" : @"NO"));
}

- (void)unarchiveObjects {
    if (!self.dataArchiver) {
        self.dataArchiver = [[SFDataArchiver alloc] init];
    }
    NSArray *objectList = [self.dataArchiver load];
    for (id object in objectList) {
        [[SFSynchronizedObjectManager sharedInstance] addObject:object];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SFDataArchiveLoadedNotification object:self];
}

- (void)_asynchronousArchiveObjects {
    __weak SFAppDelegate *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        SFAppDelegate *strongSelf = weakSelf;
        [strongSelf archiveObjects];
    });
}

#pragma mark - Background Task

- (void)endBackgroundTask {
    __weak SFAppDelegate *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        SFAppDelegate *strongSelf = weakSelf;
        if (strongSelf != nil) {
            [[UIApplication sharedApplication] endBackgroundTask:strongSelf.backgroundTaskIdentifier];
            strongSelf.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        }
    });
}

#pragma mark - Network reachability

- (void)_setupNetworkManagers {
    // Let AFNetworking manage NetworkActivityIndicator
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    self.wasLastUnreachable = NO;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock: ^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            if (!self.wasLastUnreachable && _networkUnreachableAlert == nil) {
                [SFMessage showInternetError];
            }
            self.wasLastUnreachable = YES;
        }
        else {
            self.wasLastUnreachable = NO;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark - Data save notification

- (void)handleDataSaveRequest:(NSNotification *)notification {
    [self _asynchronousArchiveObjects];
}

#pragma mark - Push notifications

- (void)updateTagsOnDataLoaded:(NSNotification *)notification {
    if ([notification.name isEqualToString:SFDataArchiveLoadedNotification]) {
        [self.tagManager updateFollowedObjectTags];
    }
}

- (void)updateNotificationTypeTags {
    NSDictionary *settings = [[SFAppSettings sharedInstance] notificationSettings];
    NSMutableArray *onTags = [NSMutableArray array];
    NSMutableArray *offTags = [NSMutableArray array];
    [settings enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        BOOL shouldFollowTag = [(NSNumber *)obj boolValue];
        SFNotificationType *notificationType = [self.settingsToNotificationTypes valueForKey:key];
        if (notificationType) {
            if (shouldFollowTag) {
                [onTags addObject:notificationType];
            }
            else {
                [offTags addObject:notificationType];
            }
        }
    }];
    [self.tagManager addTagsForNotificationTypes:onTags];
    [self.tagManager removeTagsForNotificationTypes:offTags];
    // In case we somehow added a notificationType as a tag
    [self.tagManager removeTagsFromCurrentDevice:onTags];
    [self.tagManager removeTagsFromCurrentDevice:offTags];
}

#pragma mark - UAPushNotificationDelegate methods

- (void)launchedFromNotification:(NSDictionary *)notification {
    NSLog(@"launchedFromNotification");
    NSString *urlString;
    @try {
        id urlValue = [notification valueForKey:@"app_url"];
        if ([urlValue isKindOfClass:[NSString class]]) {
            urlString = (NSString *)urlValue;
        }
    }
    @catch (NSException *exception)
    {
        if ([exception.name isEqualToString:NSUndefinedKeyException]) {
            NSLog(@"Notification payload does not contain key 'app_url'");
        }
    }

    if (urlString) {
        NSURL *notificationURL = [NSURL URLWithString:urlString];
        if ([JLRoutes canRouteURL:notificationURL]) {
            [JLRoutes routeURL:notificationURL];
        }
        else {
            NSLog(@"Invalid app url provided by notification");
        }
    }
}

- (void)receivedBackgroundNotification:(NSDictionary *)notification {
    NSLog(@"receivedBackgroundNotification");
}

- (void)receivedForegroundNotification:(NSDictionary *)notification {
    NSLog(@"receivedForegroundNotification");
}

#pragma mark - SFSynchronizedObjectFollowedEvent

- (void)handleObjectFollowed:(NSNotification *)notification {
    SFSynchronizedObject *object = (SFSynchronizedObject *)notification.object;
    if ([object isFollowed]) {
        [self.tagManager addTagToCurrentDevice:object.resourcePath];
    }
    else {
        [self.tagManager removeTagFromCurrentDevice:object.resourcePath];
    }
//    run archiveObjects afterDelay after cancelling any previous requests
    SEL selector = @selector(_asynchronousArchiveObjects);
    [SFAppDelegate cancelPreviousPerformRequestsWithTarget:self selector:selector object:nil];
    [self performSelector:selector withObject:nil afterDelay:10.0];
}

#pragma mark - SFAppSettingChangedNotification

- (void)handleSettingsChange:(NSNotification *)notification {
    BOOL isTestingNotifications = [[SFAppSettings sharedInstance] boolForTestingSetting:SFTestingNotificationsSetting];
    [[UAPush shared] setPushEnabled:isTestingNotifications];

    if (self.tagManager) {
        BOOL shouldFollowTag = [(NSNumber *)[notification.userInfo valueForKey:@"value"] boolValue];
        SFAppSettingsKey *appSetting = [notification.userInfo valueForKey:@"setting"];
        SFNotificationType *notificationType = [self.settingsToNotificationTypes valueForKey:appSetting];
        if (notificationType) {
            if (shouldFollowTag) {
                NSLog(@"Do follow    : %@", appSetting);
                [self.tagManager addTagForNotificationType:notificationType];
            }
            else {
                NSLog(@"Do NOT follow: %@", appSetting);
                [self.tagManager removeTagForNotificationType:notificationType];
            }
        }
    }
}

#pragma mark - URL scheme

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[url scheme] isEqualToString:@"congress"]) {
        [JLRoutes routeURL:url];
        return YES;
    }
    return NO;
}

#pragma mark - Application state restoration

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
    return YES;
}

- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {
    NSString *lastObjectName = [identifierComponents lastObject];

    NSLog(@"\n===App identifierComponents===\n%@\n========================", [identifierComponents componentsJoinedByString:@"/"]);

    if ([lastObjectName isEqualToString:@"SFViewDeckController"]) {
        if (!self.window.rootViewController) {
            [self setRootViewController];
        }
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
    else if ([lastObjectName isEqualToString:@"SFFollowingSectionViewController"]) {
        return _mainController.followingViewController;
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
