//
//  SFAppSettings.h
//  Congress
//
//  Created by Jeremy Carbaugh on 5/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSharedInstance.h"

FOUNDATION_EXPORT NSString *const kSFGoogleAnalyticsOptOut;

@interface SFAppSettings : NSObject <SFSharedInstance>

@property (nonatomic, readwrite,) BOOL googleAnalyticsOptOut;

+ (void)configureDefaults;
- (BOOL)boolForNotificationType:(NSString *)notificationType;
- (void)setBool:(BOOL)value forNotificationType:(NSString *)notificationType;

@end
