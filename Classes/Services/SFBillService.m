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
#import "Bill.h"
#import "Legislator.h"

@implementation SFBillService

+(NSArray *)fieldsArrayForBill
{
    NSMutableSet *fields = [NSMutableSet setWithArray:[self fieldsArrayForListofBills]];
    [fields addObject:@"sponsor"];
    return [fields allObjects];
}

+(NSString *)fieldsForBill
{
    return [[self fieldsArrayForBill] componentsJoinedByString:@","];
}

+(NSArray *)fieldsArrayForListofBills
{
    return @[@"bill_id",@"official_title",@"short_title",@"last_action_at", @"introduced_on", @"sponsor_id", @"last_vote_at"];
}

+(NSString *)fieldsForListofBills
{
    return [[self fieldsArrayForListofBills] componentsJoinedByString:@","];
}


+(void)getBillWithId:(NSString *)bill_id success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
    
    NSDictionary *params = @{
        @"bill_id":bill_id,
        @"fields":[self fieldsForBill]
    };

//    Bill *bill = [Bill objectWithRemoteID:bill_id];
//
//    if (bill != nil) {
//        success(nil, bill);
//    }
//    else
//    {
        [[SFCongressApiClient sharedInstance] getPath:@"bills" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *billsArray = [self convertResponseToBills:responseObject];
            Bill *bill = [billsArray lastObject];

            if (success) {
                success((AFJSONRequestOperation *)operation, bill);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                failure((AFJSONRequestOperation *)operation, error);
            }
        }];
//    }

}

+(void)searchWithParameters:(NSDictionary *)query_params success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
    [[SFCongressApiClient sharedInstance] getPath:@"bills" parameters:query_params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *billsArray = [self convertResponseToBills:responseObject];
        if (success) {
            success((AFJSONRequestOperation *)operation, billsArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure((AFJSONRequestOperation *)operation, error);
        }
    }];
}

#pragma mark - Recently Introduced Bills

+(void)recentlyIntroducedBillsWithSuccess:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
    [self recentlyIntroducedBillsWithCount:nil page:nil success:success failure:failure];
}

+(void)recentlyIntroducedBillsWithPage:(NSNumber *)pageNumber success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
    [self recentlyIntroducedBillsWithCount:nil page:pageNumber success:success failure:failure];
}

+(void)recentlyIntroducedBillsWithCount:(NSNumber *)count success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
    [self recentlyIntroducedBillsWithCount:count page:nil success:success failure:failure];
}

+(void)recentlyIntroducedBillsWithCount:(NSNumber *)count page:(NSNumber *)pageNumber
                                success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
    NSDictionary *params = @{
        @"order":@"introduced_on",
        @"fields":[self fieldsForListofBills],
        @"per_page" : (count == nil ? @20 : count),
        @"page" : (pageNumber == nil ? @1 : pageNumber)
    };
    [self searchWithParameters:params success:success failure:failure];
}

#pragma mark - Bills recently acted on

+(void)recentlyActedOnBillsWithSuccess:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
    [self recentlyActedOnBillsWithCount:nil page:nil success:success failure:failure];
}

+(void)recentlyActedOnBillsWithPage:(NSNumber *)pageNumber success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
    [self recentlyActedOnBillsWithCount:nil page:pageNumber success:success failure:failure];
}

+(void)recentlyActedOnBillsWithCount:(NSNumber *)count success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
    [self recentlyActedOnBillsWithCount:count page:nil success:success failure:failure];
}

+(void)recentlyActedOnBillsWithCount:(NSNumber *)count page:(NSNumber *)pageNumber
                                success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
    NSDictionary *params = @{
        @"order": @"last_action_at",
        @"fields":[self fieldsForListofBills],
        @"per_page" : (count == nil ? @20 : count),
        @"page" : (pageNumber == nil ? @1 : pageNumber)
    };
    [self searchWithParameters:params success:success failure:failure];
}

#pragma mark - Recent Laws

+(void)recentLawsWithSuccess:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
    [self recentLawsWithCount:nil page:nil success:success failure:failure];
}

+(void)recentLawsWithPage:(NSNumber *)pageNumber success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
    [self recentLawsWithCount:nil page:pageNumber success:success failure:failure];
}

+(void)recentLawsWithCount:(NSNumber *)count success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
    [self recentLawsWithCount:count page:nil success:success failure:failure];
}

+(void)recentLawsWithCount:(NSNumber *)count page:(NSNumber *)pageNumber
                   success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
    NSDictionary *params = @{
        @"order": @"history.enacted_on",
        @"fields":[self fieldsForListofBills],
        @"history.enacted": @"true",
        @"per_page" : (count == nil ? @20 : count),
        @"page" : (pageNumber == nil ? @1 : pageNumber)
    };
    [self searchWithParameters:params success:success failure:failure];    
}

#pragma mark - Private Methods
+(NSArray *)convertResponseToBills:(id)responseObject
{
    NSArray *resultsArray = [responseObject valueForKeyPath:@"results"];
    NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:resultsArray.count];

    for (NSDictionary *jsonElement in resultsArray) {
        Bill *bill = [[Bill alloc] initWithExternalRepresentation:jsonElement];
        if ([jsonElement valueForKey:@"sponsor"]) {

            Legislator *sponsor = [Legislator existingObjectWithRemoteID:[jsonElement valueForKeyPath:@"sponsor_id"]];
            if (sponsor == nil) {
                sponsor = [[Legislator alloc] initWithExternalRepresentation:[jsonElement valueForKey:@"sponsor"]];
            }
            bill.sponsor = sponsor;
        }

        [objectArray addObject:bill];
    }
    return [NSArray arrayWithArray:objectArray];
    
}

@end
