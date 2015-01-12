//
//  SFFollowedObjectsManager.m
//  Congress
//
//  Created by Daniel Cloud on 11/19/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFTagManager.h"
#import <UAPush.h>
#import "SFSynchronizedObjectManager.h"

NSString *const SFQueuedTagsRegisteredNotification = @"SFQueuedTagsRegisteredNotification";

SFNotificationType *const SFBillActionNotificationType = @"SFBillActionNotificationType";
SFNotificationType *const SFBillSignedNotificationType = @"SFBillSignedNotificationType";
SFNotificationType *const SFBillVoteNotificationType = @"SFBillVoteNotificationType";
SFNotificationType *const SFBillUpcomingNotificationType = @"SFBillUpcomingNotificationType";
SFNotificationType *const SFCommitteeBillReferredNotificationType = @"SFCommitteeBillReferredNotificationType";
SFNotificationType *const SFLegislatorBillIntroNotificationType = @"SFLegislatorBillIntroNotificationType";
SFNotificationType *const SFLegislatorBillUpcomingNotificationType = @"SFLegislatorBillUpcomingNotificationType";
SFNotificationType *const SFLegislatorVoteNotificationType = @"SFLegislatorVoteNotificationType";
SFNotificationType *const SFOtherImportantNotificationType = @"SFOtherImportantNotificationType";
SFNotificationType *const SFOtherAppNotificationType = @"SFOtherAppNotificationType";

@interface SFTagManager ()

@property (nonatomic, strong) UAPush *pusher;
@property (nonatomic, strong) NSPredicate *timeZoneTagPredicate;
@property (nonatomic, strong) NSPredicate *timeZoneinequalityPredicate;

@end

@implementation SFTagManager

static NSTimeInterval delayToPushInterval = 5.0;

@synthesize timeZoneTag = _timeZoneTag;

#pragma mark - SFSharedInstance

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK ( ^{
        return [[SFTagManager alloc] init];
    });
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pusher = [UAPush shared];
    }
    return self;
}

- (void)dealloc {
    [SFTagManager cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - Property Accessors

- (NSString *)timeZoneTag {
    _timeZoneTag = [NSString pathWithComponents:@[@"/", @"device", @"timezone", [[NSTimeZone localTimeZone] abbreviation]]];
    return _timeZoneTag;
}

- (NSPredicate *)timeZoneTagPredicate {
    if (!_timeZoneTagPredicate) {
        _timeZoneTagPredicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH '/device/timezone/'"];
    }
    return _timeZoneTagPredicate;
}

- (NSPredicate *)timeZoneinequalityPredicate {
    if (!_timeZoneinequalityPredicate) {
        _timeZoneinequalityPredicate = [NSPredicate predicateWithFormat:@"SELF != $CURRENT_TIMEZONE"];
    }
    return _timeZoneinequalityPredicate;
}

#pragma mark - Public methods

+ (NSDictionary *)notificationTags {
    NSDictionary *dictionary = @{
        SFBillActionNotificationType: @"/bill/action",
        SFBillSignedNotificationType: @"/bill/signed",
        SFBillVoteNotificationType: @"/bill/vote",
        SFBillUpcomingNotificationType: @"/bill/upcoming",
        SFCommitteeBillReferredNotificationType: @"/committee/bill/referred",
        SFLegislatorBillIntroNotificationType: @"/legislator/sponsor/introduction",
        SFLegislatorBillUpcomingNotificationType: @"/legislator/sponsor/upcoming",
        SFLegislatorVoteNotificationType: @"/legislator/vote",
        SFOtherImportantNotificationType: @"/cngres/important",
        SFOtherAppNotificationType: @"/cngres/app",
    };
    return dictionary;
}

- (void)updateFollowedObjectTags {
    //    Set up tags. Common tags and remote object IDs.
    NSMutableArray *tags = [NSMutableArray array];

    // Timezone stuff
    [tags addObject:self.timeZoneTag];
    NSMutableArray *timeZoneTags = [[NSMutableArray alloc] initWithArray:[self.pusher.tags filteredArrayUsingPredicate:self.timeZoneTagPredicate]];
    NSPredicate *tzComparePredicate = [self.timeZoneinequalityPredicate predicateWithSubstitutionVariables:@{@"CURRENT_TIMEZONE":self.timeZoneTag}];
    [timeZoneTags filterUsingPredicate:tzComparePredicate];

    if (timeZoneTags.count > 0) {
        [self.pusher removeTags:timeZoneTags];
    }

    // Followed object tags
    [tags addObjectsFromArray:[self _followedObjectTags]];

    [self.pusher addTags:tags];

    [self _updateRegistrationAfterDelay];
}

- (void)addTagForNotificationType:(SFNotificationType *)notificationType {
    NSString *tag = [[[self class] notificationTags] valueForKey:notificationType];
    if (tag) {
        [self addTag:tag];
    }
    else {
        CLSLog(@"Failed to addTagForNotificationType: %@", notificationType);
    }
}

- (void)addTagsForNotificationTypes:(NSArray *)notificationTypes {
    NSArray *tags = [self _tagsForNotificationTypes:notificationTypes];
    [self addTags:tags];
}

- (void)removeTagForNotificationType:(SFNotificationType *)notificationType {
    NSString *tag = [[[self class] notificationTags] valueForKey:notificationType];
    if (tag) {
        [self removeTag:tag];
    }
    else {
        CLSLog(@"Failed to removeTagForNotificationType: %@", notificationType);
    }
}

- (void)removeTagsForNotificationTypes:(NSArray *)notificationTypes {
    NSArray *tags = [self _tagsForNotificationTypes:notificationTypes];
    [self removeTags:tags];
}

#pragma mark - Wrap UAPush tag methods

- (void)addTag:(NSString *)tag {
    if (![self.pusher.tags containsObject:tag]) {
        [self addTags:[NSArray arrayWithObject:tag]];
    }
}

- (void)addTags:(NSArray *)tags {
    [self.pusher addTags:tags];
    [self _updateRegistrationAfterDelay];
}

- (void)removeTag:(NSString *)tag {
    if ([self.pusher.tags containsObject:tag]) {
        [self removeTags:[NSArray arrayWithObject:tag]];
    }
}

- (void)removeTags:(NSArray *)tags {
    [self.pusher removeTags:tags];
    [self _updateRegistrationAfterDelay];
}

#pragma mark - Private methods

- (NSArray *)_followedObjectTags {
    NSArray *followableClasses = [[SFSynchronizedObjectManager sharedInstance] allFollowedObjects];
    NSArray *followURIs = [followableClasses valueForKeyPath:@"resourcePath"];
    return followURIs;
}

- (void)_updateRegistrationAfterDelay {
    SEL selector = @selector(_updateRegistration);
    [SFTagManager cancelPreviousPerformRequestsWithTarget:self selector:selector object:nil];
    [self performSelector:selector withObject:nil afterDelay:delayToPushInterval];
}

- (void)_updateRegistration {
    NSLog(@"UAPush updateRegistration");
    [self.pusher updateRegistration];
}

- (NSArray *)_tagsForNotificationTypes:(NSArray *)notificationTypes {
    NSMutableArray *tags = [[[[self class] notificationTags] objectsForKeys:notificationTypes notFoundMarker:[NSNull null]] mutableCopy];
    [tags removeObjectIdenticalTo:[NSNull null]];
    return [tags copy];
}

@end
