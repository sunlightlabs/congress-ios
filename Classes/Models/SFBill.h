//
//  SFBill.h
//  Congress
//
//  Created by Daniel Cloud on 11/19/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFDataObject.h"

@interface SFBill : NSObject <SFDataObject>

@property (nonatomic, strong) NSString *bill_id, *bill_type, *code;
@property (assign) NSUInteger number, session;
@property (assign) BOOL abbreviated;
@property (nonatomic, strong) NSString *chamber, *short_title, *official_title;
@property (nonatomic, strong) NSDate *introduced_at, *last_action_at, *last_passage_vote_at, *last_vote_at;
@property (nonatomic, strong) NSDate *house_passage_result_at, *senate_passage_result_at;
@property (nonatomic, strong) NSDate *vetoed_at, *house_override_result_at, *senate_override_result_at;
@property (nonatomic, strong) NSDate *senate_cloture_result_at, *awaiting_signature_since, *enacted_at;
@property (nonatomic, strong) NSString *house_passage_result, *senate_passage_result, *house_override_result, *senate_override_result;
@property (assign) NSInteger cosponsors_count;
@property (nonatomic, strong) NSString *summary;

@end
