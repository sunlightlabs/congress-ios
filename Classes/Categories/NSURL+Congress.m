//
//  NSURL+Congress.m
//  Congress
//
//  Created by Daniel Cloud on 4/3/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "NSURL+Congress.h"

@implementation NSURL (Congress)

static NSDictionary * _appSchemes;

+ (NSString *)schemeForAppName:(NSString *)appName {
    if (!_appSchemes) {
        _appSchemes = @{ @"twitter": @"twitter",
                         @"facebook": @"fb",
//                         @"youtube": @"youtube"
        };
    }

    NSString *scheme = [_appSchemes valueForKey:appName];
    return scheme;
}

+ (NSURL *)facebookURLForUser:(NSString *)userId {
    NSString *scheme = [[self class] schemeForAppName:@"facebook"];
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@://profile/%@", scheme, userId]];
}

+ (NSURL *)twitterURLForUser:(NSString *)userName {
    NSString *scheme = [[self class] schemeForAppName:@"twitter"];
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@://user?screen_name=%@", scheme, userName]];
}

- (NSURL *)URLByReplacingScheme:(NSString *)scheme {
    NSString *host = [self host];
    NSString *path = [self path];


    return [[NSURL alloc] initWithScheme:scheme host:host path:path];
}

@end
