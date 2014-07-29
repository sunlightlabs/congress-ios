//
//  SFDateFormatterUtil.h
//  Congress
//
//  Created by Daniel Cloud on 4/17/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ISO8601DateFormatter.h>

@interface SFDateFormatterUtil : NSObject

+ (ISO8601DateFormatter *)isoDateFormatter;
+ (ISO8601DateFormatter *)isoDateTimeFormatter;

+ (NSDateFormatter *)mediumDateShortTimeFormatter;
+ (NSDateFormatter *)mediumDateNoTimeFormatter;
+ (NSDateFormatter *)longDateNoTimeFormatter;
+ (NSDateFormatter *)shortDateMediumTimeFormatter;
+ (NSDateFormatter *)shortDateNoTimeFormatter;
+ (NSDateFormatter *)shortHumanDateFormatter;

@end
