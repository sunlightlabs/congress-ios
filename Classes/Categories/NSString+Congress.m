//
//  NSString+Congress.m
//  Congress
//
//  Created by Daniel Cloud on 3/19/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "NSString+Congress.h"

@implementation NSString (Congress)

+ (NSString*)ordinalFromNumber:(NSNumber *)number
{
    NSString *ending;
    NSInteger num = [number integerValue];

    int ones = num % 10;
    int tens = floor(num / 10);
    tens = tens % 10;

    if(tens == 1){
        ending = @"th";
    } else {
        switch (ones) {
            case 1:
                ending = @"st";
                break;
            case 2:
                ending = @"nd";
                break;
            case 3:
                ending = @"rd";
                break;
            default:
                ending = @"th";
                break;
        }
    }

    return [NSString stringWithFormat:@"%d%@", num, ending];
}

@end
