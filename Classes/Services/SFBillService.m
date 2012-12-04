//
//  SFBillService.m
//  Congress
//
//  Created by Daniel Cloud on 11/19/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFBillService.h"
#import "SFRealTimeCongressApiClient.h"
#import "SFBill.h"

@implementation SFBillService

+(NSArray *)getBasicSectionsArray
{
    return  @[@"basic",@"sponsor",@"latest_upcoming",@"last_version.urls"];
}

+(NSString *)getSectionsStringWith:(NSArray *)additionalSectionsOrNull
{
    NSMutableArray *sectionsArr = [NSMutableArray arrayWithArray:[self getBasicSectionsArray]];
    if (additionalSectionsOrNull) {
        [sectionsArr addObjectsFromArray:additionalSectionsOrNull];
    }
    return [sectionsArr componentsJoinedByString:@","];
}

+(void)getBillWithId:(NSString *)bill_id success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
    
    [[SFRealTimeCongressApiClient sharedInstance] getPath:@"bills.json" parameters:@{ @"bill_id":bill_id } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *resultsArray = [responseObject valueForKeyPath:@"bills"];
        SFBill *bill = [SFBill initWithDictionary:[resultsArray objectAtIndex:0]];
        if (success) {
            success((AFJSONRequestOperation *)operation, bill);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure((AFJSONRequestOperation *)operation, error);
        }
    }];
}

+(void)searchWithParameters:(NSDictionary *)query_params success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
    NSLog(@"SFBillService request");
    [[SFRealTimeCongressApiClient sharedInstance] getPath:@"bills.json" parameters:query_params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *resultsArray = [responseObject valueForKeyPath:@"bills"];
        NSMutableArray *billsArray = [NSMutableArray arrayWithCapacity:resultsArray.count];
        for (NSDictionary *element in resultsArray) {
            [billsArray addObject:[SFBill initWithDictionary:element]];
        }
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
        @"order":@"introduced_at",
        @"sections" : [self getSectionsStringWith:nil],
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
    NSArray *sectionsArray = @[@"last_action"];
    NSDictionary *params = @{
    @"order": @"last_action_at",
    @"sections" : [self getSectionsStringWith:sectionsArray],
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
        @"order": @"enacted_at",
        @"enacted": @"true",
        @"sections" : [self getSectionsStringWith:nil],
        @"per_page" : (count == nil ? @20 : count),
        @"page" : (pageNumber == nil ? @1 : pageNumber)
    };
    [self searchWithParameters:params success:success failure:failure];    
}

@end
