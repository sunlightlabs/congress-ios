//
//  SFMapBoxSource.m
//  Congress
//
//  Created by Jeremy Carbaugh on 5/28/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFMapBoxSource.h"

@implementation SFMapBoxSource

- (id)initWithRetinaSupport
{
    NSString *mapID = ([[UIScreen mainScreen] scale] > 1.0 ? @"sunfoundation.map-3l6khrw5" : @"sunfoundation.map-f10t1goc");
    return [self initWithMapID:mapID];
}

@end
