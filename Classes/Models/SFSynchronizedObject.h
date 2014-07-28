//
//  SFSynchronizedObject.h
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@protocol SFSynchronizedObject <NSObject>

@required
+ (NSString *)remoteResourceName;
+ (NSString *)remoteIdentifierKey;

@end


@interface SFSynchronizedObject : MTLModel <MTLJSONSerializing, SFSynchronizedObject>
@property (weak, nonatomic, readonly) NSString *remoteID;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
@property (nonatomic, readonly) BOOL persist;
@property (nonatomic, getter = isFollowed) BOOL followed;
@property (nonatomic, readonly) NSString *resourcePath;

+ (NSString *)remoteResourceName;
+ (NSString *)remoteIdentifierKey;
+ (instancetype)objectWithJSONDictionary:(NSDictionary *)externalRepresentation;
+ (instancetype)existingObjectWithRemoteID:(NSString *)remoteID;
+ (NSArray *)collection;
+ (NSArray *)allObjectsToPersist;

- (void)updateObjectUsingJSONDictionary:(NSDictionary *)externalRepresentation;
- (void)addToCollection;
- (void)removeFromCollection;

@end
