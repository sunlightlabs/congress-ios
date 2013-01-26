//
//  SFBill.m
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBill.h"

static MTLValueTransformerBlock unlocalizedStringBlock = ^(NSString *str) {
    return [NSDate dateFromUnlocalizedDateString:str];
};

@implementation SFBill

static NSMutableDictionary *_collection = nil;

#pragma mark - MTLModel Transformers

+ (NSDateFormatter *)dateTimeFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    return dateFormatter;
}

+ (NSDateFormatter *)dateOnlyFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return dateFormatter;
}


+ (NSValueTransformer *)last_action_atTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:unlocalizedStringBlock reverseBlock:^(NSDate *date) {
        return [self.dateTimeFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)last_vote_atTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:unlocalizedStringBlock reverseBlock:^(NSDate *date) {
        return [self.dateTimeFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)introduced_onTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateOnlyFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateOnlyFormatter stringFromDate:date];
    }];
}

#pragma mark - SynchronizedObject protocol methods

+(NSString *)__remoteIdentifierKey
{
    return @"bill_id";
}

+(NSMutableDictionary *)collection;
{
    if (_collection == nil) {
        _collection = [[NSMutableDictionary alloc] init];
    }
    return _collection;
}

@end
