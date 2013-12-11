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

NSString * const SFQueuedTagsRegisteredNotification = @"SFQueuedTagsRegisteredNotification";

NSString * const SFBillActionNotificationType = @"SFBillActionNotificationType";
NSString * const SFBillVoteNotificationType = @"SFBillVoteNotificationType";
NSString * const SFBillUpcomingNotificationType = @"SFBillUpcomingNotificationType";
NSString * const SFCommitteeBillReferredNotificationType = @"SFCommitteeBillReferredNotificationType";
NSString * const SFLegislatorBillIntroNotificationType = @"SFLegislatorBillIntroNotificationType";
NSString * const SFLegislatorBillUpcomingNotificationType = @"SFLegislatorBillUpcomingNotificationType";
NSString * const SFLegislatorVoteNotificationType = @"SFLegislatorVoteNotificationType";

@implementation SFTagManager
{
    UAPush *_pusher;
    NSMutableArray *_notificationTypeTags;
}

static NSTimeInterval delayToPushInterval = 30.0;

@synthesize timeZoneTag = _timeZoneTag;

#pragma mark - SFSharedInstance

+(instancetype)sharedInstance
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[SFTagManager alloc] init];
    });
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pusher = [UAPush shared];
    }
    return self;
}

#pragma mark - Property Accessors

- (NSString *)timeZoneTag
{
    _timeZoneTag = [NSString pathWithComponents:@[@"/", @"device", @"timezone", [[NSTimeZone localTimeZone] abbreviation]]];
    return _timeZoneTag;
}

#pragma mark - Public methods

+ (NSDictionary *)notificationTags
{
    NSDictionary *dictionary = @{
        SFBillActionNotificationType: @"/bill/action",
        SFBillVoteNotificationType: @"/bill/vote",
        SFBillUpcomingNotificationType: @"/bill/upcoming",
        SFCommitteeBillReferredNotificationType: @"/committee/bill/referred",
        SFLegislatorBillIntroNotificationType: @"/legislator/sponsor/introduction",
        SFLegislatorBillUpcomingNotificationType: @"/legislator/sponsor/upcoming",
        SFLegislatorVoteNotificationType: @"/legislator/vote"
    };
	return dictionary;
}

- (void)updateAllTags
{
    //    Set up tags. Common tags and remote object IDs.
    NSMutableArray *tags = [NSMutableArray array];

    [tags addObject:self.timeZoneTag];
    [tags addObjectsFromArray:[self _followedObjectTags]];

    [_pusher addTagsToCurrentDevice:tags];

    [self _updateRegistrationAfterDelay];
}

#pragma mark - Wrap UAPush tag methods

- (void)addTagToCurrentDevice:(NSString *)tag
{
    if (![_pusher.tags containsObject:tag]) {
        [_pusher addTagToCurrentDevice:tag];
        [self _updateRegistrationAfterDelay];
    }
}

- (void)addTagsToCurrentDevice:(NSArray *)tags
{
    [_pusher addTagsToCurrentDevice:tags];
    [self _updateRegistrationAfterDelay];
}

- (void)removeTagFromCurrentDevice:(NSString *)tag
{
    if ([_pusher.tags containsObject:tag]) {
        [_pusher removeTagFromCurrentDevice:tag];
        [self _updateRegistrationAfterDelay];
    }
}

- (void)removeTagsFromCurrentDevice:(NSArray *)tags
{
    [_pusher removeTagsFromCurrentDevice:tags];
    [self _updateRegistrationAfterDelay];
}

#pragma mark - Private methods

- (NSArray *)_followedObjectTags
{
    NSArray *followableClasses = [[SFSynchronizedObjectManager sharedInstance] allFollowedObjects];
    NSArray *followURIs = [followableClasses valueForKeyPath:@"resourcePath"];
    return followURIs;
}

- (void)_updateRegistrationAfterDelay
{
    SEL selector = @selector(_updateRegistration);
    [SFTagManager cancelPreviousPerformRequestsWithTarget:self selector:selector object:nil];
    [self performSelector:selector withObject:nil afterDelay:delayToPushInterval];
}

- (void)_updateRegistration
{
    NSLog(@"UAPush updateRegistration");
    [_pusher updateRegistration];
}

@end
