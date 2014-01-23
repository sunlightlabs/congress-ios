//
//  SFSynchronizedObjectManager.m
//  Congress
//
//  Created by Daniel Cloud on 12/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFSynchronizedObjectManager.h"
#import "SFSynchronizedObject.h"

static void *SFSynchronizedObjectManagerContext = &SFSynchronizedObjectManagerContext;

NSString *const SFSynchronizedObjectFollowedEvent = @"SFSynchronizedObjectFollowedEvent";

@implementation SFSynchronizedObjectManager
{
    NSMutableDictionary *_collection;
}

static NSPredicate *followedPredicate;
static NSString *followedSelector;

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK ( ^{
        return [[[self class] alloc] init];
    });
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _collection = [NSMutableDictionary dictionary];
        followedSelector = NSStringFromSelector(@selector(followed));
    }
    return self;
}

- (instancetype)objectWithRemoteID:(NSString *)remoteID {
    id object = [_collection objectForKey:remoteID];
    return object;
}

- (void)addObject:(id)object {
    NSString *remoteID = [object valueForKey:@"remoteID"];
    if (![remoteID isEqual:[NSNull null]]) {
        [_collection setObject:object forKey:remoteID];
        [object addObserver:self forKeyPath:followedSelector
                    options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context:SFSynchronizedObjectManagerContext];
    }
}

- (void)removeObject:(id)object {
    NSString *remoteID = [object valueForKey:@"remoteID"];
    if (object && remoteID) {
        [_collection removeObjectForKey:remoteID];
    }
}

- (NSArray *)objectsForClass:(Class)aClass {
    NSSet *classKeys = [_collection keysOfEntriesPassingTest: ^BOOL (id key, id obj, BOOL *stop) {
        if ([obj isMemberOfClass:aClass]) {
            return YES;
        }
        return NO;
    }];
    NSArray *classObjects = [_collection objectsForKeys:[classKeys allObjects] notFoundMarker:[NSNull null]];
    return classObjects;
}

- (NSArray *)allFollowedObjects {
    NSArray *objects = [self _followedObjectsInArray:[_collection allValues]];
    return objects;
}

- (NSArray *)allFollowedObjectsForClass:(Class)aClass {
    NSArray *classObjects = [self objectsForClass:aClass];
    NSArray *followedObjects = [self _followedObjectsInArray:classObjects];
    return followedObjects;
}

#pragma mark - Key-Value Observation

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isKindOfClass:[SFSynchronizedObject class]]) {
        if ([keyPath isEqualToString:followedSelector]) {
            id old = [change objectForKey:NSKeyValueChangeOldKey];
            id new = [change objectForKey:NSKeyValueChangeNewKey];
            if (new != old) {
                [[NSNotificationCenter defaultCenter] postNotificationName:SFSynchronizedObjectFollowedEvent object:object];
            }
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Private

- (NSArray *)_followedObjectsInArray:(NSArray *)objectsArr {
    if (!followedPredicate) {
        followedPredicate = [NSPredicate predicateWithFormat:@"isFollowed == YES"];
    }
    return [objectsArr filteredArrayUsingPredicate:followedPredicate];
}

@end
