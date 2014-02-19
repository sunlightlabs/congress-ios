//
//  SFAppSettings.m
//  Congress
//
//  Created by Jeremy Carbaugh on 5/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFAppSettings.h"
#import "SFSettingsDataSource.h"
#import "NSUserDefaults+GroundControl.h"

NSString *const SFAppSettingChangedNotification = @"SFAppSettingChangedNotification";

SFAppSettingsKey *const SFNotificationSettings = @"SFNotificationSettings";
SFAppSettingsKey *const SFBillActionSetting = @"SFBillActionSetting";
SFAppSettingsKey *const SFBillSignedSetting = @"SFBillSignedSetting";
SFAppSettingsKey *const SFBillVoteSetting = @"SFBillVoteSetting";
SFAppSettingsKey *const SFBillUpcomingSetting = @"SFBillUpcomingSetting";
SFAppSettingsKey *const SFCommitteeBillReferredSetting = @"SFCommitteeBillReferredSetting";
SFAppSettingsKey *const SFLegislatorBillIntroSetting = @"SFLegislatorBillIntroSetting";
SFAppSettingsKey *const SFLegislatorBillUpcomingSetting = @"SFLegislatorBillUpcomingSetting";
SFAppSettingsKey *const SFLegislatorVoteSetting = @"SFLegislatorVoteSetting";
SFAppSettingsKey *const SFOtherImportantSetting = @"SFOtherImportantSetting";
SFAppSettingsKey *const SFOtherAppSetting = @"SFOtherAppSetting";

SFAppSettingsKey *const SFGoogleAnalyticsOptOut = @"googleAnalyticsOptOut";

SFAppSettingsKey *const SFTestingSettings = @"SFTestingSettings";
SFAppSettingsKey *const SFTestingNotificationsSetting = @"SFTestingNotificationsSetting";

@implementation SFAppSettings
{
    NSMutableDictionary *_notificationSettings;
    NSMutableDictionary *_testingSettings;
    NSURL *_remoteConfigURL;
}

+ (id)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK ( ^{
        return [[SFAppSettings alloc] init];
    });
}

+ (void)configureDefaults {
    NSDictionary *appDefaults = @{ SFGoogleAnalyticsOptOut: @NO,
                                   SFNotificationSettings: [self notificationSettingDefaults],
                                   SFTestingSettings: [self testingSettingsDefaults] };

    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
}

+ (NSDictionary *)notificationSettingDefaults {
    return @{ SFBillActionSetting: @YES,
              SFBillSignedSetting: @NO,
              SFBillVoteSetting: @YES,
              SFBillUpcomingSetting: @YES,
              SFCommitteeBillReferredSetting: @YES,
              SFLegislatorBillIntroSetting: @YES,
              SFLegislatorBillUpcomingSetting: @YES,
              SFLegislatorVoteSetting: @YES,
              SFOtherAppSetting: @NO,
              SFOtherImportantSetting: @NO};
}

// Testing related settings.
+ (NSDictionary *)testingSettingsDefaults {
    return @{
               SFTestingNotificationsSetting: @NO
    };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _notificationSettings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:SFNotificationSettings]];
        _testingSettings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:SFTestingSettings]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSettingsValueChange:) name:SFSettingsValueChangeNotification object:nil];
        if (kSFRemoteConfigurationURL) {
            _remoteConfigURL = [NSURL URLWithString:kSFRemoteConfigurationURL];
        }
    }
    return self;
}

#pragma mark - Property accessors

- (NSDictionary *)notificationSettings {
    return [_notificationSettings copy];
}

#pragma mark - SFAppSettings public

- (void)loadRemoteConfiguration:(NSString *)remoteId {
    if (_remoteConfigURL) {
        NSURL *remoteConfig = [_remoteConfigURL URLByAppendingPathComponent:[remoteId stringByAppendingPathExtension:@"plist"]];
        [[NSUserDefaults standardUserDefaults] registerDefaultsWithURL:remoteConfig success: ^(NSDictionary *defaults) {
            // Update _testingSettings from remote config.
            NSDictionary *newTestSettings = (NSDictionary *)[defaults objectForKey:SFTestingSettings];
            [_testingSettings addEntriesFromDictionary:newTestSettings];
            [[NSNotificationCenter defaultCenter] postNotificationName:SFAppSettingChangedNotification object:self userInfo:nil];
        } failure: ^(NSError *error) {
            NSLog(@"Remote configuration load error.");
        }];
    }
    else {
        NSLog(@"Can't load remote configuration: No remote configuration URL");
    }
}

