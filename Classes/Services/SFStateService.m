//
//  SFStateService.m
//  Congress
//
//  Created by Daniel Cloud on 12/12/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFStateService.h"

@implementation SFStateService

+(id)sharedInstance {
    static SFStateService *_sharedInstance;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[SFStateService alloc] init];
    });

    return _sharedInstance;
}

- (SFStateService *)init
{
    self = [super init];

    NSURL *statesPlistURL = [[NSBundle mainBundle] URLForResource:@"US_States" withExtension:@"plist"];
    
    _states = [[NSDictionary alloc] initWithContentsOfURL:statesPlistURL];

    return self;
}

- (NSString *)getStateNameForAbbrevation:(NSString *)abbreviation
{
    return [_states objectForKey:[abbreviation uppercaseString]];
}

@end
