//
//  SFVoteService.m
//  Congress
//
//  Created by Daniel Cloud on 2/7/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFRollCallVoteService.h"
#import "SFCongressApiClient.h"
#import "SFRollCallVote.h"
#import "SFBill.h"

@implementation SFRollCallVoteService

#pragma mark - Fields

+ (NSArray *)fieldsArrayForVote {
    NSMutableSet *fields = [NSMutableSet setWithArray:[self fieldsArrayForListofVotes]];
    [fields addObjectsFromArray:@[@"voter_ids", @"breakdown"]];
    return [fields allObjects];
}

+ (NSString *)fieldsForVote {
    return [[self fieldsArrayForVote] componentsJoinedByString:@","];
}

+ (NSArray *)fieldsArrayForListofVotes {
    return @[@"roll_id", @"chamber", @"number", @"year", @"congress",
             @"voted_at", @"vote_type", @"roll_type", @"required", @"result", @"question",
             @"bill_id", @"bill"];
}

+ (NSString *)fieldsForListofVotes {
    return [[self fieldsArrayForListofVotes] componentsJoinedByString:@","];
}

#pragma mark - Retrieve vote by id

+ (void)getVoteWithId:(NSString *)rollId completionBlock:(void (^)(SFRollCallVote *vote))completionBlock {
    NSDictionary *params = @{
        @"roll_id": rollId,
        @"fields": [self fieldsForVote]
    };
    [[SFCongressApiClient sharedInstance] GET:@"votes" parameters:params success: ^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *responseArray = [self convertResponseToVotes:responseObject];
        SFRollCallVote *object = [responseArray lastObject];
        completionBlock(object);
    } failure: ^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(nil);
    }];
}

#pragma mark - Recent Votes

+ (void)recentVotesWithCompletionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentVotesWithCount:nil page:nil completionBlock:completionBlock];
}

+ (void)recentVotesWithPage:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentVotesWithCount:nil page:pageNumber completionBlock:completionBlock];
}

+ (void)recentVotesWithCount:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentVotesWithCount:count page:nil completionBlock:completionBlock];
}

+ (void)recentVotesWithCount:(NSNumber *)count page:(NSNumber *)pageNumber
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

+ (void)votesForBill:(NSString *)billId completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self votesForBill:billId count:nil page:nil completionBlock:completionBlock];
}

+ (void)votesForBill:(NSString *)billId page:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self votesForBill:billId count:nil page:pageNumber completionBlock:completionBlock];
}

+ (void)votesForBill:(NSString *)billId count:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self votesForBill:billId count:count page:nil completionBlock:completionBlock];
}

+ (void)votesForBill:(NSString *)billId count:(NSNumber *)count page:(NSNumber *)pageNumber
     completionBlock:(ResultsListCompletionBlock)completionBlock {
    if (!billId) {
        completionBlock(nil);
        CLS_LOG(@"billId argument is nil");
    }
    else {
        NSDictionary *params = @{
            @"bill_id": billId,
            @"order":@"voted_at",
            @"fields":[self fieldsForListofVotes],
            @"per_page" : (count == nil ? @20 : count),
            @"page" : (pageNumber == nil ? @1 : pageNumber)
        };
        [self lookupWithParameters:params completionBlock:completionBlock];
    }
}

#pragma mark - Votes for legislator

+ (void)votesForLegislator:(NSString *)legislatorId completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self votesForLegislator:legislatorId count:nil page:nil completionBlock:completionBlock];
}

+ (void)votesForLegislator:(NSString *)legislatorId page:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self votesForLegislator:legislatorId count:nil page:pageNumber completionBlock:completionBlock];
}

+ (void)votesForLegislator:(NSString *)legislatorId count:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self votesForLegislator:legislatorId count:count page:nil completionBlock:completionBlock];
}

+ (void)votesForLegislator:(NSString *)legislatorId count:(NSNumber *)count page:(NSNumber *)pageNumber
           completionBlock:(ResultsListCompletionBlock)completionBlock {
    NSString *voterIdSearchKey = [NSString stringWithFormat:@"voter_ids.%@__exists", legislatorId];
    NSDictionary *params = @{
        voterIdSearchKey: @"true",
        @"order":@"voted_at",
        @"fields":[self fieldsForVote],
        @"per_page" : (count == nil ? @20 : count),
        @"page" : (pageNumber == nil ? @1 : pageNumber)
    };
    [self lookupWithParameters:params completionBlock:completionBlock];
}

#pragma mark - base lookup

+ (void)lookupWithParameters:(NSDictionary *)params completionBlock:(ResultsListCompletionBlock)completionBlock {
    [[SFCongressApiClient sharedInstance] GET:@"votes" parameters:params success: ^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *responseArray = [self convertResponseToVotes:responseObject];
        completionBlock(responseArray);
    } failure: ^(NSURLSessionDataTask *task, NSError *error) {
        CLS_LOG(@"SFRollCallService error: %@", [error localizedDescription]);
        completionBlock(nil);
    }];
}

#pragma mark - Private methods

+ (NSArray *)convertResponseToVotes:(id)responseObject {
    NSArray *resultsArray = [responseObject valueForKeyPath:@"results"];

    if (![resultsArray count]) return @[];

    NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:resultsArray.count];

    for (NSDictionary *jsonElement in resultsArray) {
        SFRollCallVote *object = [SFRollCallVote existingObjectWithRemoteID:[jsonElement valueForKey:@"roll_id"]];
        if (object == nil) {
            object = [SFRollCallVote objectWithJSONDictionary:jsonElement];
        }
        else {
            [object updateObjectUsingJSONDictionary:jsonElement];
        }

        id billJSON = [jsonElement valueForKey:@"bill"];
        if (object.billId) {
            object.bill = [SFBill existingObjectWithRemoteID:object.billId];
        }
        if (!object.bill && (billJSON != [NSNull null])) {
            object.bill  = [SFBill objectWithJSONDictionary:billJSON];
        }

        [objectArray addObject:object];
    }
    NSArray *votesArray = [NSArray arrayWithArray:objectArray];
    return votesArray;
}

@end
