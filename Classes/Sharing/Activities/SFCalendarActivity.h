//
//  SFCalendarActivity.h
//  Congress
//
//  Created by Jeremy Carbaugh on 9/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFActivity.h"
#import "SFHearing.h"

@interface SFCalendarActivity : SFActivity

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSURL *url;

+ (instancetype)activityForHearing:(SFHearing *)hearing;

@end
