//
//  SFBillTypeTransformer.h
//  Congress
//
//  Created by Daniel Cloud on 6/6/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const SFBillTypeTransformerName;

@interface SFBillTypeTransformer : NSValueTransformer

+ (NSDictionary *)typesDict;

@end
