//
//  SFDateFormatterUtil.m
//  Congress
//
//  Created by Daniel Cloud on 4/17/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFDateFormatterUtil.h"

@implementation SFDateFormatterUtil

+ (ISO8601DateFormatter *)isoDateFormatter {
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    ISO8601DateFormatter *formatter = [dictionary objectForKey:@"ISO8601DateFormatter"];
    if (!formatter) {
        formatter = [[ISO8601DateFormatter alloc] init];
        [formatter setDefaultTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [dictionary setObject:formatter forKey:@"ISO8601DateFormatter"];
    }
    return formatter;
}

+ (ISO8601DateFormatter *)isoDateTimeFormatter {
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    ISO8601DateFormatter *formatter = [dictionary objectForKey:@"ISO8601DateTimeFormatter"];
    if (!formatter) {
        formatter = [[ISO8601DateFormatter alloc] init];
        [formatter setDefaultTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [formatter setIncludeTime:YES];
        [dictionary setObject:formatter forKey:@"ISO8601DateTimeFormatter"];
    }
    return formatter;
}

+ (NSDateFormatter *)mediumDateShortTimeFormatter {
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [dictionary objectForKey:@"MediumDateShortTimeFormatter"];
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dictionary setObject:dateFormatter forKey:@"MediumDateShortTimeFormatter"];
    }
    return dateFormatter;
}

+ (NSDateFormatter *)mediumDateNoTimeFormatter {
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [dictionary objectForKey:@"MediumDateNoTimeFormatter"];
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dictionary setObject:dateFormatter forKey:@"MediumDateNoTimeFormatter"];
    }
    return dateFormatter;
}

+ (NSDateFormatter *)longDateNoTimeFormatter {
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [dictionary objectForKey:@"LongDateNoTimeFormatter"];
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dictionary setObject:dateFormatter forKey:@"LongDateNoTimeFormatter"];
    }
    return dateFormatter;
}

+ (NSDateFormatter *)shortDateMediumTimeFormatter {
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [dictionary objectForKey:@"ShortDateMediumTimeFormatter"];
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dictionary setObject:dateFormatter forKey:@"ShortDateMediumTimeFormatter"];
    }
    return dateFormatter;
}

+ (NSDateFormatter *)shortDateNoTimeFormatter {
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [dictionary objectForKey:@"ShortDateNoTimeFormatter"];
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dictionary setObject:dateFormatter forKey:@"ShortDateNoTimeFormatter"];
    }
    return dateFormatter;
}

+ (NSDateFormatter *)shortHumanDateFormatter {
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [dictionary objectForKey:@"ShortHumanDateFormatter"];
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM. dd, ''yy"];
        [dictionary setObject:dateFormatter forKey:@"ShortHumanDateFormatter"];
    }
    return dateFormatter;
}

@end
