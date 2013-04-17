//
//  SFDateFormatterUtil.h
//  Congress
//
//  Created by Daniel Cloud on 4/17/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFDateFormatterUtil : NSObject

+ (NSDateFormatter *)ISO8601DateTimeFormatter;
+ (NSDateFormatter *)ISO8601DateOnlyFormatter;
+ (NSDateFormatter *)mediumDateShortTimeFormatter;
+ (NSDateFormatter *)mediumDateNoTimeFormatter;
+ (NSDateFormatter *)shortDateMediumTimeFormatter;
+ (NSDateFormatter *)shortDateNoTimeFormatter;
+ (NSDateFormatter *)shortHumanDateFormatter;

@end
