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

- (void)centroidForState:(NSString*)state district:(NSNumber*)district completionBlock:(void (^)(CLLocationCoordinate2D centroid))completionBlock
{
    NSString *centroidPath = [NSString stringWithFormat:@"boundaries/cd/%@-%@/centroid", [state lowercaseString], district];    
    NSMutableURLRequest *jsonRequest = [self requestWithMethod:@"GET"
                                                          path:centroidPath
                                                    parameters:nil];
    AFJSONRequestOperation *operation = [
        AFJSONRequestOperation JSONRequestOperationWithRequest:jsonRequest
                                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                            NSArray *coordinate = [JSON objectForKey:@"coordinates"];
                                                            completionBlock(CLLocationCoordinate2DMake([coordinate[1] doubleValue], [coordinate[0] doubleValue]));
                                                        }
                                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                            NSLog(@"%@", error);
                                                        }];
    [operation start];
}

- (void)shapeForState:(NSString*)state district:(NSNumber*)district completionBlock:(void (^)(NSArray *coordinates))completionBlock
{
    NSString *shapePath = [NSString stringWithFormat:@"boundaries/cd/%@-%@/simple_shape", [state lowercaseString], district];
    NSMutableURLRequest *jsonRequest = [self requestWithMethod:@"GET"
                                                          path:shapePath
                                                    parameters:nil];
    AFJSONRequestOperation *operation = [
        AFJSONRequestOperation JSONRequestOperationWithRequest:jsonRequest
                                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                            NSArray *coordinates = [JSON objectForKey:@"coordinates"];
                                                            completionBlock(coordinates);
                                                        }
                                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                            NSLog(@"%@", error);
                                                        }];
    [operation start];
}

@end
