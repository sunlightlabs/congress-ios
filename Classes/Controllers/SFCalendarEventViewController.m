//
//  SFCalendarEventViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 9/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCalendarEventViewController.h"
#import <EventKitUI/EventKitUI.h>

@interface SFCalendarEventViewController ()

@end

@implementation SFCalendarEventViewController

@synthesize hasPermission = _hasPermission;
@synthesize event = _event;
@synthesize eventStore = _eventStore;

- (id)initWithEvent:(EKEvent *)event {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        [self setEvent:event];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _hasPermission = NO;
        _eventStore = [[EKEventStore alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_eventStore requestAccessToEntityType:EKEntityTypeEvent completion: ^(BOOL granted, NSError *error) {
        _hasPermission = granted;
        if (_hasPermission) {
            EKEventEditViewController *editController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
            [editController setEvent:_event];
            [editController setEventStore:_eventStore];
            [editController setDelegate:(id)self];

            [self presentViewController:editController animated:YES completion:nil];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to add to calendar"
                                                            message:@"Sorry, we can't add events unless you've given us access to your calendar."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}

#pragma mark - EKEventEditViewDelegate

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action {
    if (action == EKEventEditViewActionCanceled) {
    }
    else if (action == EKEventEditViewActionSaved) {
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
