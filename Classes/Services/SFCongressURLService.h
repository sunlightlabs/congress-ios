//
//  SFCongressURLService.h
//  Congress
//
//  Created by Daniel Cloud on 2/22/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFCongressURLService : NSObject

+ (NSURL *)landingPageforBillWithId:(NSString *)billId;
+ (NSURL *)fullTextPageforBillWithId:(NSString *)billId;
+ (NSURL *)landingPageForLegislatorWithId:(NSString *)bioguideId;

@end
