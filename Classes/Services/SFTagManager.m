//
//  SFFollowedObjectsManager.m
//  Congress
//
//  Created by Daniel Cloud on 11/19/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

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

static NSTimeInterval queuePushTime = 5.0;
static NSTimeInterval queueTimerTolerance = 5.0;

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
        _tagQueue = [NSMutableSet set];
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

- (void)updateAllTags
{
    //    Set up tags. Common tags and remote object IDs.
    NSMutableArray *tags = [NSMutableArray array];

    [tags addObject:self.timeZoneTag];
    [tags addObjectsFromArray:[self _followedObjectTags]];

    [_pusher setTags:tags];
    [_pusher updateRegistration];
}

- (void)queueTagForRegistration:(NSString *)tagName
{
    [_tagQueue addObject:tagName];

    if (!_queueTimer) {
        _queueTimer = [NSTimer timerWithTimeInterval:queuePushTime
                                              target:self selector:@selector(_pushQueuedTags)
                                            userInfo:nil repeats:YES];
        [_queueTimer setTolerance:queueTimerTolerance];
    }
}

- (void)removeTagFromQueue:(NSString *)tagName
{
    [_tagQueue removeObject:tagName];
    if ([_tagQueue count] == 0) {
        [_queueTimer invalidate];
        _queueTimer = nil;
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
    // addTagsToCurrentDevice: creates an NSSet, so we don't need to dedupe.
    [_pusher addTagsToCurrentDevice:[_tagQueue allObjects]];
    [_pusher updateRegistration];
    [_tagQueue removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:SFQueuedTagsRegisteredNotification object:self];
}

@end
