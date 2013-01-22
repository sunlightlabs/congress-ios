//
//  SFDataArchiver.m
//  Congress
//
//  Created by Daniel Cloud on 1/18/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFDataArchiver.h"

@implementation SFDataArchiver

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

+(instancetype)initWithObjectsToSave:(NSArray *)objectsArray
{
    SFDataArchiver *instance = [[self alloc] init];
    instance->_saveObjects = objectsArray;

    return instance;
}

#pragma mark - Save/load objects

-(BOOL)save
{
    NSString *archiveFilePath = [[self class] dataArchive];
    BOOL saved = [NSKeyedArchiver archiveRootObject:self->_saveObjects toFile:archiveFilePath];
    return saved;
}

-(NSArray *)load
{
    return (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithFile:[[self class] dataArchive]];
}

@end
