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

#pragma mark - MTLModel Versioning

+ (NSUInteger)modelVersion {
    return 1;
}

#pragma mark - MTLModel Transformers

+ (NSDictionary *)externalRepresentationKeyPathsByPropertyKey {
    return [super.externalRepresentationKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
            @"billId": @"bill_id",
            @"billType": @"bill_type",
            @"shortTitle": @"short_title",
            @"officialTitle": @"official_title",
            @"sponsorId": @"sponsor_id",
            @"introducedOn": @"introduced_on",
            @"lastActionAt": @"last_action_at",
            @"lastPassageVoteAt": @"last_passage_vote_at",
            @"lastVoteAt": @"last_vote_at",
            @"housePassageResultAt": @"house_passage_result_at",
            @"senatePassageResultAt": @"senate_passage_result_at",
            @"vetoedAt": @"vetoed_at",
            @"houseOverrideResultAt": @"house_override_result_at",
            @"senateOverrideResultAt": @"senate_override_result_at",
            @"senateClotureResultAt": @"senate_cloture_result_at",
            @"awaitingSignatureSince": @"awaiting_signature_since",
            @"enactedAt": @"enacted_at",
            @"housePassageResult": @"house_passage_result",
            @"senatePassageResult": @"senate_passage_result",
            @"houseOverrideResult": @"house_override_result",
            @"senateOverrideResult": @"senate_override_result",
    }];
}

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


+ (NSValueTransformer *)lastActionAtTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:unlocalizedStringBlock reverseBlock:^(NSDate *date) {
        return [self.dateTimeFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)lastVoteAtTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:unlocalizedStringBlock reverseBlock:^(NSDate *date) {
        return [self.dateTimeFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)introducedOnTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateOnlyFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateOnlyFormatter stringFromDate:date];
    }];
}

#pragma mark - SynchronizedObject protocol methods

+(NSString *)__remoteIdentifierKey
{
    return @"billId";
}

+(NSMutableDictionary *)collection;
{
    if (_collection == nil) {
        _collection = [[NSMutableDictionary alloc] init];
    }
    return _collection;
}

@end
