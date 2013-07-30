//
//  SFCommittee.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/19/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommittee.h"

@implementation SFCommittee

static NSMutableArray *_collection = nil;

#pragma mark - MTLModel Versioning

+ (NSUInteger)modelVersion {
    return 1;
}

#pragma mark - MTLModel Transformers

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"committeeId": @"committee_id",
             @"isSubcommittee": @"subcommittee",
             @"parentCommittee": @"parent_committee",
            };
}

+ (NSValueTransformer *)isSubcommitteeJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)membersJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id obj) {
        NSMutableArray *members = [[NSMutableArray alloc] init];
        for (id item in obj) {
            SFCommitteeMember *member = [[SFCommitteeMember alloc] init];
            [member setSide:[item valueForKey:@"side"]];
            [member setRank:[[item valueForKey:@"rank"] integerValue]];
            [member setTitle:[item valueForKey:@"title"]];
            
            SFLegislator *legislator = [SFLegislator existingObjectWithRemoteID:[item valueForKeyPath:@"legislator.bioguide_id"]];
            if (legislator == nil) {
                legislator = [SFLegislator objectWithJSONDictionary:[item valueForKey:@"legislator"]];
            }
            [member setLegislator:legislator];
            
            [members addObject:member];
        }
        return members;
    }];
}

+ (NSValueTransformer *)parentCommitteeJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id obj) {
        NSString *committeeId = [obj valueForKey:@"committee_id"];
        SFCommittee *parentCommittee = [SFCommittee existingObjectWithRemoteID:committeeId];
        if (parentCommittee == nil) {
            parentCommittee = [SFCommittee objectWithJSONDictionary:obj];
        }
        return parentCommittee;
    }];
}

#pragma mark - SynchronizedObject protocol methods

+ (NSString *)__remoteIdentifierKey
{
    return @"committeeId";
}

+ (NSMutableArray *)collection;
{
    if (_collection == nil) {
        _collection = [NSMutableArray array];
    }
    return _collection;
}

#pragma mark - public

- (SFLegislator *)chairman
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(rank == 1) AND (side == 'majority')"];
    SFCommitteeMember *chairman = (SFCommitteeMember *)[[[self members] filteredArrayUsingPredicate:predicate] firstObject];
    return chairman.legislator;
}

- (SFLegislator *)rankingMember
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(rank == 1) AND (side == 'minority')"];
    SFCommitteeMember *rankingMember = (SFCommitteeMember *)[[[self members] filteredArrayUsingPredicate:predicate] firstObject];
    return rankingMember.legislator;
}

- (NSString *)shareURL
{
    return [NSString stringWithFormat:@"http://cngr.es/c/%@", self.committeeId];
}

@end


/* SFCommitteeMember */

@implementation SFCommitteeMember

@synthesize side = _side;
@synthesize rank = _rank;
@synthesize title = _title;
@synthesize legislator = _legislator;

@end
