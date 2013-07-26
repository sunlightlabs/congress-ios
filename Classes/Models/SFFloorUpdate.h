//
//  SFFloorUpdate.h
//  Congress
//
//  Created by Daniel Cloud on 7/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFSynchronizedObject.h"

@interface SFFloorUpdate : SFSynchronizedObject

@property (nonatomic, strong) NSString *chamber;
@property (nonatomic, strong) NSString *update;
@property (nonatomic, strong) NSNumber *congress;
@property (nonatomic, strong) NSNumber *year;
@property (nonatomic, strong) NSDate *legislativeDay;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) NSArray *billIDs;
@property (nonatomic, strong) NSArray *rollIDs;
@property (nonatomic, strong) NSArray *legislatorIDs;

@end
