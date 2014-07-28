//
//  SFHearingActivityItemProvider.m
//  Congress
//
//  Created by Jeremy Carbaugh on 9/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFHearingActivityItemProvider.h"
#import "SFHearing.h"

@implementation SFHearingActivityItemProvider

- (id)item {
    SFHearing *hearing = self.placeholderItem;
    NSString *defaultText = [NSString stringWithFormat:@"%@", hearing.summary];
    return defaultText;
}

@end
