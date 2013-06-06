//
//  SFBillIDTransformer.m
//  Congress
//
//  Created by Daniel Cloud on 6/6/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillIdTransformer.h"
#import "SFBillTypeTransformer.h"

NSString * const SFBillIdTransformerName = @"SFBillIdTransformerName";

@implementation SFBillIdTransformer

+ (void)load
{
    [NSValueTransformer setValueTransformer:[SFBillIdTransformer new] forName:SFBillIdTransformerName];
}

#pragma mark - NSValueTransformer

+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    if (![value isKindOfClass:[NSString class]]) return nil;

    NSScanner *scanBillId = [NSScanner scannerWithString:value];
    NSString *letterChars, *numberChars, *congressChars = NULL;

    NSCharacterSet *decimalSet = [NSCharacterSet decimalDigitCharacterSet];
    [scanBillId scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&letterChars];
    [scanBillId scanCharactersFromSet:decimalSet intoString:&numberChars];
    NSRange hyphenRange = [value rangeOfCharacterFromSet:[NSCharacterSet punctuationCharacterSet]];
    [scanBillId setScanLocation:(hyphenRange.location+1)];
    [scanBillId scanCharactersFromSet:decimalSet intoString:&congressChars];

    NSString *typeString = [[NSValueTransformer valueTransformerForName:SFBillTypeTransformerName] transformedValue:letterChars];
    NSMutableString *newValue = [NSMutableString stringWithString:typeString];
    [newValue appendString:@" "];
    [newValue appendString:numberChars];

    return newValue;
}

@end
