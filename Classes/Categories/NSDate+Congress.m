//
//  NSDate+Congress.m
//  Congress
//
//  Created by Daniel Cloud on 12/11/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "NSDate+Congress.h"
#include <time.h>
#include <xlocale.h>

static NSDateFormatter *sDateOnlyFormatter = nil;

@implementation NSDate (Congress)

+ (NSDate *)dateFromDateOnlyString:(NSString *)dateOnlyString
{
    if (!dateOnlyString) {
        return nil;
    }

    const char *formatString = "%Y-%m-%d %H:%M:%S %z";
    struct tm tm = {
        .tm_sec = 0,
        .tm_min = 0,
        .tm_hour = 0,
        .tm_mday = 0,
        .tm_mon = 0,
        .tm_year = 0,
        .tm_wday = 0,
        .tm_yday = 0,
        .tm_isdst = -1,
    };
    const char *inputStr = [dateOnlyString cStringUsingEncoding:NSUTF8StringEncoding];


    (void)strptime_l(inputStr, formatString, &tm, NULL);
    NSDate *outDate = [NSDate dateWithTimeIntervalSince1970:mktime(&tm)];

    return outDate;
}

- (NSString *)stringWithMediumDateOnly
{
    if (sDateOnlyFormatter == nil) {
        sDateOnlyFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [sDateOnlyFormatter setLocale:enUSPOSIXLocale];
        [sDateOnlyFormatter setDateStyle:NSDateFormatterMediumStyle];
    }

    return [sDateOnlyFormatter stringFromDate:self];
}

@end
