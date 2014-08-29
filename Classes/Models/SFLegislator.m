//
//  SFLegislator.m
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislator.h"
#import "SFCongressURLService.h"

@implementation SFLegislator

@synthesize fullName = _fullName;
@synthesize titledName = _titledName;
@synthesize titledByLastName = _titledByLastName;
@synthesize partyName = _partyName;
@synthesize fullTitle = _fullTitle;
@synthesize fullDescription = _fullDescription;
@synthesize facebookURL = _facebookURL;
@synthesize twitterURL = _twitterURL;
@synthesize youtubeURL = _youtubeURL;
@synthesize socialURLs = _socialURLs;
@synthesize shareURL = _shareURL;

#pragma mark - MTLModel Versioning

+ (NSUInteger)modelVersion {
    return 2;
}

#pragma mark - MTLModel Transformers

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
               @"bioguideId": @"bioguide_id",
               @"crpId": @"crp_id",
               @"congressOffice": @"office",
               @"firstName": @"first_name",
               @"govtrackId": @"govtrack_id",
               @"inOffice": @"in_office",
               @"lastName": @"last_name",
               @"middleName": @"middle_name",
               @"nameSuffix": @"name_suffix",
               @"stateAbbreviation": @"state",
               @"stateName": @"state_name",
               @"facebookId": @"facebook_id",
               @"twitterId": @"twitter_id",
               @"youtubeId": @"youtube_id",
               @"websiteURL": @"website",
               @"contactFormURL": @"contact_form",
    };
}

+ (NSValueTransformer *)websiteURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)youtubeURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)contactFormURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)inOfficeJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

#pragma mark - MTLModel (NSCoding)

