//
//  SFCongressURLService.h
//  Congress
//
//  Created by Daniel Cloud on 2/22/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFCongressURLService : NSObject

+ (NSURL *)globalLandingPage;

+ (NSURL *)appScreenForBillWithId:(NSString *)billId;
+ (NSURL *)landingPageForBillWithId:(NSString *)billId;
+ (NSURL *)fullTextPageForBillWithId:(NSString *)billId;

+ (NSURL *)appScreenForLegislatorWithId:(NSString *)bioguideId;
+ (NSURL *)landingPageForLegislatorWithId:(NSString *)bioguideId;

+ (NSURL *)appScreenForCommitteeWithId:(NSString *)committeeId;
+ (NSURL *)landingPageForCommitteeWithId:(NSString *)committeeId;

@end
