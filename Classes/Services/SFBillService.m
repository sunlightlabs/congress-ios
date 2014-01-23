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
#import "SFBillAction.h"

@implementation SFBillService

+ (NSArray *)fieldsArrayForBill {
    NSMutableSet *fields = [NSMutableSet setWithArray:[self fieldsArrayForListofBills]];
    [fields addObjectsFromArray:@[@"sponsor", @"cosponsor_ids", @"chamber", @"number", @"congress", @"actions",
                                  @"urls", @"last_version.urls", @"history", @"upcoming", @"summary_short"]];
    return [fields allObjects];
}

+ (NSString *)fieldsForBill {
    return [[self fieldsArrayForBill] componentsJoinedByString:@","];
}

+ (NSArray *)fieldsArrayForListofBills {
    return @[@"bill_id", @"number", @"congress", @"bill_type", @"official_title",
             @"short_title", @"last_action_at", @"last_action", @"introduced_on",
             @"sponsor_id", @"last_vote_at"];
}

+ (NSString *)fieldsForListofBills {
    return [[self fieldsArrayForListofBills] componentsJoinedByString:@","];
}

+ (void)billWithId:(NSString *)billId completionBlock:(void (^)(SFBill *bill))completionBlock {
    if (billId == nil) {
        completionBlock(nil);
        return;
    }

    NSDictionary *params = @{
        @"bill_id":billId,
        @"fields":[self fieldsForBill]
    };

    [[SFCongressApiClient sharedInstance] GET:@"bills" parameters:params success: ^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *billsArray = [self convertResponseToBills:responseObject];
        SFBill *bill = [billsArray lastObject];
        completionBlock(bill);
    } failure: ^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(nil);
    }];
}

+ (void)billsWithIds:(NSArray *)billIds completionBlock:(ResultsListCompletionBlock)completionBlock {
    NSDate *unfreshDate = [NSDate dateWithTimeIntervalSinceNow:-600];
    NSPredicate *freshlyStoredPred = [NSPredicate predicateWithFormat:@"(billId IN %@) && (updatedAt >= %@)", billIds, unfreshDate];
    NSArray *storedObjects = [[SFBill collection] filteredArrayUsingPredicate:freshlyStoredPred];
    NSSet *storedObjectIds = [NSSet setWithArray:[storedObjects valueForKeyPath:@"billId"]];
    NSMutableSet *retrievalSet = [NSMutableSet setWithArray:billIds];
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:YES];
    [retrievalSet minusSet:storedObjectIds];

    if ([retrievalSet count] > 0) {
        NSDictionary *params = @{
            @"bill_id__in":[[retrievalSet allObjects] componentsJoinedByString:@"|"],
            @"fields":[self fieldsForBill]
        };

        [[SFCongressApiClient sharedInstance] GET:@"bills" parameters:params success: ^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *fetchedBills = [self convertResponseToBills:responseObject];
            NSMutableArray *allResults = nil;
            if (fetchedBills && [fetchedBills count] > 0) {
                allResults = [NSMutableArray arrayWithArray:fetchedBills];
                [allResults addObjectsFromArray:storedObjects];
                [allResults sortUsingDescriptors:@[sortDes]];
            }
            completionBlock(allResults);
        } failure: ^(NSURLSessionDataTask *task, NSError *error) {
            completionBlock(nil);
        }];
    }
    else {
        completionBlock([storedObjects sortedArrayUsingDescriptors:@[sortDes]]);
    }
}

+ (void)lookupWithParameters:(NSDictionary *)params completionBlock:(ResultsListCompletionBlock)completionBlock {
    [[SFCongressApiClient sharedInstance] GET:@"bills" parameters:params success: ^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *billsArray = [self convertResponseToBills:responseObject];
        completionBlock(billsArray);
    } failure: ^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(nil);
    }];
}

#pragma mark - Bills with type and number

