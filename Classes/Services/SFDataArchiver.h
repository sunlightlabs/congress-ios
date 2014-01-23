//
//  SFDataArchiver.h
//  Congress
//
//  Created by Daniel Cloud on 1/18/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const SFDataArchiveSaveRequestNotification;
extern NSString *const SFDataArchiveSaveCompletedNotification;
extern NSString *const SFDataArchiveSaveFailureNotification;
extern NSString *const SFDataArchiveLoadedNotification;

@interface SFDataArchiver : NSObject

@property (nonatomic, strong) NSArray *archiveObjects;

+ (instancetype)dataArchiverWithObjectsToSave:(NSArray *)objectsArray;
- (BOOL)save;
- (id)load;

@end
