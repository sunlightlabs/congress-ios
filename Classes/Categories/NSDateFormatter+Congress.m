//
//  NSDateFormatter+Congress.m
//  Congress
//
//  Created by Daniel Cloud on 1/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "NSDateFormatter+Congress.h"

@implementation NSDateFormatter (Congress)

+ (NSDateFormatter *)ISO8601DateTimeFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    return dateFormatter;
}

+ (NSDateFormatter *)ISO8601DateOnlyFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return dateFormatter;
}

+ (NSDateFormatter *)mediumDateShortTimeFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    return dateFormatter;
}

+ (NSDateFormatter *)shortDateMediumTimeFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    return dateFormatter;
}

@end