+ (void)billsWithType:(NSString *)type number:(NSNumber *)number
      completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self billsWithType:type number:number count:nil page:nil completionBlock:completionBlock];
}

+ (void)billsWithType:(NSString *)type number:(NSNumber *)number page:(NSNumber *)pageNumber
      completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self billsWithType:type number:number count:nil page:pageNumber completionBlock:completionBlock];
}

+ (void)billsWithType:(NSString *)type number:(NSNumber *)number count:(NSNumber *)count
      completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self billsWithType:type number:number count:count page:nil completionBlock:completionBlock];
}

+ (void)billsWithType:(NSString *)type number:(NSNumber *)number count:(NSNumber *)count page:(NSNumber *)pageNumber
      completionBlock:(ResultsListCompletionBlock)completionBlock {
    NSDictionary *params = @{
        @"bill_type":type,
        @"number": number, @"order": @"congress",
        @"fields":[self fieldsForBill],
        @"per_page" : (count == nil ? @20 : count),
        @"page" : (pageNumber == nil ? @1 : pageNumber)
    };
    [self lookupWithParameters:params completionBlock:completionBlock];
}

#pragma mark - Bills for Sponsor Id

+ (void)billsWithSponsorId:(NSString *)sponsorId completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self billsWithSponsorId:sponsorId count:nil page:nil completionBlock:completionBlock];
}

+ (void)billsWithSponsorId:(NSString *)sponsorId page:(NSNumber *)pageNumber
           completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self billsWithSponsorId:sponsorId count:nil page:pageNumber completionBlock:completionBlock];
}

+ (void)billsWithSponsorId:(NSString *)sponsorId count:(NSNumber *)count
           completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self billsWithSponsorId:sponsorId count:count page:nil completionBlock:completionBlock];
}

+ (void)billsWithSponsorId:(NSString *)sponsorId count:(NSNumber *)count page:(NSNumber *)pageNumber
           completionBlock:(ResultsListCompletionBlock)completionBlock {
    NSDictionary *params = @{
        @"sponsor_id":sponsorId,
        @"order": @"last_action_at",
        @"fields":[self fieldsForBill],
        @"per_page" : (count == nil ? @20 : count),
        @"page" : (pageNumber == nil ? @1 : pageNumber)
    };
    [self lookupWithParameters:params completionBlock:completionBlock];
}

#pragma mark - Recently Introduced Bills

+ (void)recentlyIntroducedBillsWithCompletionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentlyIntroducedBillsWithCount:nil page:nil completionBlock:completionBlock];
}

+ (void)recentlyIntroducedBillsWithPage:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentlyIntroducedBillsWithCount:nil page:pageNumber completionBlock:completionBlock];
}

+ (void)recentlyIntroducedBillsWithCount:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentlyIntroducedBillsWithCount:count page:nil completionBlock:completionBlock];
}

+ (void)recentlyIntroducedBillsWithCount:(NSNumber *)count page:(NSNumber *)pageNumber
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

+ (void)recentlyActedOnBillsWithCompletionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentlyActedOnBillsWithCount:nil page:nil completionBlock:completionBlock];
}

+ (void)recentlyActedOnBillsWithCompletionBlock:(ResultsListCompletionBlock)completionBlock
                                excludeNewBills:(BOOL)excludeNewBills {
    [self recentlyActedOnBillsWithCount:nil page:nil completionBlock:completionBlock excludeNewBills:excludeNewBills];
}

+ (void)recentlyActedOnBillsWithPage:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentlyActedOnBillsWithCount:nil page:pageNumber completionBlock:completionBlock];
}

+ (void)recentlyActedOnBillsWithPage:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock
                     excludeNewBills:(BOOL)excludeNewBills {
    [self recentlyActedOnBillsWithCount:nil page:pageNumber completionBlock:completionBlock excludeNewBills:excludeNewBills];
}

+ (void)recentlyActedOnBillsWithCount:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentlyActedOnBillsWithCount:count page:nil completionBlock:completionBlock];
}

