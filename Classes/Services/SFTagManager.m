//
//  SFFollowedObjectsManager.m
//  Congress
//
//  Created by Daniel Cloud on 11/19/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//
// UAPush maintains a set of tags, but not a queue of changes.
// This class maintains a queue so we can monitor addition/removal of tags and periodically update them on the server.

#import "SFTagManager.h"
#import <UAPush.h>
#import "SFBill.h"
#import "SFLegislator.h"
#import "SFCommittee.h"

NSString * const SFQueuedTagsRegisteredNotification = @"SFQueuedTagsRegisteredNotification";

@implementation SFTagManager
{
    NSMutableSet *_tagQueue;
    NSTimer *_queueTimer;
    UAPush *_pusher;
}

static NSTimeInterval delayToPushInterval = 30.0;
static NSTimeInterval queueTimerTolerance = 10.0;

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
        _tagQueue = [NSMutableSet set];
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

- (void)updateAllTags
{
    //    Set up tags. Common tags and remote object IDs.
    NSMutableArray *tags = [NSMutableArray array];

    [tags addObject:self.timeZoneTag];
    [tags addObjectsFromArray:[self _followedObjectTags]];

    [_pusher setTags:tags];

    SEL selector = @selector(_updateRegistration);
    [UAPush cancelPreviousPerformRequestsWithTarget:self selector:selector object:nil];
    [self performSelector:selector withObject:nil afterDelay:delayToPushInterval];
}

- (void)queueTagForRegistration:(NSString *)tagName
{
    [_tagQueue addObject:tagName];
    [_pusher addTagToCurrentDevice:tagName];

    if (!_queueTimer) {
        [self _setUpTimer];
    }
}

- (void)removeTagFromQueue:(NSString *)tagName
{
    if ([_tagQueue containsObject:tagName]) {
        // tag is in the queue (unsent) and was removed
        [_tagQueue removeObject:tagName];
    }
    else {
        // tag needs to be removed from remote list
        [_tagQueue addObject:tagName];
    }
    [_pusher removeTagFromCurrentDevice:tagName];
    if ([_tagQueue count] == 0 && [_queueTimer isValid]) {
        [self _resetQueueAndDestroyTimer];
    } else if (!_queueTimer) {
        [self _setUpTimer];
    }
}

#pragma mark - Private methods

- (NSArray *)_followedObjectTags
{
    NSMutableSet *followURIs = [NSMutableSet set];
    NSArray *followableClasses = @[[SFLegislator class], [SFBill class], [SFCommittee class]];
    for (Class class in followableClasses) {
        [followURIs addObjectsFromArray:[[class allObjectsToPersist] valueForKeyPath:@"resourcePath"]];
    }
    return [followURIs allObjects];
}

- (void)_pushQueuedTags
{
    NSLog(@"Pushing queued tags");
    if ([_tagQueue count] > 0) {
        [_pusher updateRegistration];
    }
    [self _resetQueueAndDestroyTimer];
    [[NSNotificationCenter defaultCenter] postNotificationName:SFQueuedTagsRegisteredNotification object:self];
}

- (void)_setUpTimer
{
    if (_queueTimer) {
        [_queueTimer invalidate];
    }
    _queueTimer = [NSTimer scheduledTimerWithTimeInterval:delayToPushInterval
                                                   target:self selector:@selector(_pushQueuedTags)
                                                 userInfo:nil repeats:YES];
    [_queueTimer setTolerance:queueTimerTolerance];
}

- (void)_resetQueueAndDestroyTimer
{
    [_tagQueue removeAllObjects];
    [_queueTimer invalidate];
    _queueTimer = nil;
}

- (void)_updateRegistration
{
    NSLog(@"updateRegistration");
    [_pusher updateRegistration];
}

@end
