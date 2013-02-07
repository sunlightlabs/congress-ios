//
//  SFVoteService.m
//  Congress
//
//  Created by Daniel Cloud on 2/7/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFVoteService.h"
#import "SFCongressApiClient.h"
#import "SFVote.h"
#import "SFBill.h"

@implementation SFVoteService

#pragma mark - Fields

+(NSArray *)fieldsArrayForVote
{
    NSMutableSet *fields = [NSMutableSet setWithArray:[self fieldsArrayForListofVotes]];
    [fields addObjectsFromArray:@[ @"voter_ids" ]];
    return [fields allObjects];
}

+(NSString *)fieldsForVote
{
    return [[self fieldsArrayForVote] componentsJoinedByString:@","];
}

+(NSArray *)fieldsArrayForListofVotes
{
    return @[ @"roll_id", @"chamber", @"number", @"year", @"congress",
              @"voted_at", @"vote_type", @"roll_type", @"required", @"result",
              @"bill_id"];
}

+(NSString *)fieldsForListofVotes
{
    return [[self fieldsArrayForListofVotes] componentsJoinedByString:@","];
}

#pragma mark - Retrieve vote by id

+(void)getVoteWithId:(NSString *)rollId completionBlock:(void(^)(SFVote *vote))completionBlock
{
    NSDictionary *params = @{
                             @"roll_id": rollId,
                             @"fields": [self fieldsForVote]
                             };
    [[SFCongressApiClient sharedInstance] getPath:@"votes" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseArray = [self convertResponseToVotes:responseObject];
        SFVote *object = [responseArray lastObject];
        completionBlock(object);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil);
    }];
}

#pragma mark - Recent Votes

+(void)recentVotesWithCompletionBlock:(ResultsListCompletionBlock)completionBlock
{
    [self recentVotesWithCount:nil page:nil completionBlock:completionBlock];
}

+(void)recentVotesWithPage:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentVotesWithCount:nil page:pageNumber completionBlock:completionBlock];
}

+(void)recentVotesWithCount:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentVotesWithCount:count page:nil completionBlock:completionBlock];
}

+(void)recentVotesWithCount:(NSNumber *)count page:(NSNumber *)pageNumber
                        completionBlock:(ResultsListCompletionBlock)completionBlock {
    NSDictionary *params = @{
                             @"order":@"voted_at",
                             @"fields":[self fieldsForListofVotes],
                             @"per_page" : (count == nil ? @20 : count),
                             @"page" : (pageNumber == nil ? @1 : pageNumber)
                             };
    [self lookupWithParameters:params completionBlock:completionBlock];
}

#pragma mark - Votes for bill

+(void)votesForBill:(NSString *)billId completionBlock:(ResultsListCompletionBlock)completionBlock
{
    [self votesForBill:billId count:nil page:nil completionBlock:completionBlock];
}

+(void)votesForBill:(NSString *)billId page:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self votesForBill:billId count:nil page:pageNumber completionBlock:completionBlock];
}

+(void)votesForBill:(NSString *)billId count:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self votesForBill:billId count:count page:nil completionBlock:completionBlock];
}

+(void)votesForBill:(NSString *)billId count:(NSNumber *)count page:(NSNumber *)pageNumber
            completionBlock:(ResultsListCompletionBlock)completionBlock {
    NSDictionary *params = @{
                             @"bill_id": billId,
                             @"order":@"voted_at",
                             @"fields":[self fieldsForListofVotes],
                             @"per_page" : (count == nil ? @20 : count),
                             @"page" : (pageNumber == nil ? @1 : pageNumber)
                             };
    [self lookupWithParameters:params completionBlock:completionBlock];
}


#pragma mark - base lookup

+(void)lookupWithParameters:(NSDictionary *)params completionBlock:(ResultsListCompletionBlock)completionBlock
{
    [[SFCongressApiClient sharedInstance] getPath:@"votes" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseArray = [self convertResponseToVotes:responseObject];
        completionBlock(responseArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil);
    }];
}

#pragma mark - Private methods

+(NSArray *)convertResponseToVotes:(id)responseObject
{
    NSArray *resultsArray = [responseObject valueForKeyPath:@"results"];
    NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:resultsArray.count];

    for (NSDictionary *jsonElement in resultsArray) {
        SFVote *object = [SFVote objectWithExternalRepresentation:jsonElement];

        [objectArray addObject:object];
    }
    return [NSArray arrayWithArray:objectArray];
}

@end
