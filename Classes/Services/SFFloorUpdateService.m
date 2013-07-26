//
//  SFFloorUpdateService.m
//  Congress
//
//  Created by Daniel Cloud on 7/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFFloorUpdateService.h"
#import "SFCongressApiClient.h"
#import "SFFloorUpdate.h"

@implementation SFFloorUpdateService

+(NSArray *)fieldsArrayForFloorUpdate
{
    return @[ @"chamber", @"timestamp", @"congress", @"legislative_day", @"year",
              @"update", @"bill_ids", @"roll_ids", @"legislator_ids" ];
}

+(NSString *)fieldsForFloorUpdate
{
    return [[self fieldsArrayForFloorUpdate] componentsJoinedByString:@","];
}

+ (void)lookupWithParameters:(NSDictionary *)params completionBlock:(ResultsListCompletionBlock)completionBlock
{
    [[SFCongressApiClient sharedInstance] getPath:@"floor_updates" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseArray = [self convertResponseToVotes:responseObject];
        completionBlock(responseArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CLS_LOG(@"SFFloorUpdateService error: %@", [error localizedDescription]);
        completionBlock(nil);
    }];
}

#pragma mark _ Recent Floor Updates

+ (void)recentUpdatesWithCompletionBlock:(ResultsListCompletionBlock)completionBlock{
    [self recentUpdatesWithCount:nil page:nil completionBlock:completionBlock];
}

+ (void)recentUpdatesWithPage:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock
{
    [self recentUpdatesWithCount:nil page:pageNumber completionBlock:completionBlock];
}

+ (void)recentUpdatesWithCount:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock
{
    [self recentUpdatesWithCount:count page:nil completionBlock:completionBlock];
}

+ (void)recentUpdatesWithCount:(NSNumber *)count page:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock
{
    NSDictionary *params = @{
                             @"order":@"timestamp",
                             @"fields":[self fieldsForFloorUpdate],
                             @"per_page" : (count == nil ? @20 : count),
                             @"page" : (pageNumber == nil ? @1 : pageNumber)
                             };
    [self lookupWithParameters:params completionBlock:completionBlock];
}


#pragma mark - Private methods

+ (NSArray *)convertResponseToVotes:(id)responseObject
{
    NSArray *resultsArray = [responseObject valueForKeyPath:@"results"];

    if (![resultsArray count]) return @[];

    NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:resultsArray.count];

    for (NSDictionary *jsonElement in resultsArray) {
        SFFloorUpdate *object = [SFFloorUpdate objectWithJSONDictionary:jsonElement];

        [objectArray addObject:object];
    }
    NSArray *votesArray = [NSArray arrayWithArray:objectArray];
    return votesArray;
}


@end
