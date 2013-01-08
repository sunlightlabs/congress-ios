//
//  SFLegislatorService.h
//  Congress
//
//  Created by Daniel Cloud on 11/15/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFHTTPClientUtils.h"

typedef enum {
    LegislatorImageSizeSmall,
    LegislatorImageSizeMedium,
    LegislatorImageSizeLarge
} LegislatorImageSize;

@interface SFLegislatorService : NSObject

+ (id)sharedInstance;

-(void)getLegislatorWithId:(NSString *)bioguide_id success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
-(void)getLegislatorsWithParameters:(NSDictionary *)parameters success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
-(void)searchWithQuery:(NSString *)query_str parametersOrNil:(NSDictionary *)parameters success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
-(void)getLegislatorsForLocationWithParameters:(NSDictionary *)parameters success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
-(void)getLegislatorsForZip:(NSNumber *)zip
                    success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
-(void)getLegislatorsForZip:(NSNumber *)zip count:(NSNumber *)count
                    success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
-(void)getLegislatorsForZip:(NSNumber *)zip page:(NSNumber *)page
                    success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
-(void)getLegislatorsForZip:(NSNumber *)zip count:(NSNumber *)count page:(NSNumber *)page
                    success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
-(void)getLegislatorsForLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude
                         success:(SFHTTPClientSuccess)success failure:(SFHTTPClientFailure)failure;
-(NSURL *)getLegislatorImageURLforId:(NSString *)bioguide_id size:(LegislatorImageSize)imageSize;

@end
