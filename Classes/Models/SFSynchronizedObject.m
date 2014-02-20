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
#import "SFSynchronizedObjectManager.h"

@implementation SFSynchronizedObject
{
    SFSynchronizedObjectManager *_manager;
}

@synthesize createdAt;
@synthesize updatedAt;
@synthesize persist = _persist;

#pragma mark - MTLModel Class Methods

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary dictionary];
}

+ (NSDictionary *)dictionaryValueFromArchivedExternalRepresentation:(NSDictionary *)externalRepresentation version:(NSUInteger)fromVersion {
    NSLog(@"Updating %@ object from version %lu", NSStringFromClass([self class]), (unsigned long)fromVersion);
    Class modelClass = [self class];
    if (fromVersion == 1) {
        NSError *initError;
        id object = [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:externalRepresentation error:&initError];
        return [object dictionaryValue];
    }
    else {
        return nil;
    }
}

+ (instancetype)objectWithJSONDictionary:(NSDictionary *)jsonDictionary {
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
        else if (jsonDictionary != nil) {
            NSError *initError;
            object = [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:jsonDictionary error:&initError];
            [[SFSynchronizedObjectManager sharedInstance] addObject:object];
        }
    }
    return object;
}

#pragma mark - SFSynchronizedObject Class Methods

+ (NSArray *)collection {
    return [[SFSynchronizedObjectManager sharedInstance] objectsForClass:[self class]];
}

+ (instancetype)existingObjectWithRemoteID:(NSString *)remoteID {
    if (!remoteID) {
        return nil;
    }
    id object = [[SFSynchronizedObjectManager sharedInstance] objectWithRemoteID:remoteID];
    return object;
}

+ (NSArray *)allObjectsToPersist {
    NSArray *objectsToPersist = [[SFSynchronizedObjectManager sharedInstance] allFollowedObjectsForClass:[self class]];
    return objectsToPersist;
}

#pragma mark - MTLModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self) {
        _manager = [SFSynchronizedObjectManager sharedInstance];
        if (self.createdAt == nil) {
            self.createdAt = [NSDate date];
        }
        if (self.updatedAt == nil) {
            self.updatedAt = [NSDate date];
        }
    }

    return self;
}

- (void)mergeValuesForKeysFromModel:(MTLModel *)model {
    for (NSString *key in self.class.propertyKeys) {
        id newValue = [model valueForKey:key];
        // Don't clobber existing values with newValue if nil.
        if (key && newValue)
        {
            if (![key isEqualToString:@"followed"]) {
                [self mergeValueForKey:key fromModel:model];
            }
        }
    }
}

- (void)dealloc {
    @try {
        [self removeObserver:[SFSynchronizedObjectManager sharedInstance] forKeyPath:@"followed"];
    }
    @catch (NSException *__unused exception)
    {
    }
}

#pragma mark - SFSynchronizedObject methods

- (void)updateObjectUsingJSONDictionary:(NSDictionary *)jsonDictionary {
    NSError *initError;
    id newobject = [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:jsonDictionary error:&initError];
    // Retain values related to persistence. We only want to update API values
    [newobject performSelector:@selector(setCreatedAt:) withObject:self.createdAt];
    [newobject performSelector:@selector(setUpdatedAt:) withObject:self.updatedAt];
    BOOL persistenceVal = [self isFollowed];
    [self mergeValuesForKeysFromModel:newobject];
    self.followed = persistenceVal;
    @try {
        [self performSelector:@selector(setUpdatedAt:) withObject:[NSDate date]];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error setting updatedAt: %@", [exception reason]);
    }
}

- (void)addToCollection {
    [_manager addObject:self];
}

- (void)removeFromCollection {
    [_manager removeObject:self];
}

#pragma mark - Property Accessors

- (NSString *)remoteID {
    return (NSString *)[self valueForKey:(NSString *)[[self class] remoteIdentifierKey]];
}

- (BOOL)isFollowed {
    return _persist;
}

- (void)setFollowed:(BOOL)follow {
    _persist = follow;
}

#pragma mark - MTLModel (NSCoding)

+ (NSDictionary *)encodingBehaviorsByPropertyKey {
    NSDictionary *excludedProperties = @{
        @"followed": @(MTLModelEncodingBehaviorExcluded),
        @"remoteID": @(MTLModelEncodingBehaviorExcluded),
        @"resourcePath": @(MTLModelEncodingBehaviorExcluded)
    };
    NSDictionary *encodingBehaviors = [[super encodingBehaviorsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:excludedProperties];
    return encodingBehaviors;
}

#pragma mark - SynchronizedObject protocol methods

// !!!: SFSynchronizedObject subclasses should override remoteResourceName. Do not trust class name to match remote type.
+ (NSString *)remoteResourceName {
    return nil;
}

// !!!: Child classes must override remoteIdentifierKey
+ (NSString *)remoteIdentifierKey {
    return nil;
}

#pragma mark - NSKeyValueCoding protocol methods

- (id)valueForUndefinedKey:(NSString *)key {
    return [NSNull null];
}

#pragma mark - Remote resource URI

- (NSString *)resourcePath {
    if ([self.class remoteResourceName] && self.remoteID) {
        return [NSString pathWithComponents:@[@"/", [self.class remoteResourceName], self.remoteID]];
    }
    return nil;
}

@end
