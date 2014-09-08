//
//  SFAppSettings.h
//  Congress
//
//  Created by Jeremy Carbaugh on 5/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSharedInstance.h"

typedef NSString SFAppSettingsKey;

FOUNDATION_EXPORT NSString *const SFAppSettingChangedNotification;

FOUNDATION_EXPORT SFAppSettingsKey *const SFNotificationSettings;
FOUNDATION_EXPORT SFAppSettingsKey *const SFBillActionSetting;
FOUNDATION_EXPORT SFAppSettingsKey *const SFBillSignedSetting;
FOUNDATION_EXPORT SFAppSettingsKey *const SFBillVoteSetting;
FOUNDATION_EXPORT SFAppSettingsKey *const SFBillUpcomingSetting;
FOUNDATION_EXPORT SFAppSettingsKey *const SFCommitteeBillReferredSetting;
FOUNDATION_EXPORT SFAppSettingsKey *const SFLegislatorBillIntroSetting;
FOUNDATION_EXPORT SFAppSettingsKey *const SFLegislatorBillUpcomingSetting;
FOUNDATION_EXPORT SFAppSettingsKey *const SFLegislatorVoteSetting;
FOUNDATION_EXPORT SFAppSettingsKey *const SFOtherImportantSetting;
FOUNDATION_EXPORT SFAppSettingsKey *const SFOtherAppSetting;

FOUNDATION_EXPORT SFAppSettingsKey *const SFGoogleAnalyticsOptOut;

FOUNDATION_EXPORT SFAppSettingsKey *const SFTestingSettings;
FOUNDATION_EXPORT SFAppSettingsKey *const SFTestingNotificationsSetting;

FOUNDATION_EXPORT SFAppSettingsKey *const SFDebugSettings;
FOUNDATION_EXPORT SFAppSettingsKey *const SFOCEmailConfirmation;


@interface SFAppSettings : NSObject <SFSharedInstance>

@property (nonatomic, readwrite, ) BOOL googleAnalyticsOptOut;
@property (nonatomic, strong, readonly) NSDictionary *notificationSettings;

- (void)configureDefaults;
- (void)loadRemoteConfiguration:(NSString *)remoteId;
- (BOOL)boolForNotificationSetting:(NSString *)notificationSetting;
- (void)setBool:(BOOL)value forNotificationSetting:(NSString *)notificationSetting;
- (BOOL)remoteNotificationTypesEnabled;
- (BOOL)boolForTestingSetting:(NSString *)testingSetting;
- (void)setBool:(BOOL)value forTestingSetting:(NSString *)notificationSetting;
- (BOOL)synchronize;

@end
