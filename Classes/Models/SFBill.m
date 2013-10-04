//
//  SFBill.m
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBill.h"
#import "SFBillAction.h"
#import "SFLegislator.h"
#import "SFCongressURLService.h"
#import <ISO8601DateFormatter.h>
#import "SFBillIdentifierTransformer.h"
#import "SFBillTypeTransformer.h"
#import "SFBillIdTransformer.h"

@implementation SFBill
{
    SFBillIdentifier *_identifier;
    NSString *_displayBillType;
    NSString *_displayName;
}

static NSMutableArray *_collection = nil;
static ISO8601DateFormatter *lastActionDateFormatter = nil;
static ISO8601DateFormatter *lastVoteAtDateFormatter = nil;
static ISO8601DateFormatter *introducedOnDateFormatter = nil;


@synthesize lastActionAtIsDateTime = _lastActionAtIsDateTime;

#pragma mark - initWithDictionary

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    NSString *lastActionAtRaw = [dictionaryValue valueForKeyPath:@"last_action_at"];
    _lastActionAtIsDateTime = ([lastActionAtRaw length] == 10) ? NO :YES;
    return self;
}

#pragma mark - MTLModel Versioning

+ (NSUInteger)modelVersion {
    return 3;
}

#pragma mark - MTLModel Transformers

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
            @"billId": @"bill_id",
            @"billType": @"bill_type",
            @"shortTitle": @"short_title",
            @"officialTitle": @"official_title",
            @"shortSummary": @"summary_short",
            @"sponsorId": @"sponsor_id",
            @"cosponsorIds": @"cosponsor_ids",
            @"introducedOn": @"introduced_on",
            @"lastAction": @"last_action",
            @"lastActionAt": @"last_action_at",
            @"lastPassageVoteAt": @"last_passage_vote_at",
            @"lastVoteAt": @"last_vote_at",
            @"lastVersion": @"last_version",
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
    };
}

+ (NSValueTransformer *)officialTitleJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSString *str) {
        NSArray *stringComponents = [str componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        return [stringComponents componentsJoinedByString:@" "];
    }];
}

+ (NSValueTransformer *)shortTitleJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSString *str) {
        NSArray *stringComponents = [str componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        return [stringComponents componentsJoinedByString:@" "];
    }];
}

+ (NSValueTransformer *)lastActionAtJSONTransformer {
    if (lastActionDateFormatter == nil) {
        lastActionDateFormatter = [ISO8601DateFormatter new];
        [lastActionDateFormatter setIncludeTime:YES];
    }
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        id value = (str != nil) ? [introducedOnDateFormatter dateFromString:str] : nil;
        return value;
    } reverseBlock:^(NSDate *date) {
        return [lastActionDateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)lastVoteAtJSONTransformer {
    if (lastVoteAtDateFormatter == nil) {
        lastVoteAtDateFormatter = [ISO8601DateFormatter new];
        [lastVoteAtDateFormatter setIncludeTime:YES];
    }
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        id value = (str != nil) ? [lastVoteAtDateFormatter dateFromString:str] : nil;
        return value;
    } reverseBlock:^(NSDate *date) {
        return [lastVoteAtDateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)introducedOnJSONTransformer {
    if (introducedOnDateFormatter == nil) {
        introducedOnDateFormatter = [ISO8601DateFormatter new];
    }
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        id value = (str != nil) ? [introducedOnDateFormatter dateFromString:str] : nil;
        return value;
    } reverseBlock:^(NSDate *date) {
        return [introducedOnDateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)actionsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SFBillAction class]];
}

+ (NSValueTransformer *)lastActionJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[SFBillAction class]];
}


+ (NSValueTransformer *)cosponsorIdsJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithBlock:^id(id idArr) {
        return idArr;
    }];
}

+ (NSValueTransformer *)sponsorJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[SFLegislator class]];
}

