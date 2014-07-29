//
//  SFHearing.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/30/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFHearing.h"
#import "SFCommittee.h"
#import "SFBill.h"
#import "SFBillService.h"
#import "SFDateFormatterUtil.h"

@implementation SFHearing

#pragma mark - MTLModel Versioning

+ (NSUInteger)modelVersion {
    return 1;
}

#pragma mark - MTLModel Transformers

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
               @"type": @"hearing_type",
               @"occursAt": @"occurs_at",
               @"session": @"congress",
               @"inDC": @"dc",
               @"parentCommittee": @"parent_committee",
               @"billIds": @"bill_ids",
               @"summary": @"description",
    };
}

+ (NSValueTransformer *)inDCJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)urlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)occursAtJSONTransformer {
    return [MTLValueTransformer transformerWithBlock: ^id (id obj) {
        return [[SFDateFormatterUtil isoDateFormatter] dateFromString:obj];
    }];
}

+ (NSValueTransformer *)committeeJSONTransformer {
    return [MTLValueTransformer transformerWithBlock: ^id (id obj) {
        SFCommittee *committee = [SFCommittee existingObjectWithRemoteID:obj];
        if (committee == nil) {
            committee = [SFCommittee objectWithJSONDictionary:obj];
        }
        return committee;
    }];
}

//+ (NSValueTransformer *)billsJSONTransformer
//{
//    return [MTLValueTransformer transformerWithBlock:^id(id obj) {
//        NSMutableArray *bills = [NSMutableArray array];
//        return bills;
//    }];
//}

#pragma mark - public

- (NSString *)fauxId {
    return [NSString stringWithFormat:@"%@%@%@", self.summary, self.url, self.occursAt];
}

- (NSArray *)bills {
    [SFBillService billsWithIds:[self billIds] completionBlock: ^(NSArray *resultsArray) {
        // huh
    }];
    return nil;
}

- (BOOL)isUpcoming {
    return [self.occursAt compare:[NSDate date]] == NSOrderedDescending;
}

#pragma mark - SynchronizedObject protocol methods

+ (NSString *)remoteResourceName {
    return @"hearings";
}

+ (NSString *)remoteIdentifierKey {
    return @"fauxId";
}

@end
