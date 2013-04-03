//
//  NSURL+Congress.h
//  Congress
//
//  Created by Daniel Cloud on 4/3/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Congress)

+ (NSString *)schemeForAppName:(NSString *)appName;
+ (NSURL *)facebookURLForUser:(NSString *)userId;
+ (NSURL *)twitterURLForUser:(NSString *)userName;
- (NSURL *)URLByReplacingScheme:(NSString *)scheme;

@end
