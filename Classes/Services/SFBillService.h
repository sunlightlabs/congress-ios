//
//  SFBillService.h
//  Congress
//
//  Created by Daniel Cloud on 11/19/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFHTTPClientUtils.h"
#import "SFSharedInstance.h"
@class SFBill;

@interface SFBillService : NSObject

+(void)getBillWithId:(NSString *)bill_id completionBlock:(void(^)(SFBill *bill))completionBlock;
+(void)lookupWithParameters:(NSDictionary *)params completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)recentlyIntroducedBillsWithCompletionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)recentlyIntroducedBillsWithPage:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)recentlyIntroducedBillsWithCount:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)recentlyIntroducedBillsWithCount:(NSNumber *)count page:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)recentlyActedOnBillsWithCompletionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)recentlyActedOnBillsWithPage:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)recentlyActedOnBillsWithCount:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)recentlyActedOnBillsWithCount:(NSNumber *)count page:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)recentLawsWithCompletionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)recentLawsWithPage:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)recentLawsWithCount:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)recentLawsWithCount:(NSNumber *)count page:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)searchBillText:(NSString *)searchString completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)searchBillText:(NSString *)searchString page:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)searchBillText:(NSString *)searchString count:(NSNumber *)count completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)searchBillText:(NSString *)searchString count:(NSNumber *)count page:(NSNumber *)pageNumber completionBlock:(ResultsListCompletionBlock)completionBlock;

@end
