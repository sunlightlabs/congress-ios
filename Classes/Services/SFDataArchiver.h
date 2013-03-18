//
//  SFDataArchiver.h
//  Congress
//
//  Created by Daniel Cloud on 1/18/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SFDataArchiveRequestNotification;
extern NSString * const SFDataArchiveCompleteNotification;

@interface SFDataArchiver : NSObject

@property (nonatomic, retain) NSArray *archiveObjects;

+(instancetype)dataArchiverWithObjectsToSave:(NSArray *)objectsArray;
-(BOOL)save;
-(id)load;

@end
