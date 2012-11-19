//
//  SFBill.m
//  Congress
//
//  Created by Daniel Cloud on 11/19/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFBill.h"
#import <SSToolkit/NSDate+SSToolkitAdditions.h>

@implementation SFBill

+(id)initWithDictionary:(NSDictionary *)dictionary {
    if(!dictionary) {
        return nil;
    }
    
    SFBill *_object = [[SFBill alloc] init];
    _object.bill_id = (NSString *)[dictionary valueForKeyPath:@"bill_id"];
    _object.bill_type = (NSString *)[dictionary valueForKeyPath:@"bill_type"];
    _object.code = (NSString *)[dictionary valueForKeyPath:@"code"];

    _object.short_title = (NSString *)[dictionary valueForKeyPath:@"short_title"];
    _object.official_title = (NSString *)[dictionary valueForKeyPath:@"official_title"];

    _object.number = (NSUInteger)[dictionary valueForKeyPath:@"number"];
    _object.session = (NSUInteger)[dictionary valueForKeyPath:@"session"];
    _object.chamber = (NSString *)[dictionary valueForKeyPath:@"chamber"];

    _object.introduced_at = [NSDate dateFromISO8601String:[dictionary valueForKeyPath:@"introduced_at"]];
    _object.last_action_at = [NSDate dateFromISO8601String:[dictionary valueForKeyPath:@"last_action_at"]];
    _object.last_passage_vote_at = [NSDate dateFromISO8601String:[dictionary valueForKeyPath:@"last_passage_vote_at"]];
    _object.house_passage_result_at = [NSDate dateFromISO8601String:[dictionary valueForKeyPath:@"house_passage_result_at"]];
    _object.senate_passage_result_at = [NSDate dateFromISO8601String:[dictionary valueForKeyPath:@"senate_passage_result_at"]];

    _object.summary = (NSString *)[dictionary valueForKeyPath:@"summary"];
    
    return _object;
}

@end
