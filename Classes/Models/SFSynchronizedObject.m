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

NSString *const SFSynchronizedObjectPersistDidChange = @"SFSynchronizedObjectPersistDidChange";

@implementation SFSynchronizedObject

@synthesize createdAt;
@synthesize updatedAt;
@synthesize persist = _persist;

#pragma mark - Class methods

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [NSDictionary dictionary];
}

+ (NSDictionary *)dictionaryValueFromArchivedExternalRepresentation:(NSDictionary *)externalRepresentation version:(NSUInteger)fromVersion {
    NSLog(@"Updating %@ object from version %lu", NSStringFromClass([self class]), (unsigned long)fromVersion);
    Class modelClass = [self class];
    if (fromVersion == 1) {
        NSError *initError;
        id object = [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:externalRepresentation error:&initError];
        return [object dictionaryValue];
    } else {
        return nil;
    }
}

+(instancetype)objectWithJSONDictionary:(NSDictionary *)jsonDictionary
{
    id object = nil;
    if (jsonDictionary) {
        NSDictionary *keyPathsByPropertyKey = [self JSONKeyPathsByPropertyKey];
        NSString *externalIdentifierKey = keyPathsByPropertyKey[[self remoteIdentifierKey]];
        NSString *remoteID = [jsonDictionary objectForKey:externalIdentifierKey];
        if (remoteID != nil) {
            object = [self existingObjectWithRemoteID:remoteID];
        }
        if (object != nil) {
            [object updateObjectUsingJSONDictionary:jsonDictionary];
        }
        else if (jsonDictionary != nil)
        {
            NSError *initError;
            object = [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:jsonDictionary error:&initError];
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
    NSIndexSet *indexes = [[self collection] indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return ([[obj remoteID] isEqualToString:remoteID]);
    }];
    NSArray *matches = [[self collection] objectsAtIndexes:indexes];
    id object = [matches lastObject];
    if ([matches count] > 1) {
        NSLog(@"Multiple matches found for object with remoteID: %@", remoteID);
        object = [[matches sortedArrayUsingSelector:@selector(updatedAt)] lastObject];
    }
    return object;
}

+(NSArray *)allObjectsToPersist
{
    NSIndexSet *indexesOfObjectsToPersist = [[self collection] indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isMemberOfClass:self]) {
            return NO;
        }
        if ([obj respondsToSelector:@selector(persist)]) {
            return [obj persist];
        }
        return NO;
    }];
    NSArray *objectsToPersist = [[self collection] objectsAtIndexes:indexesOfObjectsToPersist];
    return objectsToPersist;
}


#pragma mark - Core methods

// Override to prevent errors when dictionary contains values we have not declared as properties.
// Sometimes JSON will have unexpected keys, yo.

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error
{
    NSSet *propertyKeys = [[self class] propertyKeys];
    NSMutableSet *extraKeys = [NSMutableSet setWithArray:[dictionaryValue allKeys]];
    [extraKeys minusSet:propertyKeys];
    NSDictionary *existingPropertiesDict = [dictionaryValue mtl_dictionaryByRemovingEntriesWithKeys:extraKeys];
    self = [super initWithDictionary:existingPropertiesDict error:error];
    if (self.createdAt == nil) {
        self.createdAt = [NSDate date];
    }
    if (self.updatedAt == nil) {
        self.updatedAt = [NSDate date];
    }

    return self;
}

-(NSString *)remoteID
{
    return (NSString *)[self valueForKey:(NSString *)[[self class] remoteIdentifierKey]];
}

-(void)updateObjectUsingJSONDictionary:(NSDictionary *)jsonDictionary
{
    [self updateObjectUsingJSONDictionary:jsonDictionary ignoreNil:YES];
}

-(void)updateObjectUsingJSONDictionary:(NSDictionary *)jsonDictionary ignoreNil:(BOOL)ignoreNil
{
    NSError *initError;
    id newobject = [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:jsonDictionary error:&initError];
    // Retain values related to persistence. We only want to update API values
    [newobject performSelector:@selector(setCreatedAt:) withObject:self.createdAt];
    [newobject performSelector:@selector(setUpdatedAt:) withObject:self.updatedAt];
    BOOL persistenceVal = self.persist;
    if (ignoreNil) {
        [self mergeNonNilValuesForKeysFromModel:newobject];
    } else {
        [self mergeValuesForKeysFromModel:newobject];
    }
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
    NSMutableArray *collection = [[self class] collection];
    NSArray *remoteIds = [collection valueForKeyPath:@"remoteID"];
    BOOL remoteIdInCollection = [remoteIds containsObject:[self remoteID]];
    if (collection != nil && !remoteIdInCollection) {
        [collection addObject:self];
    }
}

- (void)mergeNonNilValuesForKeysFromModel:(MTLModel *)model {
	for (NSString *key in self.class.propertyKeys) {
        if ([model valueForKey:key] != nil) {
            [self mergeValueForKey:key fromModel:model];
        }
	}
}

#pragma mark - MTLModel (NSCoding)

+ (NSDictionary *)encodingBehaviorsByPropertyKey
{
    NSDictionary *excludedProperties = @{
                                         @"remoteID": @(MTLModelEncodingBehaviorExcluded),
                                         @"resourcePath": @(MTLModelEncodingBehaviorExcluded)
                                         };
    NSDictionary * encodingBehaviors = [[super encodingBehaviorsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:excludedProperties];
    return encodingBehaviors;
}

#pragma mark - SynchronizedObject protocol methods

// !!!: SFSynchronizedObject subclasses should override remoteResourceName. Do not trust class name to match remote type.
+ (NSString *)remoteResourceName
{
    return nil;
}

// !!!: Child classes must override remoteIdentifierKey
+ (NSString *)remoteIdentifierKey
{
    return nil;
}

+ (NSMutableArray *)collection
{
    // Child classes must override this
    return nil;
}

#pragma mark - NSKeyValueCoding protocol methods

- (id)valueForUndefinedKey:(NSString *)key
{
    return [NSNull null];
}

#pragma mark - Property accessor methods

- (void)setPersist:(BOOL)persist
{
    _persist = persist;
    [[NSNotificationCenter defaultCenter] postNotificationName:SFSynchronizedObjectPersistDidChange object:self];
}

- (BOOL)persist
{
    return _persist;
}

#pragma mark - Remote resource URI

- (NSString *)resourcePath
{
    if ([self.class remoteResourceName] && self.remoteID) {
        return [NSString pathWithComponents:@[@"/",[self.class remoteResourceName], self.remoteID]];
    }
    return nil;
}

@end
