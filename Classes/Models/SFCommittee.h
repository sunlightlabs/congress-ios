//
//  SFCommittee.h
//  Congress
//
//  Created by Jeremy Carbaugh on 7/19/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSynchronizedObject.h"
#import "SFLegislator.h"

@interface SFCommittee : SFSynchronizedObject <SFSynchronizedObject>

@property (nonatomic, copy) NSString *committeeId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *chamber;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *office;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) SFCommittee *parentCommittee;
@property (nonatomic, strong) NSArray *members;
@property (nonatomic) BOOL isSubcommittee;

@property (nonatomic, readonly) NSString *prefixName;
@property (nonatomic, readonly) NSString *primaryName;
@property (nonatomic, readonly) SFLegislator *chairman;
@property (nonatomic, readonly) SFLegislator *rankingMember;
@property (nonatomic, readonly) NSString *shareURL;

@end


/* SFCommitteeMember */

@interface SFCommitteeMember : SFSynchronizedObject <SFSynchronizedObject>

@property (nonatomic, strong) NSString *side;
@property (nonatomic) NSUInteger rank;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) SFLegislator *legislator;

@end
