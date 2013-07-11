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

static NSMutableArray *_collection = nil;

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

+(NSValueTransformer *)websiteURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+(NSValueTransformer *)youtubeURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+(NSValueTransformer *)contactFormURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+(NSValueTransformer *)inOfficeJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}


#pragma mark - SFLegislator

-(NSString *)fullName {
    if (!_fullName) {
        if ([self _firstNameIsInitial]) {
            _fullName = [NSString stringWithFormat:@"%@ %@ %@", self.firstName, self.middleName, self.lastName];
        }
        else
        {
            _fullName = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
        }
        if (self.nameSuffix && ![self.nameSuffix isEqualToString:@""]) {
            _fullName = [_fullName stringByAppendingFormat:@", %@", self.nameSuffix];
        }
    }
    return _fullName;
}

-(NSString *)titledName{
    if (!_titledName) {
        _titledName = [NSString stringWithFormat:@"%@. %@", self.title, self.fullName];
    }
    return _titledName;
}

-(NSString *)titledByLastName
{
    if (!_titledByLastName) {
        if ([self _firstNameIsInitial]) {
            _titledByLastName = [NSString stringWithFormat:@"%@, %@. %@ %@", self.lastName, self.title, self.firstName, self.middleName];
        }
        else
        {
            _titledByLastName = [NSString stringWithFormat:@"%@, %@. %@", self.lastName, self.title, self.firstName];
        }
    }
    return _titledByLastName;
}

-(NSString *)partyName
{
    if (!_partyName) {
        if ([[self.party uppercaseString] isEqualToString:@"D"])
        {
            _partyName = @"Democrat";
        }
        else if ([[self.party uppercaseString] isEqualToString:@"R"])
        {
            _partyName = @"Republican";
        }
        else if ([[self.party uppercaseString] isEqualToString:@"I"])
        {
            _partyName = @"Independent";
        }
    }

    return _partyName;
}

-(NSString *)fullTitle
{
    if (!_fullTitle) {
        if ([self.title isEqualToString:@"Del"])
        {
            _fullTitle = @"Delegate";
        }
        else if ([self.title isEqualToString:@"Com"])
        {
            _fullTitle = @"Resident Commissioner";
        }
        else if ([self.title isEqualToString:@"Sen"])
        {
            _fullTitle = @"Senator";
        }
        else // "Rep"
        {
            _fullTitle = @"Representative";
        }
    }
    return _fullTitle;
}

-(NSString *)fullDescription
{
    if (!_fullDescription) {
        NSMutableString *detailText = [NSMutableString stringWithString:@""];
        if (self.party && ![self.party isEqualToString:@""]) {
            [detailText appendFormat:@"(%@) ", self.party];
        }
        [detailText appendString:self.stateName];
        if (self.district != nil) {
            if ([self.district isEqualToNumber:[NSNumber numberWithInt:0]]) {
                [detailText appendString:@" - At-large"];
            } else {
                [detailText appendFormat:@" - District %@", self.district];
            }
        }
        _fullDescription = [NSString stringWithString:detailText];
    }
    return _fullDescription;
}

-(NSURL *)shareURL
{
    if (!_shareURL) {
        _shareURL = [SFCongressURLService landingPageForLegislatorWithId:self.bioguideId];
    }
    return _shareURL;
}

-(NSURL *)facebookURL
{
    if (!self.facebookId) {
        return nil;
    }
    if (!_facebookURL) {
        _facebookURL = [NSURL URLWithFormat:@"http://facebook.com/%@", self.facebookId];
    }
    return _facebookURL;
}

-(NSURL *)twitterURL
{
    if (!self.twitterId) {
        return nil;
    }
    if (!_twitterURL) {
        _twitterURL = [NSURL URLWithFormat:@"http://twitter.com/%@", self.twitterId];
    }
    return _twitterURL;
}

-(NSURL *)youtubeURL
{
    if (!self.youtubeId) {
        return nil;
    }
    if (!_youtubeURL) {
        _youtubeURL = [NSURL URLWithFormat:@"http://youtube.com/%@", self.youtubeId];
    }
    return _youtubeURL;
}

-(NSDictionary *)socialURLs
{
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

#pragma mark - Legislator private

- (BOOL)_firstNameIsInitial
{
    NSUInteger firstNameLength = [self.firstName length];
    NSString *lastLetterFirst = [self.firstName substringFromIndex:(firstNameLength-1)];
    return (firstNameLength == 2 && [lastLetterFirst isEqualToString:@"."]);
}

#pragma mark - SynchronizedObject protocol methods

+(NSString *)__remoteIdentifierKey
{
    return @"bioguideId";
}

+(NSMutableArray *)collection;
{
    if (_collection == nil) {
        _collection = [NSMutableArray array];
    }
    return _collection;
}

@end
