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
#import "SFLegislator.h"

@implementation SFLegislatorService

#pragma mark - Public methods

+ (void)legislatorWithId:(NSString *)bioguide_id completionBlock:(void (^)(SFLegislator *legislator))completionBlock {
    [[SFCongressApiClient sharedInstance] GET:@"legislators"
                                   parameters:@{ @"bioguide_id":bioguide_id, @"all_legislators": @"true" }
                                      success: ^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *legislatorArray = [self convertResponseToLegislators:responseObject];
        SFLegislator *legislator = [legislatorArray lastObject];
        completionBlock(legislator);
    } failure: ^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(nil);
    }];
}

+ (void)allLegislatorsInOfficeWithCompletionBlock:(ResultsListCompletionBlock)completionBlock {
    NSDictionary *params = @{ @"per_page":@"all", @"in_office":@"true", @"order":@"state_name__asc,last_name__asc" };
    [self legislatorsWithParameters:params completionBlock:completionBlock];
}

+ (void)legislatorsWithIds:(NSArray *)bioguideIdList
           completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self legislatorsWithIds:bioguideIdList count:nil page:nil completionBlock:completionBlock];
}

+ (void)legislatorsWithIds:(NSArray *)bioguideIdList count:(NSInteger)count
           completionBlock:(ResultsListCompletionBlock)completionBlock;

{
    [self legislatorsWithIds:bioguideIdList count:count page:nil completionBlock:completionBlock];
}

+ (void)legislatorsWithIds:(NSArray *)bioguideIdList page:(NSInteger)page
           completionBlock:(ResultsListCompletionBlock)completionBlock;
{
    [self legislatorsWithIds:bioguideIdList count:nil page:page completionBlock:completionBlock];
}


+ (void)legislatorsWithIds:(NSArray *)bioguideIdList count:(NSInteger)count page:(NSInteger)page
           completionBlock:(ResultsListCompletionBlock)completionBlock {
    NSSortDescriptor *lastNameSortDes = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];

    if ([bioguideIdList count] > 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                           @"per_page" : @((count == 0 ? 20 : count)),
                                           @"page" : @((page == 0 ? 1 : page)),
                                           @"all_legislators":@"true",
                                           @"order":@"last_name__asc",
                                           @"bioguide_id__in": [bioguideIdList componentsJoinedByString:@"|"]
                                       }];
        [self legislatorsWithParameters:params completionBlock: ^(NSArray *resultsArray) {
            NSMutableArray *allResults = [NSMutableArray arrayWithArray:resultsArray];
            [allResults sortUsingDescriptors:@[lastNameSortDes]];
            completionBlock(allResults);
        }];
    }
    else {
        completionBlock(nil);
    }
}

+ (void)legislatorsWithParameters:(NSDictionary *)parameters completionBlock:(ResultsListCompletionBlock)completionBlock {
    [[SFCongressApiClient sharedInstance] GET:@"legislators" parameters:parameters success: ^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *legislatorArray = [self convertResponseToLegislators:responseObject];
        completionBlock(legislatorArray);
    } failure: ^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(nil);
    }];
}

+ (void)searchWithQuery:(NSString *)query_str parametersOrNil:(NSDictionary *)parameters completionBlock:(ResultsListCompletionBlock)completionBlock {
    NSMutableDictionary *joined_params = [NSMutableDictionary dictionaryWithDictionary:@{ @"query" : query_str }];

    if (parameters != nil) {
        [joined_params addEntriesFromDictionary:parameters];
    }

    [[SFCongressApiClient sharedInstance] GET:@"legislators" parameters:joined_params success: ^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *legislatorArray = [self convertResponseToLegislators:responseObject];
        completionBlock(legislatorArray);
    } failure: ^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(nil);
    }];
}

+ (void)legislatorsForLocationWithParameters:(NSDictionary *)parameters completionBlock:(ResultsListCompletionBlock)completionBlock {
    [[SFCongressApiClient sharedInstance] GET:@"legislators/locate" parameters:parameters success: ^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *legislatorArray = [self convertResponseToLegislators:responseObject];
        completionBlock(legislatorArray);
    } failure: ^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(nil);
    }];
}

+ (void)legislatorsForZip:(NSNumber *)zip
          completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self legislatorsForZip:zip count:nil page:nil completionBlock:completionBlock];
}

+ (void)legislatorsForZip:(NSNumber *)zip count:(NSInteger)count
          completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self legislatorsForZip:zip count:count page:nil completionBlock:completionBlock];
}

+ (void)legislatorsForZip:(NSNumber *)zip page:(NSInteger)page
          completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self legislatorsForZip:zip count:nil page:page completionBlock:completionBlock];
}

+ (void)legislatorsForZip:(NSNumber *)zip count:(NSInteger)count page:(NSInteger)page
          completionBlock:(ResultsListCompletionBlock)completionBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{ @"zip" : zip,
                                                                                   @"per_page" : @((count == 0 ? 20 : count)),
                                                                                   @"page" : @((page == 0 ? 1 : page)), }];

    [self legislatorsForLocationWithParameters:params completionBlock:completionBlock];
}

+ (void)legislatorsForCoordinate:(CLLocationCoordinate2D)coordinate
                 completionBlock:(ResultsListCompletionBlock)completionBlock {
    [self legislatorsForLatitude:[NSNumber numberWithDouble:coordinate.latitude]
                       longitude:[NSNumber numberWithDouble:coordinate.longitude]
                 completionBlock:completionBlock];
}

+ (void)legislatorsForLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude
               completionBlock:(ResultsListCompletionBlock)completionBlock {
    [[SFCongressApiClient sharedInstance] GET:@"legislators/locate" parameters:@{ @"latitude":latitude, @"longitude":longitude } success: ^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *legislatorArray = [self convertResponseToLegislators:responseObject];
        completionBlock(legislatorArray);
    } failure: ^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(nil);
    }];
}

+ (NSURL *)legislatorImageURLforId:(NSString *)bioguide_id size:(LegislatorImageSize)imageSize {
    NSArray *sizeChoices = @[@"225x275", @"450x550", @"original"];
    NSString *baseUrlString = @"http://theunitedstates.io/images/congress";
    return [NSURL sam_URLWithFormat:@"%@/%@/%@.jpg", baseUrlString, sizeChoices[imageSize], bioguide_id];
}

#pragma mark - Private Methods
+ (NSArray *)convertResponseToLegislators:(id)responseObject {
    NSArray *resultsArray = [responseObject valueForKeyPath:@"results"];

    if (![resultsArray count]) return @[];

    NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:resultsArray.count];

    for (NSDictionary *jsonElement in resultsArray) {
        SFLegislator *object = [SFLegislator objectWithJSONDictionary:jsonElement];
        [objectArray addObject:object];
    }
    return [NSArray arrayWithArray:objectArray];
}

@end
