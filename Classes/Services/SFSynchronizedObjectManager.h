//
//  SFSynchronizedObjectManager.h
//  Congress
//
//  Created by Daniel Cloud on 12/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const SFSynchronizedObjectFollowedEvent;

@interface SFSynchronizedObjectManager : NSObject <SFSharedInstance>

+ (instancetype)sharedInstance;

- (instancetype)objectWithRemoteID:(NSString *)remoteID;
- (void)addObject:(id)object;
- (void)removeObject:(id)object;
- (NSArray *)objectsForClass:(Class)aClass;
- (NSArray *)allFollowedObjects;
- (NSArray *)allFollowedObjectsForClass:(Class)aClass;

@end
