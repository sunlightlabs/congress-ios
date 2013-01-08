//
//  Legislator.h
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SynchronizedObject.h"


@interface Legislator : SynchronizedObject

@property (nonatomic, retain) NSString * bioguide_id;
@property (nonatomic, retain) NSString * chamber;
@property (nonatomic, retain) NSString * congress_office;
@property (nonatomic, retain) NSString * district;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSNumber * govtrack_id;
@property (nonatomic, retain) NSNumber * in_office;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * middle_name;
@property (nonatomic, retain) NSString * name_suffix;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * party;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * state_abbr;
@property (nonatomic, retain) NSString * state_name;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * twitter_id;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * youtube_url;

@property (readonly) NSString *full_name;
@property (readonly) NSString *titled_name;
@property (readonly) NSString *party_name;
@property (readonly) NSString *full_title;

@end
