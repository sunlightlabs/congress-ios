//
//  SFLegislatorService.h
//  Congress
//
//  Created by Daniel Cloud on 11/15/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "SFHTTPClientUtils.h"
#import "SFSharedInstance.h"
@class SFLegislator;

typedef enum {
    LegislatorImageSizeSmall,
    LegislatorImageSizeMedium,
    LegislatorImageSizeLarge
} LegislatorImageSize;

@interface SFLegislatorService : NSObject

+ (void)legislatorWithId:(NSString *)bioguide_id completionBlock:(void (^) (SFLegislator *legislator))completionBlock;
+ (void)allLegislatorsInOfficeWithCompletionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)legislatorsWithIds:(NSArray *)bioguideIdList
           completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)legislatorsWithIds:(NSArray *)bioguideIdList count:(NSInteger)count
           completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)legislatorsWithIds:(NSArray *)bioguideIdList page:(NSInteger)page
           completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)legislatorsWithIds:(NSArray *)bioguideIdList count:(NSInteger)count page:(NSInteger)page
           completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)legislatorsWithParameters:(NSDictionary *)parameters completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)searchWithQuery:(NSString *)query_str parametersOrNil:(NSDictionary *)parameters
        completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)legislatorsForLocationWithParameters:(NSDictionary *)parameters
                             completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)legislatorsForZip:(NSNumber *)zip
          completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)legislatorsForZip:(NSNumber *)zip count:(NSInteger)count
          completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)legislatorsForZip:(NSNumber *)zip page:(NSInteger)page
          completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)legislatorsForZip:(NSNumber *)zip count:(NSInteger)count page:(NSInteger)page
          completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)legislatorsForCoordinate:(CLLocationCoordinate2D)coordinate
                 completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (void)legislatorsForLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude
               completionBlock:(ResultsListCompletionBlock)completionBlock;
+ (NSURL *)legislatorImageURLforId:(NSString *)bioguide_id size:(LegislatorImageSize)imageSize;

@end
