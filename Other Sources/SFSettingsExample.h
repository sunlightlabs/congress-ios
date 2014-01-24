//
//  SFSettings.h
//  Congress
//
//  Created by Daniel Cloud on 11/15/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#ifndef Congress_SFSettings_h
#define Congress_SFSettings_h

#pragma mark - API

FOUNDATION_EXPORT NSString *const kSFAPIKey;

#pragma mark - TestFlight

FOUNDATION_EXPORT NSString *const kTFTeamToken;

#pragma mark - Crashlytics

FOUNDATION_EXPORT NSString *const kCrashlyticsApiKey;

#pragma mark - Google Analytics

FOUNDATION_EXPORT NSString *const kGoogleAnalyticsID;

FOUNDATION_EXPORT NSString *const kGoogleAnalyticsBetaID;

#pragma mark - Crash Path

FOUNDATION_EXPORT NSString *const kSFCrashPath;

#pragma mark - Contact Email

FOUNDATION_EXPORT NSString *const kSFContactEmailAddress;

FOUNDATION_EXPORT NSString *const kSFContactEmailSubject;

#pragma mark - Urban Airship

FOUNDATION_EXPORT NSString *const kSFUrbanAirshipProductionKey;
FOUNDATION_EXPORT NSString *const kSFUrbanAirshipProductionSecret;

FOUNDATION_EXPORT NSString *const kSFUrbanAirshipDevelopmentKey;
FOUNDATION_EXPORT NSString *const kSFUrbanAirshipDevelopmentSecret;

FOUNDATION_EXPORT NSString *const kSFUrbanAirshipBetaDevKey;
FOUNDATION_EXPORT NSString *const kSFUrbanAirshipBetaDevSecret;

FOUNDATION_EXPORT NSString *const kSFUrbanAirshipBetaProdKey;
FOUNDATION_EXPORT NSString *const kSFUrbanAirshipBetaProdSecret;

#pragma mark - Remote configuration

FOUNDATION_EXPORT NSString *const kSFRemoteConfigurationURL;
FOUNDATION_EXPORT NSString *const kSFDefaultRemoteConfigurationId;

#endif