+ (NSDictionary *)encodingBehaviorsByPropertyKey {
    NSDictionary *excludedProperties = @{
        @"fullName": @(MTLModelEncodingBehaviorExcluded),
        @"titledName": @(MTLModelEncodingBehaviorExcluded),
        @"titledByLastName": @(MTLModelEncodingBehaviorExcluded),
        @"partyName": @(MTLModelEncodingBehaviorExcluded),
        @"fullTitle": @(MTLModelEncodingBehaviorExcluded),
        @"fullDescription": @(MTLModelEncodingBehaviorExcluded),
        @"facebookURL": @(MTLModelEncodingBehaviorExcluded),
        @"twitterURL": @(MTLModelEncodingBehaviorExcluded),
        @"youtubeURL": @(MTLModelEncodingBehaviorExcluded),
        @"socialURLs": @(MTLModelEncodingBehaviorExcluded),
        @"shareURL": @(MTLModelEncodingBehaviorExcluded)
    };
    NSDictionary *encodingBehaviors = [[super encodingBehaviorsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:excludedProperties];
    return encodingBehaviors;
}

#pragma mark - SFLegislator

- (NSString *)fullName {
    if (!_fullName) {
        if ([self _firstNameIsInitial]) {
            _fullName = [NSString stringWithFormat:@"%@ %@ %@", self.firstName, self.middleName, self.lastName];
        }
        else {
            NSString *nickOrFirst = self.nickname ?: self.firstName;
            _fullName = [NSString stringWithFormat:@"%@ %@", nickOrFirst, self.lastName];
        }
        if (self.nameSuffix && ![self.nameSuffix isEqualToString:@""]) {
            _fullName = [_fullName stringByAppendingFormat:@", %@", self.nameSuffix];
        }
    }
    return _fullName;
}

- (NSString *)titledName {
    if (!_titledName) {
        _titledName = [NSString stringWithFormat:@"%@. %@", self.title, self.fullName];
    }
    return _titledName;
}

- (NSString *)titledByLastName {
    if (!_titledByLastName) {
        NSString *nickOrFirst = self.nickname ?: self.firstName;
        if ([self _firstNameIsInitial]) {
            _titledByLastName = [NSString stringWithFormat:@"%@, %@. %@ %@", self.lastName, self.title, nickOrFirst, self.middleName];
        }
        else {
            _titledByLastName = [NSString stringWithFormat:@"%@, %@. %@", self.lastName, self.title, nickOrFirst];
        }
    }
    return _titledByLastName;
}

- (NSString *)partyName {
    if (!_partyName) {
        if ([[self.party uppercaseString] isEqualToString:@"D"]) {
            _partyName = @"Democrat";
        }
        else if ([[self.party uppercaseString] isEqualToString:@"R"]) {
            _partyName = @"Republican";
        }
        else if ([[self.party uppercaseString] isEqualToString:@"I"]) {
            _partyName = @"Independent";
        }
    }

    return _partyName;
}

- (NSString *)fullTitle {
    if (!_fullTitle) {
        if ([self.title isEqualToString:@"Del"]) {
            _fullTitle = @"Delegate";
        }
        else if ([self.title isEqualToString:@"Com"]) {
            _fullTitle = @"Resident Commissioner";
        }
        else if ([self.title isEqualToString:@"Sen"]) {
            _fullTitle = @"Senator";
        }
        else { // "Rep"
            _fullTitle = @"Representative";
        }
    }
    return _fullTitle;
}

- (NSString *)fullDescription {
    if (!_fullDescription) {
        NSMutableString *detailText = [NSMutableString stringWithString:@""];
        if (self.party && ![self.party isEqualToString:@""]) {
            [detailText appendFormat:@"(%@) ", self.party];
        }
        if (self.stateName) {
            [detailText appendString:self.stateName];
            if (self.district) {
                if ([self.district isEqualToNumber:[NSNumber numberWithInt:0]]) {
                    [detailText appendString:@" - At-large"];
                }
                else {
                    [detailText appendFormat:@" - District %@", self.district];
                }
            }
        }
        _fullDescription = [NSString stringWithString:detailText];
    }
    return _fullDescription;
}

- (NSURL *)shareURL {
    if (!_shareURL) {
        _shareURL = [SFCongressURLService landingPageForLegislatorWithId:self.bioguideId];
    }
    return _shareURL;
}

- (NSURL *)facebookURL {
    if (!self.facebookId) {
        return nil;
    }
    if (!_facebookURL) {
        _facebookURL = [NSURL sam_URLWithFormat:@"https://facebook.com/%@", self.facebookId];
    }
    return _facebookURL;
}

- (NSURL *)twitterURL {
    if (!self.twitterId) {
        return nil;
    }
    if (!_twitterURL) {
        _twitterURL = [NSURL sam_URLWithFormat:@"https://twitter.com/%@", self.twitterId];
    }
    return _twitterURL;
}

- (NSURL *)youtubeURL {
    if (!self.youtubeId) {
        return nil;
    }
    if (!_youtubeURL) {
        _youtubeURL = [NSURL sam_URLWithFormat:@"https://youtube.com/%@", self.youtubeId];
    }
    return _youtubeURL;
}

- (NSDictionary *)socialURLs {
    if (!_socialURLs) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (self.youtubeURL) {
            [dict setObject:self.youtubeURL forKey:@"youtube"];
        }
        if (self.facebookURL) {
            [dict setObject:self.facebookURL forKey:@"facebook"];
        }
        if (self.twitterURL) {
            [dict setObject:self.twitterURL forKey:@"twitter"];
        }
        _socialURLs = [NSDictionary dictionaryWithDictionary:dict];
    }
    return _socialURLs;
}

#pragma mark - Legislator public methods

- (NSString *)openCongressEmail {
    
    NSString *emailAddr = nil;
    
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"^(?:www[.])?([-a-z0-9]+)[.](house|senate)[.]gov$"
                                                                      options:NSRegularExpressionCaseInsensitive
                                                                        error:nil];
    NSString *host = [self.websiteURL.host lowercaseString];
    
    if (host) {
        
        NSTextCheckingResult *match = [regex firstMatchInString:host
                                                        options:0
                                                          range:NSMakeRange(0, [host length])];
        if (match && [match numberOfRanges] == 3) {
            
            NSString *nameish = [host substringWithRange:[match rangeAtIndex:1]];
            NSString *chamber = [host substringWithRange:[match rangeAtIndex:2]];
            NSString *prefix = [[chamber lowercaseString] isEqualToString:@"senate"] ? @"Sen" : @"Rep";
            
            emailAddr = [NSString stringWithFormat:@"%@.%@@opencongress.org", [prefix capitalizedString], [nameish capitalizedString]];
            
        }
        
    }
    
    return emailAddr;
}

#pragma mark - Legislator private

- (BOOL)_firstNameIsInitial {
    NSUInteger firstNameLength = [self.firstName length];
    NSString *lastLetterFirst = [self.firstName substringFromIndex:(firstNameLength - 1)];
    return (firstNameLength == 2 && [lastLetterFirst isEqualToString:@"."]);
}

#pragma mark - SynchronizedObject protocol methods

+ (NSString *)remoteResourceName {
    return @"legislators";
}

+ (NSString *)remoteIdentifierKey {
    return @"bioguideId";
}

@end
