//
//  SFLegislatorService.m
//  Congress
//
//  Created by Daniel Cloud on 11/15/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorService.h"
#import "SFLegislator.h"

@implementation SFLegislatorService

+(void)getLegislatorWithId:(NSString *)bioguide_id success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
    
    [[SFCongressApiClient sharedInstance] getPath:@"legislators.get" parameters:@{ @"bioguide_id":bioguide_id } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SFLegislator *legislator = [SFLegislator initWithDictionary:[responseObject valueForKeyPath:@"response.legislator"]];
        if (success) {
            success((AFJSONRequestOperation *)operation, legislator);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure((AFJSONRequestOperation *)operation, error);
        }
    }];
}

+(void)getLegislatorsWithParameters:(NSDictionary *)parameters success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
    [[SFCongressApiClient sharedInstance] getPath:@"legislators.getList" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *rawData = [responseObject valueForKeyPath:@"response.legislators"];
        NSMutableArray *legislatorArray = [NSMutableArray arrayWithCapacity:rawData.count];
        for (NSDictionary *element in rawData) {
            [legislatorArray addObject:[SFLegislator initWithDictionary:[element valueForKeyPath:@"legislator"]]];
        }
        if (success) {
            success((AFJSONRequestOperation *)operation, legislatorArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure((AFJSONRequestOperation *)operation, error);
        }
    }];
}

+(void)searchWithParameters:(NSDictionary *)parameters success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
    [[SFCongressApiClient sharedInstance] getPath:@"legislators.search" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *resultsArray = [responseObject valueForKeyPath:@"response.results"];
        NSMutableArray *legislatorArray = [NSMutableArray arrayWithCapacity:resultsArray.count];
        for (NSDictionary *element in resultsArray) {
            [legislatorArray addObject:[SFLegislator initWithDictionary:[element valueForKeyPath:@"result.legislator"]]];
        }
        if (success) {
            success((AFJSONRequestOperation *)operation, legislatorArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure((AFJSONRequestOperation *)operation, error);
        }
    }];
}

+(void)getLegislatorsForZip:(NSNumber *)zip success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
    [[SFCongressApiClient sharedInstance] getPath:@"legislators.allForZip" parameters:@{@"zip":zip} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *resultsArray = [responseObject valueForKeyPath:@"response.legislators"];
        NSMutableArray *legislatorArray = [NSMutableArray arrayWithCapacity:resultsArray.count];
        for (NSDictionary *element in resultsArray) {
            [legislatorArray addObject:[SFLegislator initWithDictionary:[element valueForKeyPath:@"legislator"]]];
        }
        if (success) {
            success((AFJSONRequestOperation *)operation, legislatorArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure((AFJSONRequestOperation *)operation, error);
        }
    }];
}

+(void)getLegislatorsForLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure {
    [[SFCongressApiClient sharedInstance] getPath:@"legislators.allForLatLong" parameters:@{@"latitude":latitude, @"longitude":longitude} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *resultsArray = [responseObject valueForKeyPath:@"response.legislators"];
        NSMutableArray *legislatorArray = [NSMutableArray arrayWithCapacity:resultsArray.count];
        for (NSDictionary *element in resultsArray) {
            [legislatorArray addObject:[SFLegislator initWithDictionary:[element valueForKeyPath:@"legislator"]]];
        }
        if (success) {
            success((AFJSONRequestOperation *)operation, legislatorArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure((AFJSONRequestOperation *)operation, error);
        }
    }];
}

@end
