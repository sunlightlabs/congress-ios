//
//  SFCommitteeService.h
//  Congress
//
//  Created by Jeremy Carbaugh on 7/19/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFCommittee.h"

@interface SFCommitteeService : NSObject

+ (void)committeesWithCompletionBlock:(void(^)(NSArray *committees))completionBlock;
+ (void)committeesAndSubcommitteesWithCompletionBlock:(void(^)(NSArray *committees))completionBlock;
+ (void)subcommitteesWithCompletionBlock:(void(^)(NSArray *committees))completionBlock;
+ (void)committeeWithId:(NSString *)committeeId completionBlock:(void(^)(SFCommittee *committee))completionBlock;

@end
