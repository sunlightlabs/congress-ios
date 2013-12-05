//
//  SFHearingsSectionViewController.h
//  Congress
//
//  Created by Jeremy Carbaugh on 8/23/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "GAITrackedViewController.h"
#import "SFHearingsTableViewController.h"
#import "SFSegmentedViewController.h"

@interface SFHearingsSectionViewController : GAITrackedViewController

@property (nonatomic, retain) SFHearingsTableViewController *recentHearingsController;
@property (nonatomic, retain) SFHearingsTableViewController *upcomingHearingsController;
@property (nonatomic, strong) SFSegmentedViewController *segmentedController;

@property (nonatomic) NSInteger *restorationSelectedSegment;

@end
