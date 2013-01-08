//
//  SFLegislatorService.m
//  Congress
//
//  Created by Daniel Cloud on 11/15/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//
// TODO: Get legislators by state, name.

#import "SFLegislatorService.h"
#import "SFCongressApiClient.h"
#import "SFStateService.h"
#import "Legislator.h"


@implementation SFLegislatorService

+(id)sharedInstance {
    static SFLegislatorService *_sharedInstance;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[SFLegislatorService alloc] init];
    });

    return _sharedInstance;
}

#pragma mark - Public methods

-(void)getLegislatorWithId:(NSString *)bioguide_id success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure
{
    
    [[SFCongressApiClient sharedInstance] getPath:@"legislators" parameters:@{ @"bioguide_id":bioguide_id } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *legislatorArray = [self convertResponseToLegislators:responseObject];
        if (success) {
            success((AFJSONRequestOperation *)operation, legislatorArray[0]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure((AFJSONRequestOperation *)operation, error);
        }
    }];
}

-(void)getLegislatorsWithParameters:(NSDictionary *)parameters success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure
{
    [[SFCongressApiClient sharedInstance] getPath:@"legislators" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *legislatorArray = [self convertResponseToLegislators:responseObject];
        if (success) {
            success((AFJSONRequestOperation *)operation, legislatorArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure((AFJSONRequestOperation *)operation, error);
        }
    }];
}

-(void)searchWithQuery:(NSString *)query_str parametersOrNil:(NSDictionary *)parameters success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure
{
    NSMutableDictionary *joined_params = [[NSMutableDictionary alloc] initWithDictionary:@{ @"query" : query_str }];

    if (parameters != nil) {
        [joined_params addEntriesFromDictionary:parameters];
    }

    [[SFCongressApiClient sharedInstance] getPath:@"legislators" parameters:joined_params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *legislatorArray = [self convertResponseToLegislators:responseObject];
        if (success) {
            success((AFJSONRequestOperation *)operation, legislatorArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure((AFJSONRequestOperation *)operation, error);
        }
    }];
}

-(void)getLegislatorsForLocationWithParameters:(NSDictionary *)parameters success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure
{
    [[SFCongressApiClient sharedInstance] getPath:@"legislators/locate" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *legislatorArray = [self convertResponseToLegislators:responseObject];
        if (success) {
            success((AFJSONRequestOperation *)operation, legislatorArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure((AFJSONRequestOperation *)operation, error);
        }
    }];
}

-(void)getLegislatorsForZip:(NSNumber *)zip
                    success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure
{
    [self getLegislatorsForZip:zip count:nil page:nil success:success failure:failure];
}

-(void)getLegislatorsForZip:(NSNumber *)zip count:(NSNumber *)count
                    success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure
{
    [self getLegislatorsForZip:zip count:count page:nil success:success failure:failure];
}

-(void)getLegislatorsForZip:(NSNumber *)zip page:(NSNumber *)page
                    success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure
{
    [self getLegislatorsForZip:zip count:nil page:page success:success failure:failure];
}

-(void)getLegislatorsForZip:(NSNumber *)zip count:(NSNumber *)count page:(NSNumber *)page
                    success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{ @"zip" : zip,
                                       @"per_page" : (count == nil ? @20 : count),
                                       @"page" : (page == nil ? @1 : page)
                                   }];

    [self getLegislatorsForLocationWithParameters:params success:success failure:failure];
}

-(void)getLegislatorsForLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude
                         success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure
{
    [[SFCongressApiClient sharedInstance] getPath:@"legislators/locate" parameters:@{@"latitude":latitude, @"longitude":longitude} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *legislatorArray = [self convertResponseToLegislators:responseObject];
        if (success) {
            success((AFJSONRequestOperation *)operation, legislatorArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure((AFJSONRequestOperation *)operation, error);
        }
    }];
}

-(NSURL *)getLegislatorImageURLforId:(NSString *)bioguide_id size:(LegislatorImageSize)imageSize
{
    NSArray *sizeChoices = @[@"40x50", @"100x125", @"200x250"];
    NSString *baseUrlString = @"http://assets.sunlightfoundation.com/moc";
    return [NSURL URLWithFormat:@"%@/%@/%@.jpg", baseUrlString, sizeChoices[imageSize], bioguide_id];
}

#pragma mark - Private Methods
-(NSArray *)convertResponseToLegislators:(id)responseObject
{
    NSArray *resultsArray = [responseObject valueForKeyPath:@"results"];
    NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:resultsArray.count];

    for (NSDictionary *element in resultsArray) {
//        NSManagedObjectContext *context =
//        SFLegislator *legislator = [SFLegislator initWithDictionary:element];
//        [objectArray addObject:legislator];
    }
    return [NSArray arrayWithArray:objectArray];

}


@end
