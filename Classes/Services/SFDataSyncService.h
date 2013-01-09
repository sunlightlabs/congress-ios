//
//  SFSynchronizedObjectService.h
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSharedInstance.h"

@interface SFDataSyncService : NSObject <SFSharedInstance>

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(id)createSynchronizedObjectWithClass:(Class)class JSONValues:(NSDictionary *)jsonValues;

@end
