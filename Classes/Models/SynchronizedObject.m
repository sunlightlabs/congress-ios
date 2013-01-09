//
//  SynchronizedObject.m
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//
// TODO: Implementation of setting updatedAt on saving existing object. React to NSManagedObjectContextWillSaveNotification

#import "SynchronizedObject.h"


@implementation SynchronizedObject

@dynamic createdAt;
@dynamic updatedAt;

-(id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context withJSONValues:(NSDictionary *)jsonValues
{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    [self setValuesForKeysWithJSONDictionary:jsonValues];

    return self;
}


-(void)awakeFromInsert
{
    [super awakeFromInsert];
    [self setCreatedAt:[NSDate date]];
    [self setUpdatedAt:[NSDate date]];
}

@end