+ (NSValueTransformer *)lastVersionJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithBlock:^id(id obj){
        NSDictionary *version = @{@"urls": [[NSMutableDictionary alloc] init]};
        for (NSString *key in @[@"html", @"pdf", @"xml"]) {
            NSString *value = [obj valueForKeyPath:[NSString stringWithFormat:@"urls.%@", key]];
            if (value) {
                [version[@"urls"] setObject:value forKey:key];
            }
        }
        return version;
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

-(SFBillIdentifier *)identifier
{
    if (!_identifier) {
        _identifier = [[NSValueTransformer valueTransformerForName:SFBillIdentifierTransformerName] transformedValue:self.billId];
    }
    return _identifier;
}

-(NSString *)displayBillType
{
    if (!_displayBillType) {
        _displayBillType = [[NSValueTransformer valueTransformerForName:SFBillTypeTransformerName] transformedValue:self.billType];
    }
    return _displayBillType;
}

-(NSString *)displayName
{
    if (!_displayName) {
        _displayName = [[NSValueTransformer valueTransformerForName:SFBillIdTransformerName] transformedValue:self.billId];
    }
    return _displayName;
}

-(NSArray *)actionsAndVotes
{
    NSMutableArray *combinedObjects = [NSMutableArray array];
    [combinedObjects addObjectsFromArray:self.actions];
    [combinedObjects addObjectsFromArray:self.rollCallVotes];
    [combinedObjects sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Class billActionClass = [SFBillAction class];
        NSDate *obj1Date = [obj1 isKindOfClass:billActionClass] ? [obj1 valueForKey:@"actedAt"] :  [obj1 valueForKey:@"votedAt"];
        NSDate *obj2Date = [obj2 isKindOfClass:billActionClass] ? [obj2 valueForKey:@"actedAt"] :  [obj2 valueForKey:@"votedAt"];
        NSTimeInterval dateDifference = [obj1Date timeIntervalSinceDate:obj2Date];
        if (dateDifference < 0) {
            return NSOrderedDescending;
        }
        else if (dateDifference > 0) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    return combinedObjects;
}

-(NSURL *)shareURL
{
    return [SFCongressURLService landingPageforBillWithId:self.billId];
}

-(NSURL *)govTrackURL
{
    return [NSURL URLWithFormat:@"http://www.govtrack.us/congress/bills/%@/%@%@", self.identifier.session, self.identifier.type, self.identifier.number];
}

-(NSURL *)govTrackFullTextURL
{
    return [NSURL URLWithFormat:@"http://www.govtrack.us/congress/bills/%@/%@%@/text", self.identifier.session, self.identifier.type, self.identifier.number];
}

-(NSURL *)openCongressURL
{
    NSString *type = [_identifier.type isEqualToString:@"hr"] ? @"h" : self.identifier.type;
    return [NSURL URLWithFormat:@"http://www.opencongress.org/bill/%@-%@%@", self.identifier.session, type, self.identifier.number];
}

-(NSURL *)openCongressFullTextURL
{
    NSString *type = [_identifier.type isEqualToString:@"hr"] ? @"h" : self.identifier.type;
    return [NSURL URLWithFormat:@"http://www.opencongress.org/bill/%@-%@%@/text", self.identifier.session, type, self.identifier.number];
}

-(NSURL *)congressGovURL
{
    return [NSURL URLWithFormat:@"http://beta.congress.gov/bill/%@th-congress/%@-bill/%@", self.identifier.session, self.chamber, self.identifier.number];
}

-(NSURL *)congressGovFullTextURL
{
    return [NSURL URLWithFormat:@"http://beta.congress.gov/bill/%@th-congress/%@-bill/%@/text", self.identifier.session, self.chamber, self.identifier.number];
}

+ (NSString *)normalizeToCode:(NSString *)inputText
{
    static NSCharacterSet *nonAlphaChars = nil;
    if (!nonAlphaChars) {
        nonAlphaChars = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    }
    NSMutableArray *stringComponents = [[[inputText lowercaseString] componentsSeparatedByCharactersInSet:nonAlphaChars] mutableCopy];
    if ([stringComponents[0] isEqualToString:@"house"]) {
        stringComponents[0] = @"h";
    }
    else if ([stringComponents[0] isEqualToString:@"senate"]) {
        stringComponents[0] = @"s";
    }
    NSMutableString *alphaString = [[stringComponents componentsJoinedByString:@""] mutableCopy];
    [alphaString replaceOccurrencesOfString:@"joint" withString:@"j" options:0 range:NSMakeRange(0, [alphaString length])];
    [alphaString replaceOccurrencesOfString:@"cres" withString:@"conres" options:0 range:NSMakeRange(0, [alphaString length])];
    return alphaString;
}

+ (NSTextCheckingResult *)billCodeCheckingResult:(NSString *)searchText
{
    static NSRegularExpression *regex = nil;
    if (!regex) {
        regex = [NSRegularExpression regularExpressionWithPattern:@"^(hr|hres|hjres|hconres|s|sres|sjres|sconres)(\\d+)$" options:0 error:nil];
    }
    NSTextCheckingResult *result = [regex firstMatchInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, [searchText length])];
    return result;
}

@end
