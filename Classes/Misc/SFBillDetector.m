//
//  SFBillDetector.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/18/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillDetector.h"

@implementation SFBillDetector

+ (NSArray*)detectBills:(NSString*)text forSession:(NSString*)session
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"((S\\.|H\\.)(\\s?J\\.|\\s?R\\.|\\s?Con\\.| ?)(\\s?Res\\.)*)\\s?(\\d+)"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    for (NSTextCheckingResult *match in matches) {
        
        NSUInteger numberOfRanges = [match numberOfRanges];
        
        if (numberOfRanges > 2) {
            NSString *billType = [text substringWithRange:[match rangeAtIndex:1]];
            NSString *billNumber = [text substringWithRange:[match rangeAtIndex:numberOfRanges - 1]];
            
            billType = [billType stringByReplacingOccurrencesOfString:@" " withString:@""];
            billType = [billType stringByReplacingOccurrencesOfString:@"." withString:@""];
            billType = [billType lowercaseString];
            
            NSString *billId = [NSString stringWithFormat:@"%@%@-%@", billType, billNumber, session];
            
            [results addObject:[[NSArray alloc] initWithObjects:[NSValue valueWithRange:[match range]], billId, nil]];
        }
    }
    return results;
}

@end
