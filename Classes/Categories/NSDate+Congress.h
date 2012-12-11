//
//  NSDate+Congress.h
//  Congress
//
//  Created by Daniel Cloud on 12/11/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Congress)

+ (NSDate *)dateFromDateOnlyString:(NSString *)dateOnlyString;
- (NSString *)stringWithMediumDateOnly;

@end
