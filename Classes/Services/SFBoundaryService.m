//
//  SFBoundaryService.m
//  Congress
//
//  Created by Jeremy Carbaugh on 3/13/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBoundaryService.h"
#import "AFJSONRequestOperation.h"

@implementation SFBoundaryService

+(id)sharedInstance {    
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[SFBoundaryService alloc] initWithBaseURL:[NSURL URLWithString:@"http://ec2-184-73-61-66.compute-1.amazonaws.com/"]];
    });
}

#pragma mark - AFHTTPClient

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        //custom settings
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        __weak SFBoundaryService *weakSelf = self;
        [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusNotReachable) {
                [weakSelf.operationQueue cancelAllOperations];
            }
        }];
    }
    
    return self;
}

#pragma mark - SFBoundaryService

- (void)boundaryForState:(NSString*)state district:(NSNumber*)district completionBlock:(void (^)(id responseObject))completionBlock
{

    NSString *boundaryPath = [NSString stringWithFormat:@"boundaries/cd/%@-%@", [state lowercaseString], district];
//    NSString *centroidPath = [NSString stringWithFormat:@"%@/centroid", boundaryPath];
//    NSString *shapePath = [NSString stringWithFormat:@"%@/shape", boundaryPath];
    
    [self getPath:boundaryPath parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                completionBlock(responseObject);
            }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"boundary service error: %@", error);
                completionBlock(nil);
            }];
    
}

@end