- (BOOL)googleAnalyticsOptOut {
    return [[NSUserDefaults standardUserDefaults] boolForKey:SFGoogleAnalyticsOptOut] ? : NO;
}

- (void)setGoogleAnalyticsOptOut:(BOOL)optOut {
    NSLog(@"%@ Google Analytics opt-out", optOut ? @"enabling" : @"disabling");
    [[GAI sharedInstance] setOptOut:optOut];
    [[NSUserDefaults standardUserDefaults] setBool:optOut forKey:SFGoogleAnalyticsOptOut];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)boolForNotificationSetting:(NSString *)notificationSetting {
    if ([self _keyIsValidNotificationSetting:notificationSetting]) {
        NSNumber *booleanSetting = (NSNumber *)[_notificationSettings valueForKey:notificationSetting];
        return [booleanSetting boolValue];
    }
    return @NO;
}

- (void)setBool:(BOOL)value forNotificationSetting:(NSString *)notificationSetting {
    if ([self _keyIsValidNotificationSetting:notificationSetting]) {
        NSNumber *booleanSetting = [NSNumber numberWithBool:value];
        [_notificationSettings setValue:booleanSetting forKey:notificationSetting];
        [[NSUserDefaults standardUserDefaults] setObject:_notificationSettings forKey:SFNotificationSettings];
        [[NSNotificationCenter defaultCenter] postNotificationName:SFAppSettingChangedNotification object:self userInfo:@{ @"setting": notificationSetting, @"value":booleanSetting }];
    }
}

- (BOOL)remoteNotificationTypesEnabled {
    return (BOOL)([[UIApplication sharedApplication] enabledRemoteNotificationTypes] != UIRemoteNotificationTypeNone);
}

- (BOOL)boolForTestingSetting:(NSString *)testingSetting {
    if ([self _keyIsValidTestingSetting:testingSetting]) {
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSNumber *booleanSetting = (NSNumber *)[_testingSettings valueForKey:testingSetting];
        return [booleanSetting boolValue];
    }
    return @NO;
}

- (void)setBool:(BOOL)value forTestingSetting:(NSString *)testingSetting {
    if ([self _keyIsValidTestingSetting:testingSetting]) {
        NSNumber *booleanSetting = [NSNumber numberWithBool:value];
        [_testingSettings setValue:booleanSetting forKey:testingSetting];
        [[NSUserDefaults standardUserDefaults] setObject:_testingSettings forKey:SFTestingSettings];
    }
}

- (BOOL)synchronize {
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - NSNotification handlers

- (void)handleSettingsValueChange:(NSNotification *)notification {
    if ([[notification object] isKindOfClass:[SFSettingsDataSource class]]) {
        NSNumber *isOnNumber = [[notification userInfo] valueForKey:@"value"];
        NSString *settingIdentifier = [[notification userInfo] valueForKey:@"settingIdentifier"];
        if (isOnNumber && settingIdentifier) {
            BOOL isOn = [isOnNumber boolValue];
            if ([settingIdentifier isEqualToString:SFGoogleAnalyticsOptOut]) {
                [self setGoogleAnalyticsOptOut:!isOn];
            }
            else {
                [self setBool:isOn forNotificationSetting:settingIdentifier];
            }
        }
    }
}

#pragma mark - Private

- (BOOL)_keyIsValidNotificationSetting:(SFAppSettingsKey *)settingsKey {
    return [_notificationSettings valueForKey:settingsKey];
}

- (BOOL)_keyIsValidTestingSetting:(SFAppSettingsKey *)settingsKey {
    return [_testingSettings valueForKey:settingsKey];
}

@end
