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

+(instancetype)existingObjectWithRemoteID:(NSString *)remoteID
{
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

-(instancetype)init
{
    self = [super init];
    self.persist = NO;

    return self;
}

// Override to prevent errors when dictionary contains values we have not declared as properties.
// Sometimes JSON will have unexpected keys, yo.
-(instancetype)initWithDictionary:(NSDictionary *)dictionaryValue
{
    NSSet *propertyKeys = [[self class] propertyKeys];
    NSMutableSet *extraKeys = [NSMutableSet setWithArray:[dictionaryValue allKeys]];
    [extraKeys minusSet:propertyKeys];
    NSDictionary *existingPropertiesDict = [dictionaryValue mtl_dictionaryByRemovingEntriesWithKeys:extraKeys];
    self = [super initWithDictionary:existingPropertiesDict];
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
