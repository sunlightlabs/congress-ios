//
//  SFAppSettings.h
//  Congress
//
//  Created by Jeremy Carbaugh on 5/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSharedInstance.h"

FOUNDATION_EXPORT NSString *const kSFBillActionSetting;
FOUNDATION_EXPORT NSString *const kSFBillVoteSetting;
FOUNDATION_EXPORT NSString *const kSFBillUpcomingSetting;
FOUNDATION_EXPORT NSString *const kSFCommitteeBillReferredSetting;
FOUNDATION_EXPORT NSString *const kSFLegislatorBillIntroSetting;
FOUNDATION_EXPORT NSString *const kSFLegislatorBillUpcomingSetting;
FOUNDATION_EXPORT NSString *const kSFLegislatorVoteSetting;

FOUNDATION_EXPORT NSString *const kSFGoogleAnalyticsOptOut;

@interface SFAppSettings : NSObject <SFSharedInstance>

@property (nonatomic, readwrite,) BOOL googleAnalyticsOptOut;

+ (void)configureDefaults;
- (BOOL)boolForNotificationSetting:(NSString *)notificationSetting;
- (void)setBool:(BOOL)value forNotificationSetting:(NSString *)notificationSetting;

@end
