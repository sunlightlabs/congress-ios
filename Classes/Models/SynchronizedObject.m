//
//  SynchronizedObject.m
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//
// Inspired by the SSRemoteManagedObject classes in https://github.com/soffes/ssdatakit
//
// TODO: Implementation of setting updatedAt on saving existing object. React to NSManagedObjectContextWillSaveNotification


#import "SynchronizedObject.h"

@implementation SynchronizedObject

@synthesize createdAt;
@synthesize updatedAt;
@synthesize persist;

#pragma mark - Class methods

+(id)objectWithDictionary:(NSDictionary *)dictionary
{
    NSString *remoteID = [dictionary safeObjectForKey:[[self class] __remoteIdentifierKey]];

    if (!remoteID) {
        return nil;
    }

    SynchronizedObject *object = [[[self class] alloc] initWithDictionary:dictionary];

    SynchronizedObject *oldobject = [self existingObjectWithRemoteID:remoteID];
    if (oldobject) {
        object.createdAt = oldobject.createdAt;
        oldobject = nil;
    }

    return object;
}

+(id)existingObjectWithRemoteID:(NSString *)remoteID
{
    id object = [[self collection] safeObjectForKey:remoteID];
    return object;
}

#pragma mark - Core methods

-(id)initWithDictionary:(NSDictionary *)dictionaryValue
{
    self = [super initWithDictionary:dictionaryValue];
    self.createdAt = [NSDate date];
    self.updatedAt = [NSDate date];

    NSMutableDictionary *collection = [[self class] collection];
    if (collection != nil) {
        [collection setObject:self forKey:self.remoteID];
    }
    return self;
}

-(NSString *)remoteID{
    return (NSString *)[self valueForKey:(NSString *)[[self class] __remoteIdentifierKey]];
}

#pragma mark - SynchronizedObject protocol methods

+(NSString *)__remoteIdentifierKey
{
    // Child classes must override this
    return nil;
}

+(NSMutableDictionary *)collection
{
    // Child classes must override this
    return nil;
}

@end
