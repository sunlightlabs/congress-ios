//
//  SFLegislatorService.h
//  Congress
//
//  Created by Daniel Cloud on 11/15/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFCongressApiClient.h"
#import "SFHTTPClientUtils.h"

@interface SFLegislatorService : NSObject

+(void)getLegislatorWithId:(NSString *)bioguide_id success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
+(void)getLegislatorsWithParameters:(NSDictionary *)parameters success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
+(void)searchWithParameters:(NSDictionary *)parameters success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
+(void)getLegislatorsForZip:(NSNumber *)zip success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
+(void)getLegislatorsForLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;

@end
