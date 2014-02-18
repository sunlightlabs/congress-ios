//
//  SFSettings.m
//  Congress
//
//  Created by Daniel Cloud on 11/15/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFSettings.h"

#pragma mark - API

// Remove the #error once you have filled in your API credentials, etc.
#error You need to fill in SFSettings.m with your API credentials, etc.

NSString *const kSFAPIKey = @"YOUR_SUNLIGHT_API_KEY";

#pragma mark - TestFlight

NSString *const kTFTeamToken = @"TestFlight_App_Token";

#pragma mark - Crashlytics

NSString *const kCrashlyticsApiKey = @"Crashlytics_API_Key";

#pragma mark - Google Analytics

NSString *const kGoogleAnalyticsID = @"Google_Analytics_ID";

NSString *const kGoogleAnalyticsBetaID = @"Google_Analytics_ID_or_nil";

#pragma mark - Contact Email

NSString *const kSFContactEmailAddress = @"contact_email@example.com";

NSString *const kSFContactEmailSubject = @"App Feedback";

#pragma mark - Crash Path

NSString *const kSFCrashPath = nil;

#pragma mark - Urban Airship

NSString *const kSFUrbanAirshipProductionKey = @"UA_Production_Key";
NSString *const kSFUrbanAirshipProductionSecret = @"UA_Production_Secret";

NSString *const kSFUrbanAirshipDevelopmentKey = @"UA_Development_Key";
NSString *const kSFUrbanAirshipDevelopmentSecret = @"UA_Development_Secret";

NSString *const kSFUrbanAirshipBetaDevKey = @"UA_ß_Dev_Key";
NSString *const kSFUrbanAirshipBetaDevSecret = @"UA_ß_Dev_Secret";

NSString *const kSFUrbanAirshipBetaProdKey = @"UA_ß_Prod_Key";
NSString *const kSFUrbanAirshipBetaProdSecret = @"UA_ß_Prod_Secret";

#pragma mark - Remote configuration

NSString *const kSFRemoteConfigurationURL = @"remote_configuration_url";
NSString *const kSFDefaultRemoteConfigurationId = @"remote_configuration_id";
