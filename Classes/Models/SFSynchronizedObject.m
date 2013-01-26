//
//  SFSynchronizedObject.m
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//
// Inspired by the SSRemoteManagedObject classes in https://github.com/soffes/ssdatakit
//
// TODO: Implementation of setting updatedAt on saving existing object. React to NSManagedObjectContextWillSaveNotification


#import "SFSynchronizedObject.h"

@implementation SFSynchronizedObject

@synthesize createdAt;
@synthesize updatedAt;
@synthesize persist;

#pragma mark - Class methods

+(instancetype)objectWithExternalRepresentation:(NSDictionary *)externalRepresentation
{
    id object = nil;
    if (externalRepresentation) {
        NSString *remoteID = [externalRepresentation valueForKey:[self __remoteIdentifierKey]];\
        if (remoteID != nil) {
            object = [self existingObjectWithRemoteID:remoteID];
        }
        if (object != nil) {
            [object updateObjectUsingExternalRepresentation:externalRepresentation];
        }
        else if (externalRepresentation != nil)
        {
            object = [[self alloc] initWithExternalRepresentation:externalRepresentation];
            [object addObjectToCollection];
        }

    }
    return object;
}

+(instancetype)existingObjectWithRemoteID:(NSString *)remoteID
{
    if (!remoteID) {
        return nil;
    }
    id object = [[self collection] safeObjectForKey:remoteID];
    return object;
}

+(NSDictionary *)allObjectsToPersist
{
    return [[self collection] mtl_filterEntriesUsingBlock:^BOOL(id key, id value) {
        if (![value isMemberOfClass:self]) {
            return NO;
        }
        if ([value respondsToSelector:@selector(persist)]) {
            return [value persist];
        }
        return NO;
    }];
}


#pragma mark - Core methods

// Override to prevent errors when dictionary contains values we have not declared as properties.
// Sometimes JSON will have unexpected keys, yo.
-(instancetype)initWithDictionary:(NSDictionary *)dictionaryValue
{
    NSSet *propertyKeys = [[self class] propertyKeys];
    NSMutableSet *extraKeys = [NSMutableSet setWithArray:[dictionaryValue allKeys]];
    [extraKeys minusSet:propertyKeys];
    NSDictionary *existingPropertiesDict = [dictionaryValue mtl_dictionaryByRemovingEntriesWithKeys:extraKeys];
    self = [super initWithDictionary:existingPropertiesDict];
    if (self.createdAt == nil) {
        self.createdAt = [NSDate date];
    }
    if (self.updatedAt == nil) {
        self.updatedAt = [NSDate date];
    }

    return self;
}

-(NSString *)remoteID{
    return (NSString *)[self valueForKey:(NSString *)[[self class] __remoteIdentifierKey]];
}

-(void)updateObjectUsingExternalRepresentation:(NSDictionary *)externalRepresentation
{
    id newobject  = [[[self class] alloc] initWithExternalRepresentation:externalRepresentation];
    // Retain values related to persistence. We only want to update API values
    [newobject performSelector:@selector(setCreatedAt:) withObject:self.createdAt];
    [newobject performSelector:@selector(setUpdatedAt:) withObject:self.updatedAt];
    BOOL persistenceVal = self.persist;
    [self mergeValuesForKeysFromModel:newobject];
    self.persist = persistenceVal;
    @try {
        [self performSelector:@selector(setUpdatedAt:) withObject:[NSDate date]];
    }
    @catch (NSException *exception) {
        NSLog(@"Error setting updatedAt: %@", [exception reason]);
    }
}

-(void)addObjectToCollection
{
    NSMutableDictionary *collection = [[self class] collection];
    if (collection != nil) {
        [collection setObject:self forKey:self.remoteID];
    }
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
