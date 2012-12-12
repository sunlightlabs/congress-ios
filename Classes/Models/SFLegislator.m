//
//  SFLegislator.m
//  Congress
//
//  Created by Daniel Cloud on 11/16/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFLegislator.h"
#import <SSToolkit/NSDictionary+SSToolkitAdditions.h>

@implementation SFLegislator

@synthesize bioguide_id, govtrack_id;
@synthesize first_name, middle_name, last_name, name_suffix, nickname;
@synthesize title, party, state_abbr, state_name, district, chamber;
@synthesize gender, congress_office, website, phone, twitter_id, youtube_url;
@synthesize in_office;

+(id)initWithDictionary:(NSDictionary *)dictionary
{
    if (!dictionary) {
        return nil;
    }
    SFLegislator *_object = [[SFLegislator alloc] init];
    
    _object.bioguide_id = (NSString *)[dictionary safeObjectForKey:@"bioguide_id"];
    _object.govtrack_id = (NSString *)[dictionary safeObjectForKey:@"govtrack_id"];
    
    _object.first_name = (NSString *)[dictionary safeObjectForKey:@"first_name"];
    _object.middle_name = (NSString *)[dictionary safeObjectForKey:@"middle_name"];
    _object.last_name = (NSString *)[dictionary safeObjectForKey:@"last_name"];
    _object.name_suffix = (NSString *)[dictionary safeObjectForKey:@"name_suffix"];
    _object.nickname = (NSString *)[dictionary safeObjectForKey:@"nickname"];
    
    _object.title = [dictionary safeObjectForKey:@"title"];
    _object.party = [dictionary safeObjectForKey:@"party"];
    _object.state_abbr = [dictionary safeObjectForKey:@"state"];
    _object.district = [dictionary safeObjectForKey:@"district"];
    _object.chamber = [dictionary safeObjectForKey:@"chamber"];
    
    return _object;
}

-(NSString *)name {
    return [NSString stringWithFormat:@"%@ %@", self.first_name, self.last_name];
}

@end
