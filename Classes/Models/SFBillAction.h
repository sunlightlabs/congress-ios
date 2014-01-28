//
//  SFBillAction.h
//  Congress
//
//  Created by Daniel Cloud on 1/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFSynchronizedObject.h"

@class SFBill;

@interface SFBillAction : SFSynchronizedObject

@property (nonatomic, weak) SFBill *bill;

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSDate *actedAt;
@property (nonatomic, strong) NSString *chamber;
@property (nonatomic, strong) NSString *how;
@property (nonatomic, strong) NSString *voteType;
@property (nonatomic, strong) NSString *result;
@property (nonatomic, copy) NSString *rollId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray *references;

@property (readonly) BOOL actedAtIsDateTime;

- (NSString *)typeDescription;

@end
