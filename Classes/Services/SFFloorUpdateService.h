//
//  SFFloorUpdateService.h
//  Congress
//
//  Created by Daniel Cloud on 7/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFHTTPClientUtils.h"

@class SFFloorUpdate;

@interface SFFloorUpdateService : NSObject

+ (void)lookupWithParameters:(NSDictionary *)params completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)recentUpdatesWithCompletionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)recentUpdatesWithPage:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)recentUpdatesWithCount:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)recentUpdatesWithCount:(NSNumber *)count page:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock;

@end
