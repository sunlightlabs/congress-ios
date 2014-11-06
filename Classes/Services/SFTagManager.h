//
//  SFFollowedObjectsManager.h
//  Congress
//
//  Created by Daniel Cloud on 11/19/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSharedInstance.h"

typedef NSString SFNotificationType;

FOUNDATION_EXPORT NSString *const SFQueuedTagsRegisteredNotification;

FOUNDATION_EXPORT SFNotificationType *const SFBillActionNotificationType;
FOUNDATION_EXPORT SFNotificationType *const SFBillSignedNotificationType;
FOUNDATION_EXPORT SFNotificationType *const SFBillVoteNotificationType;
FOUNDATION_EXPORT SFNotificationType *const SFBillUpcomingNotificationType;
FOUNDATION_EXPORT SFNotificationType *const SFCommitteeBillReferredNotificationType;
FOUNDATION_EXPORT SFNotificationType *const SFLegislatorBillIntroNotificationType;
FOUNDATION_EXPORT SFNotificationType *const SFLegislatorBillUpcomingNotificationType;
FOUNDATION_EXPORT SFNotificationType *const SFLegislatorVoteNotificationType;
FOUNDATION_EXPORT SFNotificationType *const SFOtherImportantNotificationType;
FOUNDATION_EXPORT SFNotificationType *const SFOtherAppNotificationType;

@interface SFTagManager : NSObject <SFSharedInstance>

@property (readonly, nonatomic, strong) NSString *timeZoneTag;

+ (instancetype)sharedInstance;

- (void)updateFollowedObjectTags;
- (void)addTag:(NSString *)tag;
- (void)addTags:(NSArray *)tags;
- (void)removeTag:(NSString *)tag;
- (void)removeTags:(NSArray *)tags;

- (void)addTagForNotificationType:(SFNotificationType *)notificationType;
- (void)addTagsForNotificationTypes:(NSArray *)notificationTypes;
- (void)removeTagForNotificationType:(SFNotificationType *)notificationType;
- (void)removeTagsForNotificationTypes:(NSArray *)notificationTypes;

@end
