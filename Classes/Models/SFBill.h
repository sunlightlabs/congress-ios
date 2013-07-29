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
#import "SFBillIdentifier.h"

@class SFLegislator;
@class SFBillAction;

@interface SFBill : SFSynchronizedObject <SFSynchronizedObject>

@property (nonatomic, strong) NSString * billId;
@property (nonatomic, strong) NSString * billType;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSNumber * number;
@property (nonatomic, strong) NSNumber * congress;
@property (nonatomic, strong) NSNumber * abbreviated;
@property (nonatomic, strong) NSString * chamber;
@property (nonatomic, strong) NSString * shortTitle;
@property (nonatomic, strong) NSString * officialTitle;
@property (nonatomic, strong) NSString * sponsorId;
@property (nonatomic, strong) NSDate * introducedOn;
@property (nonatomic, strong) NSDate * lastActionAt;
@property (nonatomic, strong) NSDate * lastPassageVoteAt;
@property (nonatomic, strong) NSDate * lastVoteAt;
@property (nonatomic, strong) NSDictionary *lastVersion;
@property (nonatomic, strong) NSDate * housePassageResultAt;
@property (nonatomic, strong) NSDate * senatePassageResultAt;
@property (nonatomic, strong) NSDate * vetoedAt;
@property (nonatomic, strong) NSDate * houseOverrideResultAt;
@property (nonatomic, strong) NSDate * senateOverrideResultAt;
@property (nonatomic, strong) NSDate * senateClotureResultAt;
@property (nonatomic, strong) NSDate * awaitingSignatureSince;
@property (nonatomic, strong) NSDate * enactedAt;
@property (nonatomic, strong) NSString * housePassageResult;
@property (nonatomic, strong) NSString * senatePassageResult;
@property (nonatomic, strong) NSString * houseOverrideResult;
@property (nonatomic, strong) NSString * senateOverrideResult;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSString * shortSummary;
@property (nonatomic, strong) SFLegislator *sponsor;
@property (nonatomic, strong) NSArray * actions;
@property (nonatomic, strong) NSArray * cosponsorIds;
@property (nonatomic, strong, readonly) SFBillAction * lastAction;

@property (nonatomic, strong) NSArray * rollCallVotes;
@property (readonly) BOOL lastActionAtIsDateTime;
@property (nonatomic, readonly) NSArray * actionsAndVotes;
@property (nonatomic, readonly) NSString *displayBillType;
@property (nonatomic, readonly) NSString *displayName;
@property (nonatomic, readonly) SFBillIdentifier *identifier;
@property (nonatomic, readonly) NSURL *shareURL;

+ (NSString *)normalizeToCode:(NSString *)inputText;
+ (NSTextCheckingResult *)billCodeCheckingResult:(NSString *)searchText;

-(NSURL *)govTrackURL;
-(NSURL *)govTrackFullTextURL;
-(NSURL *)openCongressURL;
-(NSURL *)openCongressFullTextURL;
-(NSURL *)congressGovURL;
-(NSURL *)congressGovFullTextURL;

@end
