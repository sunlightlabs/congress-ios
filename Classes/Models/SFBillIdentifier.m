//
//  SFBillIdentifier.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/17/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillIdentifier.h"

@implementation SFBillIdentifier

@synthesize type = _type;
@synthesize number = _number;
@synthesize session = _session;

+ (NSDictionary *)typeCodes {
    static NSDictionary *_typeCodes = nil;
    if (_typeCodes == nil) {
        _typeCodes = @{ @"hr": @"H.R.", @"hres": @"H. Res.", @"hjres": @"H.J. Res.", @"hconres": @"H.Con. Res.",
                        @"s": @"S.", @"sres": @"S. Res.", @"sjres": @"S.J. Res.", @"sconres": @"S.Con. Res." };
    }
    return _typeCodes;
}

+ (SFBillIdentifier *)initWithBillID:(NSString *)billID {
    return nil;
}

- (id)initWithType:(NSString *)type number:(NSString *)number session:(NSString *)session {
    if (self = [super init]) {
        _type = type;
        _number = number;
        _session = session;
    }
    return self;
}

- (NSString *)displayName {
    return [NSString stringWithFormat:@"%@ %@", [[SFBillIdentifier typeCodes] objectForKey:_type], _number];
}

@end
