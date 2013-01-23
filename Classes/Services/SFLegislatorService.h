//
//  SFLegislatorService.h
//  Congress
//
//  Created by Daniel Cloud on 11/15/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFHTTPClientUtils.h"
#import "SFSharedInstance.h"
@class Legislator;

typedef enum {
    LegislatorImageSizeSmall,
    LegislatorImageSizeMedium,
    LegislatorImageSizeLarge
} LegislatorImageSize;

@interface SFLegislatorService : NSObject

+(void)getLegislatorWithId:(NSString *)bioguide_id completionBlock:(void(^)(Legislator *legislator))completionBlock;
+(void)getAllLegislatorsInOfficeWithCompletionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)getLegislatorsWithParameters:(NSDictionary *)parameters completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)searchWithQuery:(NSString *)query_str parametersOrNil:(NSDictionary *)parameters
       completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)getLegislatorsForLocationWithParameters:(NSDictionary *)parameters
                               completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)getLegislatorsForZip:(NSNumber *)zip
                    completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)getLegislatorsForZip:(NSNumber *)zip count:(NSNumber *)count
                    completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)getLegislatorsForZip:(NSNumber *)zip page:(NSNumber *)page
                    completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)getLegislatorsForZip:(NSNumber *)zip count:(NSNumber *)count page:(NSNumber *)page
                    completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)getLegislatorsForLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude
                         completionBlock:(ResultsListCompletionBlock)completionBlock;
+(NSURL *)getLegislatorImageURLforId:(NSString *)bioguide_id size:(LegislatorImageSize)imageSize;

@end
