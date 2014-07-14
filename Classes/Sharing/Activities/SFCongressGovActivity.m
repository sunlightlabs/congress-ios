//
//  SFCongressGovActivity.m
//  Congress
//
//  Created by Jeremy Carbaugh on 8/27/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCongressGovActivity.h"

@implementation SFCongressGovActivity

@synthesize url = _url;

+ (instancetype)activityForBill:(SFBill *)bill
{
    SFCongressGovActivity *activity = [[SFCongressGovActivity alloc] init];
    [activity setUrl:[NSURL sam_URLWithFormat:@"http://beta.congress.gov/bill/%@th-congress/%@-bill/%@",
                      bill.identifier.session, bill.chamber, bill.identifier.number]];
    return activity;
}

+ (instancetype)activityForBillText:(SFBill *)bill
{
    SFCongressGovActivity *activity = [[SFCongressGovActivity alloc] init];
    [activity setUrl:[NSURL sam_URLWithFormat:@"http://beta.congress.gov/bill/%@th-congress/%@-bill/%@/text",
                      bill.identifier.session, bill.chamber, bill.identifier.number]];
    return activity;
}

- (NSString *)activityType { return @"congressgov"; }
- (NSString *)activityTitle { return @"Open on Congress.gov"; }
- (UIImage *)activityImage { return [UIImage imageNamed:@"CongressGov"]; }

- (void)performActivity {
    if (_url) {
        BOOL urlOpened = [[UIApplication sharedApplication] openURL:_url];
        [self activityDidFinish:urlOpened];
    }
}

@end
