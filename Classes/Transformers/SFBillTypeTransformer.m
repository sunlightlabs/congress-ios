//
//  SFBillTypeTransformer.m
//  Congress
//
//  Created by Daniel Cloud on 6/6/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillTypeTransformer.h"

NSString *const SFBillTypeTransformerName = @"SFBillTypeTransformerName";

@implementation SFBillTypeTransformer

static NSDictionary *_typeCodes = nil;

+ (void)load {
    [NSValueTransformer setValueTransformer:[SFBillTypeTransformer new] forName:SFBillTypeTransformerName];
}

#pragma mark - Bill types

+ (NSDictionary *)typesDict {
    if (!_typeCodes) {
        _typeCodes = @{ @"hr": @"H.R.", @"hres": @"H. Res.", @"hjres": @"H.J. Res.", @"hconres": @"H.Con. Res.",
                        @"s": @"S.", @"sres": @"S. Res.", @"sjres": @"S.J. Res.", @"sconres": @"S.Con. Res." };
    }
    return _typeCodes;
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

    NSString *billTypeRepr = [[self.class typesDict] sam_safeObjectForKey:value];

    return billTypeRepr;
}

@end
