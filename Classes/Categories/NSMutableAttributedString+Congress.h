//
//  NSMutableAttributedString+Congress.h
//  Congress
//
//  Created by Daniel Cloud on 4/1/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Congress)

+ (instancetype)stringWithFormat:(NSString *)format, ...NS_FORMAT_FUNCTION(1, 2);

@end
