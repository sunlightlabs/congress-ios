//
//  SFBillAction.m
//  Congress
//
//  Created by Daniel Cloud on 1/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillAction.h"

@implementation SFBillAction

static NSMutableArray *_collection = nil;

@synthesize actedAtIsDateTime = _actedAtIsDateTime;

#pragma mark - initWithExternalRepresentation

- (instancetype)initWithExternalRepresentation:(NSDictionary *)externalRepresentation
{
    self = [super initWithExternalRepresentation:externalRepresentation];
    NSString *actedAtRaw = [externalRepresentation valueForKeyPath:@"acted_at"];
    _actedAtIsDateTime = ([actedAtRaw length] == 10) ? NO : YES;
    return self;
}

#pragma mark - MTLModel Versioning

+ (NSUInteger)modelVersion {
    return 1;
}

#pragma mark - MTLModel Transformers

+ (NSDictionary *)externalRepresentationKeyPathsByPropertyKey {
    return [super.externalRepresentationKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
            @"rollId": @"roll_id",
            @"actedAt": @"acted_at",
            @"voteType": @"vote_type",
    }];
}

+ (NSValueTransformer *)actedAtTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        if ([str length] == 10) {
            return [[NSDateFormatter ISO8601DateOnlyFormatter] dateFromString:str];
        }
        return [[NSDateFormatter ISO8601DateTimeFormatter] dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [[NSDateFormatter ISO8601DateTimeFormatter] stringFromDate:date];
    }];
}

#pragma mark - SynchronizedObject protocol methods

+(NSString *)__remoteIdentifierKey
{
    return @"rollId";
}

+(NSMutableArray *)collection;
{
    if (_collection == nil) {
        _collection = [NSMutableArray array];
    }
    return _collection;
}

@end
