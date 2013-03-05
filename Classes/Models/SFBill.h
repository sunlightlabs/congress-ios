//
//  SFBill.h
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SFSynchronizedObject.h"

@class SFLegislator;
@class SFBillAction;

@interface SFBill : SFSynchronizedObject <SFSynchronizedObject>

@property (nonatomic, retain) NSString * billId;
@property (nonatomic, retain) NSString * billType;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * session;
@property (nonatomic, retain) NSNumber * abbreviated;
@property (nonatomic, retain) NSString * chamber;
@property (nonatomic, retain) NSString * shortTitle;
@property (nonatomic, retain) NSString * officialTitle;
@property (nonatomic, retain) NSString * sponsorId;
@property (nonatomic, retain) NSDate * introducedOn;
@property (nonatomic, retain) NSDate * lastActionAt;
@property (nonatomic, retain) NSDate * lastPassageVoteAt;
@property (nonatomic, retain) NSDate * lastVoteAt;
@property (nonatomic, retain) NSDate * housePassageResultAt;
@property (nonatomic, retain) NSDate * senatePassageResultAt;
@property (nonatomic, retain) NSDate * vetoedAt;
@property (nonatomic, retain) NSDate * houseOverrideResultAt;
@property (nonatomic, retain) NSDate * senateOverrideResultAt;
@property (nonatomic, retain) NSDate * senateClotureResultAt;
@property (nonatomic, retain) NSDate * awaitingSignatureSince;
@property (nonatomic, retain) NSDate * enactedAt;
@property (nonatomic, retain) NSString * housePassageResult;
@property (nonatomic, retain) NSString * senatePassageResult;
@property (nonatomic, retain) NSString * houseOverrideResult;
@property (nonatomic, retain) NSString * senateOverrideResult;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * shortSummary;
@property (nonatomic, retain) SFLegislator *sponsor;
@property (nonatomic, retain) NSArray * actions;
@property (nonatomic, retain) SFBillAction * lastAction;

@property (nonatomic, retain) NSArray * rollCallVotes;
@property (readonly) BOOL lastActionAtIsDateTime;
@property (readonly) NSArray * actionsAndVotes;
@property (readonly) NSString *displayName;
@property (readonly) NSURL *shareURL;

@end
