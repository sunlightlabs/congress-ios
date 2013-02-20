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
@class SFLegislator;

typedef enum {
    LegislatorImageSizeSmall,
    LegislatorImageSizeMedium,
    LegislatorImageSizeLarge
} LegislatorImageSize;

@interface SFLegislatorService : NSObject

+(void)legislatorWithId:(NSString *)bioguide_id completionBlock:(void(^)(SFLegislator *legislator))completionBlock;
+(void)allLegislatorsInOfficeWithCompletionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)legislatorsWithIds:(NSArray *)bioguideIdList completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)legislatorsWithParameters:(NSDictionary *)parameters completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)searchWithQuery:(NSString *)query_str parametersOrNil:(NSDictionary *)parameters
       completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)legislatorsForLocationWithParameters:(NSDictionary *)parameters
                               completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)legislatorsForZip:(NSNumber *)zip
                    completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)legislatorsForZip:(NSNumber *)zip count:(NSNumber *)count
                    completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)legislatorsForZip:(NSNumber *)zip page:(NSNumber *)page
                    completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)legislatorsForZip:(NSNumber *)zip count:(NSNumber *)count page:(NSNumber *)page
                    completionBlock:(ResultsListCompletionBlock)completionBlock;
+(void)legislatorsForLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude
                         completionBlock:(ResultsListCompletionBlock)completionBlock;
+(NSURL *)legislatorImageURLforId:(NSString *)bioguide_id size:(LegislatorImageSize)imageSize;

@end
