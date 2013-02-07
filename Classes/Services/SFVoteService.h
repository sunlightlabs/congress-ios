//
//  SFVoteService.h
//  Congress
//
//  Created by Daniel Cloud on 2/7/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFHTTPClientUtils.h"
#import "SFSharedInstance.h"

@class SFBill;
@class SFVote;

@interface SFVoteService : NSObject

+(void)getVoteWithId:(NSString *)rollId completionBlock:(void(^)(SFVote *vote))completionBlock;
+(void)lookupWithParameters:(NSDictionary *)params completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)recentVotesWithCompletionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)recentVotesWithPage:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)recentVotesWithCount:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)recentVotesWithCount:(NSNumber *)count page:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)votesForBill:(NSString *)billId completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)votesForBill:(NSString *)billId page:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)votesForBill:(NSString *)billId count:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)votesForBill:(NSString *)billId count:(NSNumber *)count page:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock;

@end
