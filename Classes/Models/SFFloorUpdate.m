//
//  SFFloorUpdate.m
//  Congress
//
//  Created by Daniel Cloud on 7/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFFloorUpdate.h"
#import "SFDateFormatterUtil.h"

@implementation SFFloorUpdate

#pragma mark - MTLModel Versioning

+ (NSUInteger)modelVersion {
    return 1;
}

#pragma mark - MTLModel Transformers

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
                 @"legislativeDay": @"legislative_day",
                 @"billIDs": @"bill_ids",
                 @"rollIDs": @"roll_ids",
                 @"legislatorIDs": @"legislator_ids",
             };
}

+ (NSValueTransformer *)legislativeDayJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [[SFDateFormatterUtil ISO8601DateOnlyFormatter] dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [[SFDateFormatterUtil ISO8601DateTimeFormatter] stringFromDate:date];
    }];
}

+ (NSValueTransformer *)timestampJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [[SFDateFormatterUtil ISO8601DateTimeFormatter] dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [[SFDateFormatterUtil ISO8601DateTimeFormatter] stringFromDate:date];
    }];
}

#pragma mark - SFSynchronizedObject methods

- (NSDate *)dateSortValue
{
    return [self timestamp];
}

@end
