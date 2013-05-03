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
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    if (self.nameSuffix && ![self.nameSuffix isEqualToString:@""]) {
        fullName = [fullName stringByAppendingFormat:@", %@", self.nameSuffix];
    }
    return fullName;
}

-(NSString *)titledName{
    NSString *name_str = [NSString stringWithFormat:@"%@. %@", self.title, self.fullName];
    return name_str;
}

-(NSString *)titledByLastName
{
    NSString *name_str = [NSString stringWithFormat:@"%@, %@. %@", self.lastName, self.title, self.firstName];
    return name_str;
}

-(NSString *)partyName
{
    if ([[self.party uppercaseString] isEqualToString:@"D"])
    {
        return @"Democrat";
    }
    else if ([[self.party uppercaseString] isEqualToString:@"R"])
    {
        return @"Republican";
    }
    else if ([[self.party uppercaseString] isEqualToString:@"I"])
    {
        return @"Independent";
    }

    return nil;
}

-(NSString *)fullTitle
{
    if ([self.title isEqualToString:@"Del"])
    {
        return @"Delegate";
    }
    else if ([self.title isEqualToString:@"Com"])
    {
        return @"Resident Commissioner";
    }
    else if ([self.title isEqualToString:@"Sen"])
    {
        return @"Senator";
    }
    else // "Rep"
    {
        return @"Representative";
    }
}

-(NSString *)fullDescription
{
    NSString *detailText = @"";
    if (self.party && ![self.party isEqualToString:@""]) {
        detailText = [detailText stringByAppendingFormat:@"(%@) ", self.party];
    }
    detailText = [detailText stringByAppendingString:self.stateName];
    if (self.district) {
        detailText = [detailText stringByAppendingFormat:@" - District %@", self.district];
    }
    return detailText;
}

-(NSURL *)shareURL
{
    return [SFCongressURLService landingPageForLegislatorWithId:self.bioguideId];
}

-(NSURL *)facebookURL
{
    if (!self.facebookId) {
        return nil;
    }
    return [NSURL URLWithFormat:@"http://facebook.com/%@", self.facebookId];
}

-(NSURL *)twitterURL
{
    if (!self.twitterId) {
        return nil;
    }
    return [NSURL URLWithFormat:@"http://twitter.com/%@", self.twitterId];
}

-(NSURL *)youtubeURL
{
    if (!self.youtubeId) {
        return nil;
    }
    return [NSURL URLWithFormat:@"http://youtube.com/%@", self.youtubeId];
}

-(NSDictionary *)socialURLs
{
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
    return [NSDictionary dictionaryWithDictionary:dict];
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
