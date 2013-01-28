//
//  SFLegislator.m
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislator.h"


@implementation SFLegislator

static NSMutableDictionary *_collection = nil;

#pragma mark - MTLModel Transformers

+ (NSDictionary *)externalRepresentationKeyPathsByPropertyKey {
    return [super.externalRepresentationKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
            @"bioguideId": @"bioguide_id",
            @"crpId": @"crp_id",
            @"congressOffice": @"congress_office",
            @"firstName": @"first_name",
            @"govtrackId": @"govtrack_id",
            @"inOffice": @"in_office",
            @"lastName": @"last_name",
            @"middleName": @"middle_name",
            @"nameSuffix": @"name_suffix",
            @"stateAbbreviation": @"state_abbr",
            @"stateName": @"state_name",
            @"twitterId": @"twitter_id",
            @"youtubeURL": @"youtube_url",
            @"websiteURL": @"website",
            @"contactFormURL": @"contact_form",
        }];
}

+(NSValueTransformer *)websiteURLTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+(NSValueTransformer *)youtubeURLTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+(NSValueTransformer *)contactFormURLTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+(NSValueTransformer *)inOfficeTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}


#pragma mark - Instance methods

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

#pragma mark - SynchronizedObject protocol methods

+(NSString *)__remoteIdentifierKey
{
    return @"bioguideId";
}

+(NSMutableDictionary *)collection;
{
    if (_collection == nil) {
        _collection = [[NSMutableDictionary alloc] init];
    }
    return _collection;
}

@end
