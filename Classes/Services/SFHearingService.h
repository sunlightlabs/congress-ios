//
//  SFHearingService.h
//  Congress
//
//  Created by Jeremy Carbaugh on 7/30/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFHearing.h"

@interface SFHearingService : NSObject

+ (void)hearingsForCommitteeId:(NSString *)committeeId completionBlock:(void (^) (NSArray *hearings))completionBlock;
+ (void)recentHearingsWithCompletionBlock:(void (^) (NSArray *hearings))completionBlock;
+ (void)upcomingHearingsWithCompletionBlock:(void (^) (NSArray *hearings))completionBlock;

@end
