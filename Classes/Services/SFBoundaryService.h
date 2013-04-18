//
//  SFBoundaryService.h
//  Congress
//
//  Created by Jeremy Carbaugh on 3/13/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "AFHTTPClient.h"
#import "SFSharedInstance.h"
#import <MapBox/MapBox.h>

@interface SFBoundaryService : AFHTTPClient <SFSharedInstance>

- (void)centroidForState:(NSString*)state
                district:(NSNumber*)district
         completionBlock:(void (^)(CLLocationCoordinate2D centroid))completionBlock;

- (void)shapeForState:(NSString*)state
             district:(NSNumber*)district
      completionBlock:(void (^)(NSArray *coordinates))completionBlock;

- (NSString *)districtIDForState:(NSString *)state
                        district:(NSNumber *)district;

@end
