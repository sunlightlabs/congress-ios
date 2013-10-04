//
//  SFVote.m
//  Congress
//
//  Created by Daniel Cloud on 1/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFRollCallVote.h"
#import "SFBill.h"
#import <ISO8601DateFormatter.h>

@implementation SFRollCallVote
{
    NSOrderedSet *_orderedChoices;
    NSString *_questionShort;
    NSArray *_questionParts;
}

static NSMutableArray *_collection = nil;

static NSOrderedSet *SFDefaultVoteChoices = nil;
static NSOrderedSet *SFAlwaysPresentVoteChoices = nil;
static NSOrderedSet *SFImpeachmentVoteChoices = nil;

static ISO8601DateFormatter *votedAtDateFormatter = nil;

#pragma mark - MTLModel Versioning

+ (NSUInteger)modelVersion {
    return 2;
}

+ (NSDictionary *)dictionaryValueFromArchivedExternalRepresentation:(NSDictionary *)externalRepresentation version:(NSUInteger)fromVersion {
    NSLog(@"Updating %@ object from version %lu", NSStringFromClass([self class]), (unsigned long)fromVersion);
    switch (fromVersion) {
        case 1:
            return externalRepresentation;
            break;

        default:
            return nil;
            break;
    }
}

#pragma mark - MTLModel Transformers

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
            @"rollId": @"roll_id",
            @"votedAt": @"voted_at",
            @"voteType": @"vote_type",
            @"rollType": @"roll_type",
            @"billId": @"bill_id",
            @"voterDict": @"voter_ids"
    };
}

+ (NSValueTransformer *)votedAtJSONTransformer {
    if (votedAtDateFormatter == nil) {
        votedAtDateFormatter = [ISO8601DateFormatter new];
        [votedAtDateFormatter setIncludeTime:YES];
    }
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        id value = (str != nil) ? [votedAtDateFormatter dateFromString:str] : nil;
        return value;
    } reverseBlock:^(NSDate *date) {
        return [votedAtDateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer*)breakdownJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id obj) {
        return [NSDictionary dictionaryWithDictionary:obj];
    }];
}

#pragma mark - Class methods

+ (NSOrderedSet *)alwaysPresentVoteChoices
{
    if (!SFAlwaysPresentVoteChoices) {
        SFAlwaysPresentVoteChoices = [NSOrderedSet orderedSetWithArray:@[@"Present", @"Not Voting"]];
    }
    return SFAlwaysPresentVoteChoices;
}

+ (NSOrderedSet *)defaultVoteChoices
{
    if (!SFDefaultVoteChoices) {
        SFDefaultVoteChoices = [NSOrderedSet orderedSetWithArray:@[@"Yea", @"Nay", @"Present", @"Not Voting"]];
    }
    return SFDefaultVoteChoices;
}

+ (NSOrderedSet *)impeachmentVoteChoices
{
    if (!SFImpeachmentVoteChoices) {
        SFImpeachmentVoteChoices = [NSOrderedSet orderedSetWithArray:@[@"Guilty", @"Not Guilty"]];
    }
    return SFImpeachmentVoteChoices;
}

#pragma mark - Convenience methods

- (NSArray *)votesbyVoterId
{
    return [self.voterDict allKeys];
}

-(NSOrderedSet *)choices
{
    if (!self.totals) {
        return nil;
    }
    if (!_orderedChoices) {
        // Test against known choice sets
        NSOrderedSet *impeachmentVoteChoices = [[self class] impeachmentVoteChoices];
        NSOrderedSet *alwaysPresentVoteChoices = [[self class] alwaysPresentVoteChoices];
        NSOrderedSet *defaultVoteChoices = [[self class] defaultVoteChoices];

        NSOrderedSet *inputChoices = [NSOrderedSet orderedSetWithArray:[self.totals allKeys]];
        NSMutableOrderedSet *orderableChoices = [NSMutableOrderedSet orderedSet];

        // Check to see if inputChoices are in impeachmentVoteChoices
        if ([impeachmentVoteChoices isSubsetOfOrderedSet:inputChoices])
        {
            [orderableChoices unionOrderedSet:impeachmentVoteChoices];
            [orderableChoices unionOrderedSet:alwaysPresentVoteChoices];
        }
        else if ([inputChoices isSubsetOfOrderedSet:defaultVoteChoices])
        {
            [orderableChoices unionOrderedSet:defaultVoteChoices];
        }
        else
        {
            [orderableChoices unionOrderedSet:inputChoices];
            [orderableChoices minusOrderedSet:defaultVoteChoices];
            [orderableChoices sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [(NSString *)obj1 caseInsensitiveCompare:(NSString *)obj2];
            }];
            [orderableChoices unionOrderedSet:alwaysPresentVoteChoices];
        }
        _orderedChoices = [NSOrderedSet orderedSetWithOrderedSet:orderableChoices];
    }

    return _orderedChoices;
}

-(NSArray *)voterIdsForChoice:(NSString *)choice
{
    NSSet *chosenVoters = [self.voterDict keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        if ([choice isEqualToString:obj]) {
            return YES;
        }
        return NO;
    }];
    return [[chosenVoters allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

-(NSDictionary *)totals
{
    return [self.breakdown safeObjectForKey:@"total"];
}

- (NSString *)questionShort
{
    if(!_questionShort)
    {
        NSString *firstPart = (NSString *)[self.questionParts firstObject];
        _questionShort = [firstPart stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return _questionShort;
}

- (NSArray *)questionParts
{
    if (!_questionParts) {
        _questionParts = [self.question componentsSeparatedByString:@"--"];
    }
    return _questionParts;
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
