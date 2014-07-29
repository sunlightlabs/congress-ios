//
//  SFBoundaryService.h
//  Congress
//
//  Created by Jeremy Carbaugh on 3/13/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>
#import "SFSharedInstance.h"
#import <Mapbox.h>

@interface SFBoundaryService : AFHTTPSessionManager <SFSharedInstance>

- (void)boundsForState:(NSString *)state
       completionBlock:(void (^) (CLLocationCoordinate2D southWest, CLLocationCoordinate2D northEast))completionBlock;

- (void)centroidForState:(NSString *)state
                district:(NSNumber *)district
         completionBlock:(void (^) (CLLocationCoordinate2D centroid))completionBlock;

- (void)shapeForState:(NSString *)state
             district:(NSNumber *)district
      completionBlock:(void (^) (NSArray *coordinates))completionBlock;

- (NSString *)districtIDForState:(NSString *)state
                        district:(NSNumber *)district;

@end
