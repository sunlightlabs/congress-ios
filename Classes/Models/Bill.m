//
//  Bill.m
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "Bill.h"
#import "Legislator.h"


@implementation Bill

@dynamic bill_id;
@dynamic bill_type;
@dynamic code;
@dynamic number;
@dynamic session;
@dynamic abbreviated;
@dynamic chamber;
@dynamic short_title;
@dynamic official_title;
@dynamic sponsor_id;
@dynamic introduced_on;
@dynamic last_action_at;
@dynamic last_passage_vote_at;
@dynamic last_vote_at;
@dynamic house_passage_result_at;
@dynamic senate_passage_result_at;
@dynamic vetoed_at;
@dynamic house_override_result_at;
@dynamic senate_override_result_at;
@dynamic senate_cloture_result_at;
@dynamic awaiting_signature_since;
@dynamic enacted_at;
@dynamic house_passage_result;
@dynamic senate_passage_result;
@dynamic house_override_result;
@dynamic senate_override_result;
@dynamic summary;
@dynamic sponsor;

@end
