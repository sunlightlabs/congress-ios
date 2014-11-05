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

@implementation NSDate (Congress)

unsigned const YEAR_MONTH_DAY = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;

+ (NSDate *)dateFromDateOnlyString:(NSString *)dateOnlyString {
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

- (NSDateComponents *)dateComponents {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [gregorian components:YEAR_MONTH_DAY fromDate:self];
}

- (BOOL)isSameDay:(NSDate *)date1 otherDay:(NSDate *)date2 {
    NSDateComponents *comp1 = [date1 dateComponents];
    NSDateComponents *comp2 = [date2 dateComponents];

    return [comp1 day] == [comp2 day] &&
           [comp1 month] == [comp2 month] &&
           [comp1 year]  == [comp2 year];
}

@end
