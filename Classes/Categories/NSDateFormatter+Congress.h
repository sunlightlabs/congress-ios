//
//  NSDateFormatter+Congress.h
//  Congress
//
//  Created by Daniel Cloud on 1/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Congress)

+ (NSDateFormatter *)ISO8601DateTimeFormatter;
+ (NSDateFormatter *)ISO8601DateOnlyFormatter;
+ (NSDateFormatter *)mediumDateShortTimeFormatter;
+ (NSDateFormatter *)shortDateMediumTimeFormatter;

@end
