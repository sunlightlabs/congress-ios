//
//  SFDataArchiver.m
//  Congress
//
//  Created by Daniel Cloud on 1/18/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFDataArchiver.h"

NSString * const SFDataArchiveRequestNotification = @"SFDataArchiveRequestNotification";
NSString * const SFDataArchiveCompleteNotification = @"SFDataArchiveCompleteNotification";
NSString * const SFDataArchiveFailureNotification = @"SFDataArchiveFailureNotification";

@implementation SFDataArchiver

@synthesize archiveObjects = _archiveObjects;

static NSString *kDataArchiveFilePath = nil;

#pragma mark - Class methods

+(NSString *)dataArchive
{
    if (kDataArchiveFilePath == nil) {
        NSURL *archiveURL = [[[UIApplication sharedApplication] documentsDirectoryURL] URLByAppendingPathComponent:@"archive.data"];
        kDataArchiveFilePath = [archiveURL path];
    }
    return kDataArchiveFilePath;
}

+(instancetype)dataArchiverWithObjectsToSave:(NSArray *)objectsArray
{
    SFDataArchiver *instance = [[self alloc] init];
    instance->_archiveObjects = objectsArray;

    return instance;
}

#pragma mark - Save/load objects

-(BOOL)save
{
    NSString *archiveFilePath = [[self class] dataArchive];
    BOOL saved = [NSKeyedArchiver archiveRootObject:_archiveObjects toFile:archiveFilePath];
    NSString *notificationName = saved ? SFDataArchiveCompleteNotification : SFDataArchiveFailureNotification;
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
    return saved;
}

-(NSArray *)load
{
    return (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:[[self class] dataArchive]];
}

@end
