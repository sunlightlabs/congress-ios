//
//  SFCalendarEventViewController.h
//  Congress
//
//  Created by Jeremy Carbaugh on 9/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface SFCalendarEventViewController : UIViewController <EKEventEditViewDelegate>

@property (nonatomic) BOOL hasPermission;
@property (nonatomic, strong) EKEvent *event;
@property (nonatomic, strong) EKEventStore *eventStore;

- (id)initWithEvent:(EKEvent *)event;

@end
