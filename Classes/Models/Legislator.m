//
//  Legislator.m
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "Legislator.h"


@implementation Legislator

static NSMutableDictionary *_collection = nil;

#pragma mark - MTLModel Transformers

+(NSValueTransformer *)websiteTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+(NSValueTransformer *)youtube_urlTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+(NSValueTransformer *)contact_formTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+(NSValueTransformer *)in_officeTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}


#pragma mark - Instance methods

-(NSString *)full_name {
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", self.first_name, self.last_name];
    if (self.name_suffix && ![self.name_suffix isEqualToString:@""]) {
        fullName = [fullName stringByAppendingFormat:@", %@", self.name_suffix];
    }
    return fullName;
}

-(NSString *)titled_name{
    NSString *name_str = [NSString stringWithFormat:@"%@. %@", self.title, self.full_name];
    return name_str;

}

-(NSString *)party_name
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

-(NSString *)full_title
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
    return @"bioguide_id";
}

+(NSMutableDictionary *)collection;
{
    if (_collection == nil) {
        _collection = [[NSMutableDictionary alloc] init];
    }
    return _collection;
}

@end
