//
//  NSString+Congress.h
//  Congress
//
//  Created by Daniel Cloud on 3/19/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//  Adapted from http://stackoverflow.com/questions/3312935/nsnumberformatter-and-th-st-nd-rd-ordinal-number-endings 
//

#import <Foundation/Foundation.h>

@interface NSString (Congress)

+ (NSString *)ordinalFromNumber:(NSNumber *)number;
- (NSString *)stringWithFirstLetterCapitalized;
@end
