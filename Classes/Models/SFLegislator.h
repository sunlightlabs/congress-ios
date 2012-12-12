//
//  SFLegislator.h
//  Congress
//
//  Created by Daniel Cloud on 11/16/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFDataObject.h"

@interface SFLegislator : NSObject <SFDataObject>

@property (nonatomic, strong) NSString *bioguide_id, *govtrack_id;
@property (nonatomic, strong) NSString *first_name, *middle_name, *last_name, *name_suffix, *nickname;
@property (nonatomic, strong) NSString *title, *party, *state_abbr, *state_name, *district, *chamber;
@property (nonatomic, strong) NSString *gender, *congress_office, *website, *phone, *twitter_id, *youtube_url;
@property BOOL *in_office;

@property (readonly) NSString *name;

@end
