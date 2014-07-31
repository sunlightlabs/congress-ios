//
//  SFCommitteeService.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/19/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteeService.h"
#import "SFCongressApiClient.h"

@implementation SFCommitteeService

+ (void)committeeWithId:(NSString *)committeeId completionBlock:(void (^)(SFCommittee *committee))completionBlock {
    [[SFCongressApiClient sharedInstance] GET:@"committees"
                                   parameters:@{ @"committee_id": committeeId, @"fields": @"chamber,committee_id,name,office,phone,url,subcommittee,members,parent_committee" }
                                      success: ^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *committees = [self convertResponseToCommittees:responseObject];
        SFCommittee *committee = [committees lastObject];
        completionBlock(committee);
    } failure: ^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(nil);
    }];
}

+ (void)committeesWithCompletionBlock:(void (^)(NSArray *committees))completionBlock {
    [[SFCongressApiClient sharedInstance] GET:@"committees"
                                   parameters:@{ @"subcommittee": @"false",
                                                       @"per_page": @"all",
                                                       @"order": @"name__asc" }
                                      success: ^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *committees = [self convertResponseToCommittees:responseObject];
        completionBlock(committees);
    } failure: ^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(nil);
    }];
}

+ (void)committeesAndSubcommitteesWithCompletionBlock:(void (^)(NSArray *committees))completionBlock {
    [[SFCongressApiClient sharedInstance] GET:@"committees"
                                   parameters:@{}
                                      success: ^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *committees = [self convertResponseToCommittees:responseObject];
        completionBlock(committees);
    } failure: ^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(nil);
    }];
}

+ (void)committeesAndSubcommitteesForLegislator:(NSString *)legislatorId completionBlock:(void (^)(NSArray *committees))completionBlock {
    [[SFCongressApiClient sharedInstance] GET:@"committees"
                                   parameters:@{ @"member_ids": legislatorId }
                                      success: ^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *committees = [self convertResponseToCommittees:responseObject];
        completionBlock(committees);
    } failure: ^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(nil);
    }];
}

+ (void)subcommitteesWithCompletionBlock:(void (^)(NSArray *subcommittees))completionBlock {
    [[SFCongressApiClient sharedInstance] GET:@"committees"
                                   parameters:@{ @"subcommittee": @"true" }
                                      success: ^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *committees = [self convertResponseToCommittees:responseObject];
        completionBlock(committees);
    } failure: ^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(nil);
    }];
}

+ (void)subcommitteesForCommittee:(NSString *)committeeId completionBlock:(void (^)(NSArray *subcommittees))completionBlock {
    if (committeeId) {
        [[SFCongressApiClient sharedInstance] GET:@"committees"
                                       parameters:@{ @"parent_committee_id": committeeId }
                                          success: ^(NSURLSessionDataTask *task, id responseObject) {
                                              NSArray *subcommittees = [self convertResponseToCommittees:responseObject];
                                              completionBlock(subcommittees);
                                          } failure: ^(NSURLSessionDataTask *task, NSError *error) {
                                              completionBlock(nil);
                                          }];
    } else {
        completionBlock(nil);
    }
}

#pragma mark - Private Methods

+ (NSArray *)convertResponseToCommittees:(id)responseObject {
    NSArray *resultsArray = [responseObject valueForKeyPath:@"results"];
    NSMutableArray *objectArray = [NSMutableArray arrayWithCapacity:resultsArray.count];
    for (NSDictionary *jsonElement in resultsArray) {
        SFCommittee *object = [SFCommittee objectWithJSONDictionary:jsonElement];
        [objectArray addObject:object];
    }
    return [NSArray arrayWithArray:objectArray];
}

@end
