//
//  SFFollowedObjectsManager.h
//  Congress
//
//  Created by Daniel Cloud on 11/19/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSharedInstance.h"

FOUNDATION_EXPORT NSString * const SFQueuedTagsRegisteredNotification;

FOUNDATION_EXPORT NSString * const SFBillActionNotificationType;
FOUNDATION_EXPORT NSString * const SFBillVoteNotificationType;
FOUNDATION_EXPORT NSString * const SFBillUpcomingNotificationType;
FOUNDATION_EXPORT NSString * const SFCommitteeBillReferredNotificationType;
FOUNDATION_EXPORT NSString * const SFLegislatorBillIntroNotificationType;
FOUNDATION_EXPORT NSString * const SFLegislatorBillUpcomingNotificationType;
FOUNDATION_EXPORT NSString * const SFLegislatorVoteNotificationType;

@interface SFTagManager : NSObject <SFSharedInstance>

@property (readonly, nonatomic, strong) NSString *timeZoneTag;

+(instancetype)sharedInstance;

- (void)updateAllTags;
- (void)addTagToCurrentDevice:(NSString *)tag;
- (void)addTagsToCurrentDevice:(NSArray *)tags;
- (void)removeTagFromCurrentDevice:(NSString *)tag;
- (void)removeTagsFromCurrentDevice:(NSArray *)tags;

@end
