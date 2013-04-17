//
//  SFDateFormatterUtil.m
//  Congress
//
//  Created by Daniel Cloud on 4/17/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFDateFormatterUtil.h"

@implementation SFDateFormatterUtil

+ (NSDateFormatter *)ISO8601DateTimeFormatter
{
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [dictionary objectForKey:@"ISO8601DateTimeFormatter"];
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
        dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        [dictionary setObject:dateFormatter forKey:@"ISO8601DateTimeFormatter"];
    }
    return dateFormatter;
}

+ (NSDateFormatter *)ISO8601DateOnlyFormatter
{
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [dictionary objectForKey:@"ISO8601DateOnlyFormatter"];
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        [dictionary setObject:dateFormatter forKey:@"ISO8601DateOnlyFormatter"];
    }
    return dateFormatter;
}

+ (NSDateFormatter *)mediumDateShortTimeFormatter
{
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [dictionary objectForKey:@"MediumDateShortTimeFormatter"];
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dictionary setObject:dateFormatter forKey:@"MediumDateShortTimeFormatter"];
    }
    return dateFormatter;
}

+ (NSDateFormatter *)mediumDateNoTimeFormatter
{
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [dictionary objectForKey:@"MediumDateNoTimeFormatter"];
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dictionary setObject:dateFormatter forKey:@"MediumDateNoTimeFormatter"];
    }
    return dateFormatter;
}

+ (NSDateFormatter *)shortDateMediumTimeFormatter
{
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [dictionary objectForKey:@"ShortDateMediumTimeFormatter"];
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dictionary setObject:dateFormatter forKey:@"ShortDateMediumTimeFormatter"];
    }
    return dateFormatter;
}

+ (NSDateFormatter *)shortDateNoTimeFormatter
{
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [dictionary objectForKey:@"ShortDateNoTimeFormatter"];
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dictionary setObject:dateFormatter forKey:@"ShortDateNoTimeFormatter"];
    }
    return dateFormatter;
}

+ (NSDateFormatter *)shortHumanDateFormatter
{
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [dictionary objectForKey:@"ShortHumanDateFormatter"];
    if (!dateFormatter)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM. dd, ''yy"];
        [dictionary setObject:dateFormatter forKey:@"ShortHumanDateFormatter"];
    }
    return dateFormatter;
}

@end
