//
//  SFBillService.m
//  Congress
//
//  Created by Daniel Cloud on 11/19/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFBillService.h"
#import "SFBill.h"

@implementation SFBillService

+(void)get:(NSString *)bill_id success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
    
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

+(void)search:(NSDictionary *)query_params success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
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

@end
