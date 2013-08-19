//
//  SFAppSettings.m
//  Congress
//
//  Created by Jeremy Carbaugh on 5/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFAppSettings.h"

NSString *const kSFGoogleAnalyticsOptOut = @"googleAnalyticsOptOut";

@implementation SFAppSettings

+(id)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[SFAppSettings alloc] init];
    });
}

+ (void)configureDefaults
{
    NSDictionary *appDefaults = @{
            kSFGoogleAnalyticsOptOut: @NO,
        };
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
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

@end
