//
//  SynchronizedObject.h
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol SynchronizedObject <NSObject>

@required
@property (nonatomic, readonly) NSString *remoteID;

+(NSString *)__remoteIdentifierKey;

@end


@interface SynchronizedObject : NSManagedObject <SynchronizedObject>

@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) NSDate *updatedAt;
@property BOOL persist;

+(id)objectWithDictionary:(NSDictionary *)dictionary;
+(id)objectWithRemoteID:(NSString *)remoteID;
+(id)existingObjectWithRemoteID:(NSString *)remoteID;

@end
