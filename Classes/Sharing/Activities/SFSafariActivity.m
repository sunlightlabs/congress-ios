//
//  SFSafariActivity.m
//  Congress
//
//  Created by Jeremy Carbaugh on 8/27/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFSafariActivity.h"

@implementation SFSafariActivity

@synthesize url = _url;

+ (instancetype)activityForURL:(NSURL *)url
{
    SFSafariActivity *activity = [[SFSafariActivity alloc] init];
    [activity setUrl:url];
    return activity;
}

- (NSString *)activityType { return @"safari"; }
- (NSString *)activityTitle { return @"Open in Safari"; }
- (UIImage *)activityImage { return [UIImage imageNamed:@"Safari"]; }

- (void)performActivity {
    if (_url) {
        BOOL urlOpened = [[UIApplication sharedApplication] openURL:_url];
        [self activityDidFinish:urlOpened];
    }
}

@end
