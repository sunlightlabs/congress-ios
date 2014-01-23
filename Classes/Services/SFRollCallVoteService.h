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
@class SFRollCallVote;

@interface SFRollCallVoteService : NSObject

+ (void)getVoteWithId:(NSString *)rollId completionBlock:(void (^) (SFRollCallVote *vote))completionBlock;
+ (void)lookupWithParameters:(NSDictionary *)params completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)recentVotesWithCompletionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)recentVotesWithPage:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)recentVotesWithCount:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)recentVotesWithCount:(NSNumber *)count page:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)votesForBill:(NSString *)billId completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)votesForBill:(NSString *)billId page:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)votesForBill:(NSString *)billId count:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)votesForBill:(NSString *)billId count:(NSNumber *)count page:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)votesForLegislator:(NSString *)legislatorId completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)votesForLegislator:(NSString *)legislatorId page:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)votesForLegislator:(NSString *)legislatorId count:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)votesForLegislator:(NSString *)legislatorId count:(NSNumber *)count page:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock;

@end
