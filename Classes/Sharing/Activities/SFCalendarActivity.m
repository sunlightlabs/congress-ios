//
//  SFCalendarActivity.m
//  Congress
//
//  Created by Jeremy Carbaugh on 9/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCalendarActivity.h"
#import "SFCalendarEventViewController.h"
#import <EventKit/EventKit.h>

@implementation SFCalendarActivity {
    EKEventStore *_store;
}

@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize title = _title;
@synthesize location = _location;
@synthesize notes = _notes;
@synthesize url = _url;

+ (instancetype)activityForHearing:(SFHearing *)hearing
{
    SFCalendarActivity *activity = [[SFCalendarActivity alloc] init];
    [activity setStartDate:hearing.occursAt];
    [activity setEndDate:[hearing.occursAt dateByAddingTimeInterval:60 * 60]];
    [activity setTitle:[NSString stringWithFormat:@"%@ Hearing", hearing.committee.name]];
    [activity setLocation:hearing.room];
    [activity setNotes:hearing.summary];
    [activity setUrl:hearing.url];
    return activity;
}

- (NSString *)activityType { return @"calendar"; }
- (NSString *)activityTitle { return @"Add to Calendar"; }
- (UIImage *)activityImage { return [UIImage imageNamed:@"Calendar"]; }

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
}

- (UIViewController *)activityViewController
{
    SFCalendarEventViewController *vc = [[SFCalendarEventViewController alloc] initWithNibName:nil bundle:nil];
    
    EKEvent *event = [EKEvent eventWithEventStore:vc.eventStore];
    [event setTitle:_title];
    [event setStartDate:_startDate];
    [event setEndDate:_endDate];
    [event setLocation:_location];
    [event setNotes:_notes];
    [event setURL:_url];
    
    [vc setEvent:event];
    return vc;
}

@end
