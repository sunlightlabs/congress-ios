//
//  SFCommittee.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/19/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommittee.h"

@implementation SFCommittee {
    NSString *_prefixName;
    NSString *_primaryName;
}

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

+ (NSValueTransformer *)isSubcommitteeJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)membersJSONTransformer {
    return [MTLValueTransformer transformerWithBlock: ^id (id obj) {
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
    return [MTLValueTransformer transformerWithBlock: ^id (id obj) {
        NSString *committeeId = [obj valueForKey:@"committee_id"];
        SFCommittee *parentCommittee = [SFCommittee existingObjectWithRemoteID:committeeId];
        if (parentCommittee == nil) {
            parentCommittee = [SFCommittee objectWithJSONDictionary:obj];
        }
        return parentCommittee;
    }];
}

+ (NSValueTransformer *)phoneJSONTransformer {
    return [MTLValueTransformer transformerWithBlock: ^id (id obj) {
        NSString *phone = [NSString stringWithFormat:@"%@-%@",
                           [obj substringWithRange:NSMakeRange(1, 3)],
                           [obj substringWithRange:NSMakeRange(6, 8)]];
        return phone;
    }];
}

#pragma mark - MTLModel (NSCoding)

+ (NSDictionary *)encodingBehaviorsByPropertyKey {
    NSDictionary *excludedProperties = @{
        @"prefixName": @(MTLModelEncodingBehaviorExcluded),
        @"primaryName": @(MTLModelEncodingBehaviorExcluded),
        @"chairman": @(MTLModelEncodingBehaviorExcluded),
        @"rankingMember": @(MTLModelEncodingBehaviorExcluded),
        @"shareURL": @(MTLModelEncodingBehaviorExcluded),
    };
    NSDictionary *encodingBehaviors = [[super encodingBehaviorsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:excludedProperties];
    return encodingBehaviors;
}

#pragma mark - SynchronizedObject protocol methods

+ (NSString *)remoteResourceName {
    return @"committees";
}

+ (NSString *)remoteIdentifierKey {
    return @"committeeId";
}

#pragma mark - public

- (SFLegislator *)chairman {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(rank == 1) AND (side == 'majority')"];
    SFCommitteeMember *chairman = (SFCommitteeMember *)[[[self members] filteredArrayUsingPredicate:predicate] firstObject];
    return chairman.legislator;
}

- (SFLegislator *)rankingMember {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(rank == 1) AND (side == 'minority')"];
    SFCommitteeMember *rankingMember = (SFCommitteeMember *)[[[self members] filteredArrayUsingPredicate:predicate] firstObject];
    return rankingMember.legislator;
}

- (NSString *)shareURL {
    return [NSString stringWithFormat:@"http://cngr.es/c/%@", self.committeeId];
}

- (NSString *)prefixName {
    if (_primaryName == nil) [self processName];
    return _prefixName;
}

- (NSString *)primaryName {
    if (_primaryName == nil) [self processName];
    return _primaryName;
}

#pragma mark - private

- (void)processName {
    if ([self.name isEqualToString:@"Joint Economic Committee"]) {
        _prefixName = @"Joint";
        _primaryName = @"Economic Committee";
    }
    else {
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(.* (on( the)?))?(\\s)?(.*)" options:0 error:&error];
        if (regex && !error) {
            NSTextCheckingResult *match = [regex firstMatchInString:self.name options:0 range:NSMakeRange(0, self.name.length)];
            if (match) {
                _primaryName = [self.name substringWithRange:[match rangeAtIndex:[match numberOfRanges] - 1]];
                _primaryName = [_primaryName stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                                                     withString:[[_primaryName substringWithRange:
                                                                                  NSMakeRange(0, 1)] uppercaseString]];

                NSRange prefixRange = [match rangeAtIndex:1];
                if (prefixRange.location != NSNotFound) {
                    _prefixName = [self.name substringWithRange:prefixRange];
                }
                else if (self.isSubcommittee) {
                    _prefixName = @"Subcommittee on";
                }
            }
        }
    }
}

@end


/* SFCommitteeMember */

@implementation SFCommitteeMember

@synthesize side = _side;
@synthesize rank = _rank;
@synthesize title = _title;
@synthesize legislator = _legislator;

#pragma mark - MTLModel Versioning

+ (NSUInteger)modelVersion {
    return 1;
}

@end
