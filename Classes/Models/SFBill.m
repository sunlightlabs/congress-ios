//
//  SFBill.m
//  Congress
//
//  Created by Daniel Cloud on 11/19/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFBill.h"
#import <SSToolkit/NSDictionary+SSToolkitAdditions.h>
#import <SSToolkit/NSDate+SSToolkitAdditions.h>

@implementation SFBill

+(id)initWithDictionary:(NSDictionary *)dictionary {
    if(!dictionary) {
        return nil;
    }
    
    SFBill *_object = [[SFBill alloc] init];
    _object.bill_id = (NSString *)[dictionary safeObjectForKey:@"bill_id"];
    _object.bill_type = (NSString *)[dictionary safeObjectForKey:@"bill_type"];
    _object.code = (NSString *)[dictionary safeObjectForKey:@"code"];

    _object.short_title = (NSString *)[dictionary safeObjectForKey:@"short_title"];
    _object.official_title = (NSString *)[dictionary safeObjectForKey:@"official_title"];

    _object.number = (NSUInteger)[dictionary safeObjectForKey:@"number"];
    _object.session = (NSUInteger)[dictionary safeObjectForKey:@"congress"];
    _object.chamber = (NSString *)[dictionary safeObjectForKey:@"chamber"];

    _object.introduced_on = [NSDate dateFromDateOnlyString:[dictionary safeObjectForKey:@"introduced_on"]];
    _object.last_action_at = [NSDate dateFromISO8601String:[dictionary safeObjectForKey:@"last_action_at"]];
    _object.last_vote_at = [NSDate dateFromISO8601String:[dictionary safeObjectForKey:@"last_vote_at"]];
//    _object.last_passage_vote_at = [NSDate dateFromISO8601String:[dictionary safeObjectForKey:@"last_passage_vote_at"]];
//    _object.house_passage_result_at = [NSDate dateFromISO8601String:[dictionary safeObjectForKey:@"house_passage_result_at"]];
//    _object.senate_passage_result_at = [NSDate dateFromISO8601String:[dictionary safeObjectForKey:@"senate_passage_result_at"]];

    _object.summary = (NSString *)[dictionary safeObjectForKey:@"summary"];
    
    return _object;
}

@end
