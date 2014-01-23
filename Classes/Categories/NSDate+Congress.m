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
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    return [gregorian components:unitFlags fromDate:self];
}

- (BOOL)isSameDay:(NSDate *)date1 otherDay:(NSDate *)date2 {
    NSCalendar *calendar = [NSCalendar currentCalendar];

    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlags fromDate:date2];

    return [comp1 day] == [comp2 day] &&
           [comp1 month] == [comp2 month] &&
           [comp1 year]  == [comp2 year];
}

@end
