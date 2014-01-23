//
//  SFBillIdentifierTransformer.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/17/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillIdentifierTransformer.h"
#import "SFBillIdentifier.h"

NSString *const SFBillIdentifierTransformerName = @"SFBillIdentifierTransformerName";

@implementation SFBillIdentifierTransformer

+ (void)load {
    [NSValueTransformer setValueTransformer:[SFBillIdentifierTransformer new] forName:SFBillIdentifierTransformerName];
}

#pragma mark - NSValueTransformer

+ (Class)transformedValueClass {
    return [SFBillIdentifier class];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}

- (id)transformedValue:(id)value {
    if (value == nil || ![value isKindOfClass:[NSString class]]) return nil;

    NSScanner *scanner = [NSScanner scannerWithString:value];
    NSString *type, *number, *session = NULL;

    NSCharacterSet *decimalSet = [NSCharacterSet decimalDigitCharacterSet];
    NSRange hyphenRange = [value rangeOfCharacterFromSet:[NSCharacterSet punctuationCharacterSet]];

    [scanner scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&type];
    [scanner scanCharactersFromSet:decimalSet intoString:&number];
    [scanner setScanLocation:(hyphenRange.location + 1)];
    [scanner scanCharactersFromSet:decimalSet intoString:&session];

    return [[SFBillIdentifier alloc] initWithType:type number:number session:session];
}

- (id)reverseTransformedValue:(id)value {
    if (value == nil || ![value isKindOfClass:[SFBillIdentifier class]]) return nil;
    SFBillIdentifier *bi = (SFBillIdentifier *)value;
    return [NSString stringWithFormat:@"%@%@-%@", bi.type, bi.number, bi.session];
}

@end
