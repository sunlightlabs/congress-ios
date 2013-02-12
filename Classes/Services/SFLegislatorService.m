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
#import "SFLegislator.h"

@implementation SFLegislatorService

#pragma mark - Public methods

+(void)getLegislatorWithId:(NSString *)bioguide_id completionBlock:(void (^)(SFLegislator *legislator))completionBlock
{
    
    [[SFCongressApiClient sharedInstance] getPath:@"legislators" parameters:@{ @"bioguide_id":bioguide_id, @"all_legislators": @"true" } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *legislatorArray = [self convertResponseToLegislators:responseObject];
        SFLegislator *legislator = [legislatorArray lastObject];
        completionBlock(legislator);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil);
    }];
}

+(void)getAllLegislatorsInOfficeWithCompletionBlock:(ResultsListCompletionBlock)completionBlock
{
    NSDictionary *params = @{ @"per_page":@"all", @"in_office":@"true", @"order":@"state_name__asc,last_name__asc"};
    [self getLegislatorsWithParameters:params completionBlock:completionBlock];
}

+(void)legislatorsWithIds:(NSArray *)bioguideIdList completionBlock:(ResultsListCompletionBlock)completionBlock
{
    // checking for existing objects with those ids and when they were last updated. Reduce request size.
    NSDate *unfreshDate = [NSDate dateWithTimeIntervalSinceNow:-600];
    NSPredicate *freshlyStoredPred = [NSPredicate predicateWithFormat: @"(bioguideId IN %@) && (updatedAt >= %@)", bioguideIdList, unfreshDate];
    NSArray *storedLegislators = [[SFLegislator collection] filteredArrayUsingPredicate:freshlyStoredPred];
    NSSet *storedLegislatorIds = [NSSet setWithArray:[storedLegislators valueForKeyPath:@"bioguideId"]];
    NSMutableSet *retrievalSet = [NSMutableSet setWithArray:bioguideIdList];
    [retrievalSet minusSet:storedLegislatorIds];

    NSDictionary *params = @{
                             @"per_page":@"all", @"in_office":@"true", @"order":@"last_name__asc",
                             @"bioguide_id__in": [[retrievalSet allObjects] componentsJoinedByString:@"|"]
        };
    [self getLegislatorsWithParameters:params completionBlock:^(NSArray *resultsArray) {
        NSMutableArray *allResults = [NSMutableArray arrayWithArray:resultsArray];
        [allResults addObjectsFromArray:storedLegislators];
        [allResults sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES]]];
        completionBlock(allResults);
    }];
}

+(void)getLegislatorsWithParameters:(NSDictionary *)parameters completionBlock:(ResultsListCompletionBlock)completionBlock
{
    [[SFCongressApiClient sharedInstance] getPath:@"legislators" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *legislatorArray = [self convertResponseToLegislators:responseObject];
        completionBlock(legislatorArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil);
    }];
}

+(void)searchWithQuery:(NSString *)query_str parametersOrNil:(NSDictionary *)parameters completionBlock:(ResultsListCompletionBlock)completionBlock
{
    NSMutableDictionary *joined_params = [NSMutableDictionary dictionaryWithDictionary:@{ @"query" : query_str }];

    if (parameters != nil) {
        [joined_params addEntriesFromDictionary:parameters];
    }

    [[SFCongressApiClient sharedInstance] getPath:@"legislators" parameters:joined_params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *legislatorArray = [self convertResponseToLegislators:responseObject];
        completionBlock(legislatorArray);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil);
    }];
}

+(void)getLegislatorsForLocationWithParameters:(NSDictionary *)parameters completionBlock:(ResultsListCompletionBlock)completionBlock
{
    [[SFCongressApiClient sharedInstance] getPath:@"legislators/locate" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *legislatorArray = [self convertResponseToLegislators:responseObject];
        completionBlock(legislatorArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil);
    }];
}

+(void)getLegislatorsForZip:(NSNumber *)zip
                    completionBlock:(ResultsListCompletionBlock)completionBlock
{
    [self getLegislatorsForZip:zip count:nil page:nil completionBlock:completionBlock];
}

+(void)getLegislatorsForZip:(NSNumber *)zip count:(NSNumber *)count
                    completionBlock:(ResultsListCompletionBlock)completionBlock
{
    [self getLegislatorsForZip:zip count:count page:nil completionBlock:completionBlock];
}

+(void)getLegislatorsForZip:(NSNumber *)zip page:(NSNumber *)page
                    completionBlock:(ResultsListCompletionBlock)completionBlock
{
    [self getLegislatorsForZip:zip count:nil page:page completionBlock:completionBlock];
}

+(void)getLegislatorsForZip:(NSNumber *)zip count:(NSNumber *)count page:(NSNumber *)page
                    completionBlock:(ResultsListCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{ @"zip" : zip,
                                       @"per_page" : (count == nil ? @20 : count),
                                       @"page" : (page == nil ? @1 : page)
                                   }];

    [self getLegislatorsForLocationWithParameters:params completionBlock:completionBlock];
}

+(void)getLegislatorsForLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude
                         completionBlock:(ResultsListCompletionBlock)completionBlock
{
    [[SFCongressApiClient sharedInstance] getPath:@"legislators/locate" parameters:@{@"latitude":latitude, @"longitude":longitude} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *legislatorArray = [self convertResponseToLegislators:responseObject];
        completionBlock(legislatorArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil);

    }];
}

+(NSURL *)getLegislatorImageURLforId:(NSString *)bioguide_id size:(LegislatorImageSize)imageSize
{
    NSArray *sizeChoices = @[@"40x50", @"100x125", @"200x250"];
    NSString *baseUrlString = @"http://assets.sunlightfoundation.com/moc";
    return [NSURL URLWithFormat:@"%@/%@/%@.jpg", baseUrlString, sizeChoices[imageSize], bioguide_id];
}

#pragma mark - Private Methods
+(NSArray *)convertResponseToLegislators:(id)responseObject
{
    NSArray *resultsArray = [responseObject valueForKeyPath:@"results"];
    NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:resultsArray.count];

    for (NSDictionary *jsonElement in resultsArray) {
        SFLegislator *object = [SFLegislator objectWithExternalRepresentation:jsonElement];
        [objectArray addObject:object];
    }
    return [NSArray arrayWithArray:objectArray];

}


@end
