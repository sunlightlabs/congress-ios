//
//  SFBillIdentifier.h
//  Congress
//
//  Created by Jeremy Carbaugh on 7/17/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFBillIdentifier : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *session;

+ (SFBillIdentifier *)initWithBillID:(NSString *)billID;
+ (NSDictionary *)typeCodes;

- (id)initWithType:(NSString *)type number:(NSString *)number session:(NSString *)session;

- (NSString *)displayName;

@end
