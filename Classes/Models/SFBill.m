//
//  SFBill.m
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBill.h"
#import "SFBillAction.h"

static MTLValueTransformerBlock unlocalizedStringBlock = ^(NSString *str) {
    return [NSDate dateFromUnlocalizedDateString:str];
};

@implementation SFBill

static NSMutableArray *_collection = nil;

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
            @"lastActionAtIsDateTime": @"last_action_at",
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

+ (NSValueTransformer *)lastActionAtTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        if ([str length] == 10) {
            return [[NSDateFormatter ISO8601DateOnlyFormatter] dateFromString:str];
        }
        return [[NSDateFormatter ISO8601DateTimeFormatter] dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [[NSDateFormatter ISO8601DateTimeFormatter] stringFromDate:date];
    }];
}

+ (NSValueTransformer *)lastActionAtIsDateTimeTransformer
{
    return [MTLValueTransformer transformerWithBlock:^id(NSString *str) {
        if ([str length] == 10) {
            return @NO;
        }
        return @YES;
    }];
}

+ (NSValueTransformer *)lastVoteAtTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:unlocalizedStringBlock reverseBlock:^(NSDate *date) {
        return [[NSDateFormatter ISO8601DateTimeFormatter] stringFromDate:date];
    }];
}

+ (NSValueTransformer *)introducedOnTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [[NSDateFormatter ISO8601DateOnlyFormatter] dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [[NSDateFormatter ISO8601DateOnlyFormatter] stringFromDate:date];
    }];
}

+ (NSValueTransformer *)actionsTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSArray *pArray) {
        NSMutableArray *actions = [NSMutableArray arrayWithCapacity:[pArray count]];
        for (id object in pArray) {
            if ([object isKindOfClass:[SFBillAction class]]) {
                // When objects get rehydrated, they don't need conversion from external rep.
                [actions addObject:(SFBillAction *)object];
                continue;
            }
            [actions addObject:[SFBillAction objectWithExternalRepresentation:(NSDictionary *)object]];
        }
        return [NSArray arrayWithArray:actions];
    } reverseBlock:^(NSArray *pArray) {
        NSMutableArray *externalActions = [NSMutableArray arrayWithCapacity:[pArray count]];
        for (SFBillAction *object in pArray) {
            [externalActions addObject:object.externalRepresentation];
        }
        return [NSArray arrayWithArray:externalActions];
    }];
}

#pragma mark - SynchronizedObject protocol methods

+(NSString *)__remoteIdentifierKey
{
    return @"billId";
}

+(NSMutableArray *)collection;
{
    if (_collection == nil) {
        _collection = [NSMutableArray array];
    }
    return _collection;
}

#pragma mark - SFBill

-(NSString *)displayName
{
    return [NSString stringWithFormat:@"%@ %@", [self.billType uppercaseString], self.number];
}

@end
