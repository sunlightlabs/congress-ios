//
//  SFPushConfig.m
//  Congress
//
//  Created by Daniel Cloud on 11/15/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFPushConfig.h"
#import <UAConfig.h>

@implementation SFPushConfig

+ (UAConfig *)defaultConfig {
    UAConfig *config = [UAConfig config];
    config.detectProvisioningMode = YES;

#if CONFIGURATION_Release
    config.productionAppKey = kSFUrbanAirshipProductionKey;
    config.productionAppSecret = kSFUrbanAirshipProductionSecret;
    config.detectProvisioningMode = NO;
    config.inProduction = YES;
#elif CONFIGURATION_Beta
    NSLog(@"Registering device for Beta notifications");
    config.productionAppKey = kSFUrbanAirshipBetaProdKey;
    config.productionAppSecret = kSFUrbanAirshipBetaProdSecret;
    config.developmentAppKey = kSFUrbanAirshipBetaDevKey;
    config.developmentAppSecret = kSFUrbanAirshipBetaDevSecret;
#else
    NSLog(@"Registering device for Dev notifications");
    config.productionAppKey = kSFUrbanAirshipDevelopmentKey;
    config.productionAppSecret = kSFUrbanAirshipDevelopmentSecret;
    config.developmentAppKey = kSFUrbanAirshipDevelopmentKey;
    config.developmentAppSecret = kSFUrbanAirshipDevelopmentSecret;
    // NOTE: UAirship.m has a const for the reset_keychain setting, but they don't export it.
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"com.urbanairship.reset_keychain"];
#endif

    return config;
}

@end
