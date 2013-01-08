//
//  Bill.h
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SynchronizedObject.h"

@class Legislator;

@interface Bill : SynchronizedObject

@property (nonatomic, retain) NSString * bill_id;
@property (nonatomic, retain) NSString * bill_type;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * session;
@property (nonatomic, retain) NSNumber * abbreviated;
@property (nonatomic, retain) NSString * chamber;
@property (nonatomic, retain) NSString * short_title;
@property (nonatomic, retain) NSString * official_title;
@property (nonatomic, retain) NSString * sponsor_id;
@property (nonatomic, retain) NSDate * introduced_on;
@property (nonatomic, retain) NSDate * last_action_at;
@property (nonatomic, retain) NSDate * last_passage_vote_at;
@property (nonatomic, retain) NSDate * last_vote_at;
@property (nonatomic, retain) NSDate * house_passage_result_at;
@property (nonatomic, retain) NSDate * senate_passage_result_at;
@property (nonatomic, retain) NSDate * vetoed_at;
@property (nonatomic, retain) NSDate * house_override_result_at;
@property (nonatomic, retain) NSDate * senate_override_result_at;
@property (nonatomic, retain) NSDate * senate_cloture_result_at;
@property (nonatomic, retain) NSDate * awaiting_signature_since;
@property (nonatomic, retain) NSDate * enacted_at;
@property (nonatomic, retain) NSString * house_passage_result;
@property (nonatomic, retain) NSString * senate_passage_result;
@property (nonatomic, retain) NSString * house_override_result;
@property (nonatomic, retain) NSString * senate_override_result;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) Legislator *sponsor;

@end
