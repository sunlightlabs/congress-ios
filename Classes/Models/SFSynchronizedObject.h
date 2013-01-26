//
//  SFSynchronizedObject.h
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFSynchronizedObject <NSObject>

@required
+(NSString *)__remoteIdentifierKey;
+(NSMutableDictionary *)collection;

@end


@interface SFSynchronizedObject : MTLModel <SFSynchronizedObject>
@property (nonatomic, readonly) NSString *remoteID;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) NSDate *updatedAt;
@property BOOL persist;

+(instancetype)objectWithExternalRepresentation:(NSDictionary *)externalRepresentation;
+(instancetype)existingObjectWithRemoteID:(NSString *)remoteID;
+(NSMutableDictionary *)collection;
+(NSDictionary *)allObjectsToPersist;
-(void)updateObjectUsingExternalRepresentation:(NSDictionary *)externalRepresentation;
-(void)addObjectToCollection;

@end
