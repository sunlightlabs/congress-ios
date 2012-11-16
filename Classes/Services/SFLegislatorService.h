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

+(void)get:(NSString *)bioguide_id success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
+(void)getList:(NSDictionary *)query_params success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;

@end
