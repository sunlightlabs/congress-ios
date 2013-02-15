//
//  SFBillService.m
//  Congress
//
//  Created by Daniel Cloud on 11/19/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//
// TODO: Define a block for default failure handling.

#import "SFBillService.h"
#import "SFCongressApiClient.h"
#import "SFBill.h"
#import "SFLegislator.h"

@implementation SFBillService

+(NSArray *)fieldsArrayForBill
{
    NSMutableSet *fields = [NSMutableSet setWithArray:[self fieldsArrayForListofBills]];
    [fields addObjectsFromArray:@[ @"sponsor", @"chamber", @"number", @"congress", @"actions",
                                   @"urls", @"last_version.urls", @"history", @"upcoming", @"summary" ]];
    return [fields allObjects];
}

+(NSString *)fieldsForBill
{
    return [[self fieldsArrayForBill] componentsJoinedByString:@","];
}

+(NSArray *)fieldsArrayForListofBills
{
    return @[ @"bill_id", @"bill_type", @"official_title",
              @"short_title", @"last_action_at", @"introduced_on",
              @"sponsor_id", @"last_vote_at" ];
}

+(NSString *)fieldsForListofBills
{
    return [[self fieldsArrayForListofBills] componentsJoinedByString:@","];
}


+(void)getBillWithId:(NSString *)bill_id completionBlock:(void (^)(SFBill *bill))completionBlock
{
    
    NSDictionary *params = @{
        @"bill_id":bill_id,
        @"fields":[self fieldsForBill]
    };

    [[SFCongressApiClient sharedInstance] getPath:@"bills" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *billsArray = [self convertResponseToBills:responseObject];
        SFBill *bill = [billsArray lastObject];
        completionBlock(bill);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil);
    }];

}

+(void)lookupWithParameters:(NSDictionary *)params completionBlock:(ResultsListCompletionBlock)completionBlock
{
    [[SFCongressApiClient sharedInstance] getPath:@"bills" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *billsArray = [self convertResponseToBills:responseObject];
        completionBlock(billsArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil);
    }];
}

#pragma mark - Recently Introduced Bills

+(void)recentlyIntroducedBillsWithCompletionBlock:(ResultsListCompletionBlock)completionBlock
{
    [self recentlyIntroducedBillsWithCount:nil page:nil completionBlock:completionBlock];
}

+(void)recentlyIntroducedBillsWithPage:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentlyIntroducedBillsWithCount:nil page:pageNumber completionBlock:completionBlock];
}

+(void)recentlyIntroducedBillsWithCount:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentlyIntroducedBillsWithCount:count page:nil completionBlock:completionBlock];
}

+(void)recentlyIntroducedBillsWithCount:(NSNumber *)count page:(NSNumber *)pageNumber
                                completionBlock:(ResultsListCompletionBlock)completionBlock {
    NSDictionary *params = @{
        @"order":@"introduced_on",
        @"fields":[self fieldsForListofBills],
        @"per_page" : (count == nil ? @20 : count),
        @"page" : (pageNumber == nil ? @1 : pageNumber)
    };
    [self lookupWithParameters:params completionBlock:completionBlock];
}

#pragma mark - Bills recently acted on

+(void)recentlyActedOnBillsWithCompletionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentlyActedOnBillsWithCount:nil page:nil completionBlock:completionBlock];
}

+(void)recentlyActedOnBillsWithPage:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentlyActedOnBillsWithCount:nil page:pageNumber completionBlock:completionBlock];
}

+(void)recentlyActedOnBillsWithCount:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentlyActedOnBillsWithCount:count page:nil completionBlock:completionBlock];
}

+(void)recentlyActedOnBillsWithCount:(NSNumber *)count page:(NSNumber *)pageNumber
                                completionBlock:(ResultsListCompletionBlock)completionBlock {
    NSDictionary *params = @{
        @"order": @"last_action_at",
        @"fields":[self fieldsForListofBills],
        @"per_page" : (count == nil ? @20 : count),
        @"page" : (pageNumber == nil ? @1 : pageNumber)
    };
    [self lookupWithParameters:params completionBlock:completionBlock];
}

#pragma mark - Recent Laws

+(void)recentLawsWithCompletionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentLawsWithCount:nil page:nil completionBlock:completionBlock];
}

+(void)recentLawsWithPage:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentLawsWithCount:nil page:pageNumber completionBlock:completionBlock];
}

+(void)recentLawsWithCount:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentLawsWithCount:count page:nil completionBlock:completionBlock];
}

+(void)recentLawsWithCount:(NSNumber *)count page:(NSNumber *)pageNumber
                   completionBlock:(ResultsListCompletionBlock)completionBlock {
    NSDictionary *params = @{
        @"order": @"history.enacted_on",
        @"fields":[self fieldsForListofBills],
        @"history.enacted": @"true",
        @"per_page" : (count == nil ? @20 : count),
        @"page" : (pageNumber == nil ? @1 : pageNumber)
    };
    [self lookupWithParameters:params completionBlock:completionBlock];    
}

#pragma mark - Bill full text search
+ (void)searchBillText:(NSString *)searchString completionBlock:(ResultsListCompletionBlock)completionBlock
{
    [self searchBillText:searchString count:nil page:nil completionBlock:completionBlock];
}

+ (void)searchBillText:(NSString *)searchString page:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock
{
    [self searchBillText:searchString count:nil page:pageNumber completionBlock:completionBlock];
}

+ (void)searchBillText:(NSString *)searchString count:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock
{
    [self searchBillText:searchString count:count page:nil completionBlock:completionBlock];
}

+ (void)searchBillText:(NSString *)searchString count:(NSNumber *)count page:(NSNumber *)pageNumber
           completionBlock:(ResultsListCompletionBlock)completionBlock {
    NSDictionary *params = @{
                             @"query":[searchString stringByTrimmingLeadingAndTrailingWhitespaceAndNewlineCharacters],
                             @"fields":[self fieldsForListofBills],
                             @"per_page" : (count == nil ? @20 : count),
                             @"page" : (pageNumber == nil ? @1 : pageNumber)
                             };

    [[SFCongressApiClient sharedInstance] getPath:@"bills/search" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *billsArray = [self convertResponseToBills:responseObject];
        completionBlock(billsArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil);
    }];
}

#pragma mark - Private Methods
+(NSArray *)convertResponseToBills:(id)responseObject
{
    NSArray *resultsArray = [responseObject valueForKeyPath:@"results"];
    NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:resultsArray.count];

    for (NSDictionary *jsonElement in resultsArray) {
        SFBill *bill = [SFBill objectWithExternalRepresentation:jsonElement];

        id sponsorJson = [jsonElement valueForKey:@"sponsor"];
        SFLegislator *sponsor = nil;
        if (sponsorJson != [NSNull null]) {
            sponsor = [SFLegislator objectWithExternalRepresentation:sponsorJson];
        }
        else if (bill.sponsorId)
        {
            sponsor = [SFLegislator existingObjectWithRemoteID:bill.sponsorId];
        }
        bill.sponsor = sponsor;

        [objectArray addObject:bill];
    }
    return [NSArray arrayWithArray:objectArray];
    
}

@end
