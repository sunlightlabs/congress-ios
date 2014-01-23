//
//  SVPullToRefreshView+Congress.m
//  Congress
//
//  Created by Daniel Cloud on 3/22/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SVPullToRefreshView+Congress.h"
#import "SFDateFormatterUtil.h"

@implementation SVPullToRefreshView (Congress)

- (void)setLastUpdatedNow {
    NSDateFormatter *df = [SFDateFormatterUtil shortDateMediumTimeFormatter];
    NSString *updatedString = [NSString stringWithFormat:@"Last Updated: %@", [df stringFromDate:[NSDate date]]];
    [self setSubtitle:updatedString forState:SVPullToRefreshStateAll];
}

- (void)stopAnimatingAndSetLastUpdatedNow {
    [self setLastUpdatedNow];
    [self stopAnimating];
}

@end
