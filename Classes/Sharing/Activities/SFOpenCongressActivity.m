//
//  SFOpenCongressActivity.m
//  Congress
//
//  Created by Jeremy Carbaugh on 8/27/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFOpenCongressActivity.h"

@implementation SFOpenCongressActivity

@synthesize url = _url;

+ (instancetype)activityForBill:(SFBill *)bill
{
    SFOpenCongressActivity *activity = [[SFOpenCongressActivity alloc] init];
    [activity setUrl:[NSURL sam_URLWithFormat:@"http://www.opencongress.org/bill/%@-%@%@/show",
                      bill.identifier.session, bill.identifier.type, bill.identifier.number]];
    return activity;
}

+ (instancetype)activityForBillText:(SFBill *)bill
{
    SFOpenCongressActivity *activity = [[SFOpenCongressActivity alloc] init];
    [activity setUrl:[NSURL sam_URLWithFormat:@"http://www.opencongress.org/bill/%@-%@%@/text",
                      bill.identifier.session, bill.identifier.type, bill.identifier.number]];
    return activity;
}

+ (instancetype)activityForLegislator:(SFLegislator *)legislator
{
    SFOpenCongressActivity *activity = [[SFOpenCongressActivity alloc] init];
    [activity setUrl:[NSURL sam_URLWithFormat:@"http://www.opencongress.org/people/show/%@", legislator.govtrackId]];
    return activity;
}

- (NSString *)activityType { return @"opencongress"; }
- (NSString *)activityTitle { return @"Open on OpenCongress"; }
- (UIImage *)activityImage { return nil; }

- (void)performActivity {
    if (_url) {
        BOOL urlOpened = [[UIApplication sharedApplication] openURL:_url];
        [self activityDidFinish:urlOpened];
    }
}

@end
