//
//  UIDevice+VersionCheck.m
//  Congress
//
//  Created by Daniel Cloud on 8/20/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "UIDevice+VersionCheck.h"

@implementation UIDevice (VersionCheck)

- (NSUInteger)systemMajorVersion {
    NSString *versionString;

    versionString = [self systemVersion];

    return (NSUInteger)[versionString doubleValue];
}

@end
