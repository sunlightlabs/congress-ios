//
//  SFBillService.h
//  Congress
//
//  Created by Daniel Cloud on 11/19/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFHTTPClientUtils.h"

@interface SFBillService : NSObject

+(void)getBillWithId:(NSString *)bill_id success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
+(void)searchWithParameters:(NSDictionary *)query_params success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
+(void)recentlyIntroducedBillsWithSuccess:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
+(void)recentlyIntroducedBillsWithPage:(NSNumber *)pageNumber success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
+(void)recentlyIntroducedBillsWithCount:(NSNumber *)count success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
+(void)recentlyIntroducedBillsWithCount:(NSNumber *)count page:(NSNumber *)pageNumber success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
+(void)recentlyActedOnBillsWithSuccess:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
+(void)recentlyActedOnBillsWithPage:(NSNumber *)pageNumber success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
+(void)recentlyActedOnBillsWithCount:(NSNumber *)count success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
+(void)recentlyActedOnBillsWithCount:(NSNumber *)count page:(NSNumber *)pageNumber success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
+(void)recentLawsWithSuccess:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
+(void)recentLawsWithPage:(NSNumber *)pageNumber success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
+(void)recentLawsWithCount:(NSNumber *)count success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
+(void)recentLawsWithCount:(NSNumber *)count page:(NSNumber *)pageNumber success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;

+(NSArray *)getBasicSectionsArray;
+(NSString *)getSectionsStringWith:(NSArray *)additionalSectionsOrNull;

@end
