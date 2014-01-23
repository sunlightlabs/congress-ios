//
//  SFActivityItemProvider.m
//  Congress
//
//  Created by Jeremy Carbaugh on 8/28/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFActivityItemProvider.h"

@implementation SFActivityItemProvider

- (NSString *)facebookStringWithText:(NSString *)text {
    return [NSString stringWithFormat:@"%@ via Sunlight Foundation's Congress for iOS", text];
}

- (NSString *)twitterStringWithText:(NSString *)text {
    return [NSString stringWithFormat:@"%@ via @congress_app", text];
}

@end
