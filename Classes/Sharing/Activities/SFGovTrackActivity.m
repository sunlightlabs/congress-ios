//
//  SFGovTrackActivity.m
//  Congress
//
//  Created by Jeremy Carbaugh on 8/27/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFGovTrackActivity.h"

@implementation SFGovTrackActivity

@synthesize url = _url;

+ (id)activityForBill:(SFBill *)bill
{
    SFGovTrackActivity *activity = [[SFGovTrackActivity alloc] init];
    [activity setUrl:[NSURL URLWithFormat:@"http://www.govtrack.us/congress/bills/%@/%@%@",
                      bill.identifier.session, bill.identifier.type, bill.identifier.number]];
    return activity;
}

+ (id)activityForBillText:(SFBill *)bill
{
    SFGovTrackActivity *activity = [[SFGovTrackActivity alloc] init];
    [activity setUrl:[NSURL URLWithFormat:@"http://www.govtrack.us/congress/bills/%@/%@%@/text",
                      bill.identifier.session, bill.identifier.type, bill.identifier.number]];
    return activity;
}

+ (id)activityForCommmittee:(SFCommittee *)committee
{
    SFGovTrackActivity *activity = [[SFGovTrackActivity alloc] init];
    if (committee.isSubcommittee) {
        [activity setUrl:[NSURL URLWithFormat:@"http://www.govtrack.us/congress/committees/%@/%@",
                          [committee.committeeId substringToIndex:4],
                          [committee.committeeId substringFromIndex:4]]];
    } else {
        [activity setUrl:[NSURL URLWithFormat:@"http://www.govtrack.us/congress/committees/%@", committee.committeeId]];
    }
    return activity;
}

+ (id)activityForLegislator:(SFLegislator *)legislator
{
    SFGovTrackActivity *activity = [[SFGovTrackActivity alloc] init];
    [activity setUrl:[NSURL URLWithFormat:@"http://www.govtrack.us/congress/members/cngres/%@", legislator.govtrackId]];
    return activity;
}

- (NSString *)activityType { return @"govtrack"; }
- (NSString *)activityTitle { return @"Open on GovTrack.us"; }
- (UIImage *)activityImage { return nil; }

- (void)performActivity {
    if (_url) {
        BOOL urlOpened = [[UIApplication sharedApplication] openURL:_url];
        [self activityDidFinish:urlOpened];
    }
}

@end
