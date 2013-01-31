//
//  SFVote.h
//  Congress
//
//  Created by Daniel Cloud on 1/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFSynchronizedObject.h"

@class SFBill;

@interface SFVote : SFSynchronizedObject <SFSynchronizedObject>

@property (nonatomic, retain) NSString * rollId;
@property (nonatomic, retain) NSString * chamber;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSNumber * congress;
@property (nonatomic, retain) NSDate * votedAt;
@property (nonatomic, retain) NSString * voteType;
@property (nonatomic, retain) NSString * rollType;
@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSString * required;
@property (nonatomic, retain) NSString * result;
@property (nonatomic, retain) NSString * billId;

@property (nonatomic, retain) SFBill * bill;

@end
