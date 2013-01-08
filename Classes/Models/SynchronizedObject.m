//
//  SynchronizedObject.m
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SynchronizedObject.h"


@implementation SynchronizedObject

@dynamic createdAt;
@dynamic updatedAt;


-(void)awakeFromInsert
{
    [super awakeFromInsert];
    [self setCreatedAt:[NSDate date]];
    [self setUpdatedAt:[NSDate date]];
}

@end