+ (void)recentlyActedOnBillsWithCount:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock
                      excludeNewBills:(BOOL)excludeNewBills {
    [self recentlyActedOnBillsWithCount:count page:nil completionBlock:completionBlock excludeNewBills:excludeNewBills];
}

+ (void)recentlyActedOnBillsWithCount:(NSNumber *)count page:(NSNumber *)pageNumber
                      completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentlyActedOnBillsWithCount:count page:pageNumber completionBlock:completionBlock excludeNewBills:NO];
}

+ (void)recentlyActedOnBillsWithCount:(NSNumber *)count page:(NSNumber *)pageNumber
                      completionBlock:(ResultsListCompletionBlock)completionBlock
                      excludeNewBills:(BOOL)excludeNewBills {
    NSString *excludeActions = excludeNewBills ? @"true" : @"false";
    NSDictionary *params = @{
        @"history.active": excludeActions,
        @"order": @"last_action_at",
        @"fields":[self fieldsForListofBills],
        @"per_page" : (count == nil ? @20 : count),
        @"page" : (pageNumber == nil ? @1 : pageNumber)
    };
    [self lookupWithParameters:params completionBlock:completionBlock];
}

#pragma mark - Recent Laws

+ (void)recentLawsWithCompletionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentLawsWithCount:nil page:nil completionBlock:completionBlock];
}

+ (void)recentLawsWithPage:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentLawsWithCount:nil page:pageNumber completionBlock:completionBlock];
}

+ (void)recentLawsWithCount:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self recentLawsWithCount:count page:nil completionBlock:completionBlock];
}

+ (void)recentLawsWithCount:(NSNumber *)count page:(NSNumber *)pageNumber
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
+ (void)searchBillText:(NSString *)searchString completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self searchBillText:searchString count:nil page:nil completionBlock:completionBlock];
}

+ (void)searchBillText:(NSString *)searchString page:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self searchBillText:searchString count:nil page:pageNumber completionBlock:completionBlock];
}

+ (void)searchBillText:(NSString *)searchString count:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self searchBillText:searchString count:count page:nil completionBlock:completionBlock];
}

+ (void)searchBillText:(NSString *)searchString count:(NSNumber *)count page:(NSNumber *)pageNumber
       completionBlock:(ResultsListCompletionBlock)completionBlock {
    NSDictionary *params = @{
        @"query":[searchString stringByTrimmingLeadingAndTrailingWhitespaceAndNewlineCharacters],
        @"fields":[self fieldsForListofBills],
        @"per_page" : (count == nil ? @20 : count),
        @"page" : (pageNumber == nil ? @1 : pageNumber),
        @"search.profile": @"title_summary_recency"
    };

    [[SFCongressApiClient sharedInstance] GET:@"bills/search" parameters:params success: ^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *billsArray = [self convertResponseToBills:responseObject];
        completionBlock(billsArray);
    } failure: ^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(nil);
    }];
}

#pragma mark - Private Methods
+ (NSArray *)convertResponseToBills:(id)responseObject {
    NSArray *resultsArray = [responseObject valueForKeyPath:@"results"];

    if (![resultsArray count]) return @[];

    NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:resultsArray.count];

    for (NSDictionary *jsonElement in resultsArray) {
        SFBill *bill = [SFBill objectWithJSONDictionary:jsonElement];

        if (!bill.sponsor && bill.sponsorId) {
            SFLegislator *sponsor = [SFLegislator existingObjectWithRemoteID:bill.sponsorId];
            if (sponsor) {
                bill.sponsor = sponsor;
            }
        }

        if (bill.actions) {
            for (SFBillAction *billAction in bill.actions) {
                billAction.bill = bill;
            }
        }
        if (bill.lastAction) {
            bill.lastAction.bill = bill;
        }

        [objectArray addObject:bill];
    }
    return [NSArray arrayWithArray:objectArray];
}

@end
