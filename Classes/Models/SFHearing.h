//
//  SFHearing.h
//  Congress
//
//  Created by Jeremy Carbaugh on 7/30/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFSynchronizedObject.h"
#import "SFCommittee.h"

@interface SFHearing : SFSynchronizedObject <SFSynchronizedObject>

@property (nonatomic, strong) SFCommittee *committee;
@property (nonatomic, strong) SFCommittee *parentCommittee;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSDate *occursAt;
@property (nonatomic, strong) NSString *chamber;
@property (nonatomic) NSInteger session;
@property (nonatomic) BOOL inDC;
@property (nonatomic, strong) NSString *room;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSArray *billIds;

- (NSString *)fauxId;
- (NSArray *)bills;
- (BOOL)isUpcoming;

@end
