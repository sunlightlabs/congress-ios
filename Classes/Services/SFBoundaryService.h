//
//  SFBoundaryService.h
//  Congress
//
//  Created by Jeremy Carbaugh on 3/13/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "AFHTTPClient.h"
#import "SFSharedInstance.h"

@interface SFBoundaryService : AFHTTPClient <SFSharedInstance>

- (void)boundaryForState:(NSString*)state
                district:(NSNumber*)district
         completionBlock:(void (^)(id responseObject))completionBlock;

@end
