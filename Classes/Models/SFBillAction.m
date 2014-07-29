//
//  SFBillAction.m
//  Congress
//
//  Created by Daniel Cloud on 1/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillAction.h"
#import "SFDateFormatterUtil.h"

@implementation SFBillAction

@synthesize actedAtIsDateTime = _actedAtIsDateTime;

#pragma mark - initWithDictionary

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    NSString *actedAtRaw = [dictionaryValue valueForKeyPath:@"acted_at"];
    _actedAtIsDateTime = ([actedAtRaw length] == 10) ? NO : YES;
    return self;
}

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
               @"actedAt": @"acted_at",
               @"voteType": @"vote_type",
    };
}

+ (NSValueTransformer *)actedAtJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock: ^(NSString *str) {
        id value = (str != nil) ? [[SFDateFormatterUtil isoDateTimeFormatter] dateFromString:str] : nil;
        return value;
    } reverseBlock: ^(NSDate *date) {
        return [[SFDateFormatterUtil isoDateTimeFormatter] stringFromDate:date];
    }];
}

#pragma mark - MTLModel (NSCoding)

+ (NSDictionary *)encodingBehaviorsByPropertyKey {
    NSDictionary *excludedProperties = @{
        @"actedAtIsDateTime": @(MTLModelEncodingBehaviorExcluded),
    };
    NSDictionary *encodingBehaviors = [[super encodingBehaviorsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:excludedProperties];
    return encodingBehaviors;
}

#pragma mark - SynchronizedObject protocol methods

+ (NSString *)remoteResourceName {
    return nil; // SFBillAction has no resource endpoint of its own.
}

+ (NSString *)remoteIdentifierKey {
    return nil; // SFBillAction represents a few types of remote objects that don't have a single unique identifier
}

#pragma mark - SFBillAction

- (NSString *)typeDescription {
    if ([self.type caseInsensitiveCompare:@"Topresident"] == NSOrderedSame) {
        return @"To President";
    }
    return [self.type capitalizedString];
}

@end
