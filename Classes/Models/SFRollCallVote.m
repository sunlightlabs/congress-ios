//
//  SFVote.m
//  Congress
//
//  Created by Daniel Cloud on 1/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFRollCallVote.h"
#import "SFDateFormatterUtil.h"

@implementation SFRollCallVote
{
    NSOrderedSet *__orderedChoices;
}

static NSMutableArray *_collection = nil;

static NSOrderedSet *SFDefaultVoteChoices = nil;
static NSOrderedSet *SFAlwaysPresentVoteChoices = nil;
static NSOrderedSet *SFImpeachmentVoteChoices = nil;

#pragma mark - MTLModel Versioning

+ (NSUInteger)modelVersion {
    return 1;
}

#pragma mark - MTLModel Transformers

+ (NSDictionary *)externalRepresentationKeyPathsByPropertyKey {
    return [super.externalRepresentationKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
            @"rollId": @"roll_id",
            @"votedAt": @"voted_at",
            @"voteType": @"vote_type",
            @"rollType": @"roll_type",
            @"billId": @"bill_id",
            @"voterDict": @"voter_ids"
    }];
}

+ (NSValueTransformer *)votedAtTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [[SFDateFormatterUtil ISO8601DateTimeFormatter] dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [[SFDateFormatterUtil ISO8601DateTimeFormatter] stringFromDate:date];
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
    if (!__orderedChoices) {
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
        __orderedChoices = [NSOrderedSet orderedSetWithOrderedSet:orderableChoices];
    }

    return __orderedChoices;
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
