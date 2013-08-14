//
//  SFCommittee.h
//  Congress
//
//  Created by Jeremy Carbaugh on 7/19/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFSynchronizedObject.h"
#import "SFLegislator.h"

@interface SFCommittee : SFSynchronizedObject <SFSynchronizedObject>

@property (nonatomic, strong) NSString *committeeId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *chamber;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *office;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) SFCommittee *parentCommittee;
@property (nonatomic, strong) NSArray *members;
@property (nonatomic) BOOL isSubcommittee;

- (NSString *)prefixName;
- (NSString *)primaryName;
- (SFLegislator *)chairman;
- (SFLegislator *)rankingMember;
- (NSString *)shareURL;

@end


/* SFCommitteeMember */

@interface SFCommitteeMember : NSObject

@property (nonatomic, strong) NSString *side;
@property (nonatomic) NSUInteger rank;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) SFLegislator *legislator;

@end
