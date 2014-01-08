//
//  SFHearingDetailViewController.h
//  Congress
//
//  Created by Jeremy Carbaugh on 8/23/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFShareableViewController.h"
#import "SFBillsTableViewController.h"
#import "SFHearingDetailView.h"
#import "SFHearing.h"
#import <EventKitUI/EventKitUI.h>

@interface SFHearingDetailViewController : GAITrackedViewController <EKEventEditViewDelegate>

@property (nonatomic, strong) SFHearingDetailView *detailView;
@property (nonatomic, strong) SFBillsTableViewController *billsTableViewController;

- (void)updateWithHearing:(SFHearing *)hearing;

@end
