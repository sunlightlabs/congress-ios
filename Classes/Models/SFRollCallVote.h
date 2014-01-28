//
//  SFVote.h
//  Congress
//
//  Created by Daniel Cloud on 1/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFSynchronizedObject.h"

@class SFBill;

@interface SFRollCallVote : SFSynchronizedObject <SFSynchronizedObject>

@property (nonatomic, copy) NSString *rollId;
@property (nonatomic, strong) NSString *chamber;
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) NSNumber *year;
@property (nonatomic, strong) NSNumber *congress;
@property (nonatomic, strong) NSDate *votedAt;
@property (nonatomic, strong) NSString *voteType;
@property (nonatomic, strong) NSString *rollType;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *required;
@property (nonatomic, strong) NSString *result;
@property (nonatomic, strong) NSString *billId;
@property (nonatomic, strong) NSDictionary *voterDict;
@property (nonatomic, strong) NSDictionary *breakdown;

@property (nonatomic, weak) SFBill *bill;

@property (nonatomic, readonly) NSArray *voters;
@property (nonatomic, readonly) NSArray *choices;
@property (nonatomic, readonly) NSDictionary *totals;
@property (nonatomic, readonly) NSArray *questionParts;
@property (nonatomic, readonly) NSString *questionShort;

- (NSArray *)voterIdsForChoice:(NSString *)choice;

@end
