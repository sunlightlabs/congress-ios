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

@synthesize remoteID;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic persist;

+(id)objectWithDictionary:(NSDictionary *)dictionary
{
    NSString *remoteID = [dictionary safeObjectForKey:[[self class] __remoteIdentifierKey]];

    if (!remoteID) {
        return nil;
    }

    id object = [self objectWithRemoteID:remoteID];
    [object setValuesForKeysWithJSONDictionary:dictionary];

    return object;
}

+(id)objectWithRemoteID:(NSString *)remoteID;
{
    id object = [self existingObjectWithRemoteID:remoteID];

    if (!object) {
        object =  [self createEntity];
        [object setValue:remoteID forKey:[[self class] __remoteIdentifierKey]];
    }
    return object;
}

+(id)existingObjectWithRemoteID:(NSString *)remoteID;
{
    id object = [self findFirstByAttribute:[self __remoteIdentifierKey] withValue:remoteID];
    return object;
}

#pragma mark - NSManagedObject methods

-(void)awakeFromInsert
{
    [super awakeFromInsert];
    [self setCreatedAt:[NSDate date]];
    [self setUpdatedAt:[NSDate date]];
}

#pragma mark - SynchronizedObject protocol methods

-(NSString *)getRemoteID{
    return [self valueForKey:[[self class] __remoteIdentifierKey]];
}

+(NSString *)__remoteIdentifierKey
{
    // Child classes must override this
    return nil;
}

@end
