//
//  NSMutableAttributedString+Congress.m
//  Congress
//
//  Created by Daniel Cloud on 4/1/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "NSMutableAttributedString+Congress.h"

@implementation NSMutableAttributedString (Congress)

+ (instancetype)stringWithFormat:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    return attrString;
}

@end
