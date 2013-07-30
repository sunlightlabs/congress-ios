//
//  SFHearingService.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/30/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFHearingService.h"
#import "SFCongressApiClient.h"

@implementation SFHearingService

+ (void)hearingsForCommitteeId:(NSString *)committeeId completionBlock:(void(^)(NSArray *hearings))completionBlock
{
    [[SFCongressApiClient sharedInstance] getPath:@"hearings"
                                       parameters:@{@"committee_id": committeeId,
                                                    @"fields": @"committee,occurs_at,congress,chamber,dc,room,description,bill_ids,url,hearing_type"}
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             NSArray *hearings = [self convertResponseToHearings:responseObject];
                                             completionBlock(hearings);
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             completionBlock(nil);
                                          }];
}

#pragma mark - private

+ (NSArray *)convertResponseToHearings:(id)responseObject
{
    NSArray *resultsArray = [responseObject valueForKeyPath:@"results"];
    NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:resultsArray.count];
    for (NSDictionary *jsonElement in resultsArray) {
        SFHearing *object = [SFHearing objectWithJSONDictionary:jsonElement];
        [objectArray addObject:object];
    }
    return [NSArray arrayWithArray:objectArray];
}

@end
