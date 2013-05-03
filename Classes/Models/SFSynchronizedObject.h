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
+(NSMutableArray *)collection;

@end


@interface SFSynchronizedObject : MTLModel <MTLJSONSerializing, SFSynchronizedObject>
@property (nonatomic, readonly) NSString *remoteID;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) NSDate *updatedAt;
@property BOOL persist;

+(instancetype)objectWithJSONDictionary:(NSDictionary *)externalRepresentation;
+(instancetype)existingObjectWithRemoteID:(NSString *)remoteID;
+(NSMutableArray *)collection;
+(NSArray *)allObjectsToPersist;
-(void)updateObjectUsingJSONDictionary:(NSDictionary *)externalRepresentation;
-(void)addObjectToCollection;

@end
