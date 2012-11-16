//
//  SFLegislator.m
//  Congress
//
//  Created by Daniel Cloud on 11/16/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFLegislator.h"

@implementation SFLegislator

@synthesize bioguide_id, govtrack_id;
@synthesize first_name, middle_name, last_name, name_suffix, nickname;
@synthesize title, party, state, district, chamber;
@synthesize gender, congress_office, website, phone, twitter_id, youtube_url;
@synthesize in_office;

+(id)initWithDictionary:(NSDictionary *)dictionary
{
    if (!dictionary) {
        return nil;
    }
    SFLegislator *_object = [[SFLegislator alloc] init];
    
    _object.bioguide_id = (NSString *)[dictionary valueForKeyPath:@"bioguide_id"];
    _object.govtrack_id = (NSString *)[dictionary valueForKeyPath:@"govtrack_id"];
    
    _object.first_name = (NSString *)[dictionary valueForKeyPath:@"firstname"];
    _object.middle_name = (NSString *)[dictionary valueForKeyPath:@"middlename"];
    _object.last_name = (NSString *)[dictionary valueForKeyPath:@"lastname"];
    _object.name_suffix = (NSString *)[dictionary valueForKeyPath:@"name_suffix"];
    _object.nickname = (NSString *)[dictionary valueForKeyPath:@"nickname"];
    
    _object.title = [dictionary valueForKeyPath:@"title"];
    _object.party = [dictionary valueForKeyPath:@"party"];
    _object.state = [dictionary valueForKeyPath:@"state"];
    _object.district = [dictionary valueForKeyPath:@"district"];
    _object.chamber = [dictionary valueForKeyPath:@"chamber"];
    
    return _object;
}

-(NSString *)name {
    return [NSString stringWithFormat:@"%@ %@", self.first_name, self.last_name];
}

@end
