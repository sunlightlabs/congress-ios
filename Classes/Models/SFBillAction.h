//
//  SFBillAction.h
//  Congress
//
//  Created by Daniel Cloud on 1/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFSynchronizedObject.h"

@interface SFBillAction : SFSynchronizedObject

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSDate * actedAt;
@property (nonatomic, retain) NSString * chamber;
@property (nonatomic, retain) NSString * how;
@property (nonatomic, retain) NSString * voteType;
@property (nonatomic, retain) NSString * result;
@property (nonatomic, retain) NSString * rollId;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSArray * references;

@end
