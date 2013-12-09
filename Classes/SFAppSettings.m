//
//  SFAppSettings.m
//  Congress
//
//  Created by Jeremy Carbaugh on 5/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFAppSettings.h"

NSString *const kSFBillActionSetting = @"SFBillActionSetting";
NSString *const kSFBillVoteSetting = @"SFBillVoteSetting";
NSString *const kSFBillUpcomingSetting = @"SFBillUpcomingSetting";
NSString *const kSFCommitteeBillReferredSetting = @"SFCommitteeBillReferredSetting";
NSString *const kSFLegislatorBillIntroSetting = @"SFLegislatorBillIntroSetting";
NSString *const kSFLegislatorBillUpcomingSetting = @"SFLegislatorBillUpcomingSetting";
NSString *const kSFLegislatorVoteSetting = @"SFLegislatorVoteSetting";

NSString *const kSFGoogleAnalyticsOptOut = @"googleAnalyticsOptOut";

@implementation SFAppSettings

+(id)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[SFAppSettings alloc] init];
    });
}

+ (void)configureDefaults
{
    NSMutableDictionary *appDefaults = [NSMutableDictionary dictionaryWithDictionary:@{ kSFGoogleAnalyticsOptOut: @NO }];
    NSArray *notificationSetting = [self notificationSettingNames];
    for (NSString *name in notificationSetting) {
        [appDefaults setObject:@YES forKey:name];
    }

    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
}

+ (NSArray *)notificationSettingNames
{
    return @[kSFBillActionSetting,
             kSFBillVoteSetting,
             kSFBillUpcomingSetting,
             kSFCommitteeBillReferredSetting,
             kSFLegislatorBillIntroSetting,
             kSFLegislatorBillUpcomingSetting,
             kSFLegislatorVoteSetting
             ];
}

#pragma mark - SFAppSettings public

- (BOOL)googleAnalyticsOptOut
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSFGoogleAnalyticsOptOut] ?: NO;
}

- (void)setGoogleAnalyticsOptOut:(BOOL)optOut
{
    NSLog(@"%@ Google Analytics opt-out", optOut ? @"enabling" : @"disabling");
    [[GAI sharedInstance] setOptOut:optOut];
    [[NSUserDefaults standardUserDefaults] setBool:optOut forKey:kSFGoogleAnalyticsOptOut];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)boolForNotificationSetting:(NSString *)notificationSetting
{
    if ([[[self class] notificationSettingNames] containsObject:notificationSetting]) {
        return [[NSUserDefaults standardUserDefaults] boolForKey:notificationSetting] ?: YES;
    }
    return @NO;
}

- (void)setBool:(BOOL)value forNotificationSetting:(NSString *)notificationSetting
{
    if ([[[self class] notificationSettingNames] containsObject:notificationSetting]) {
        [[NSUserDefaults standardUserDefaults] setBool:value forKey:notificationSetting];
    }
}

@end
