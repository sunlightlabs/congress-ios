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
