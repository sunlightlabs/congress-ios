//
//  SFBoundaryService.m
//  Congress
//
//  Created by Jeremy Carbaugh on 3/13/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBoundaryService.h"

@implementation SFBoundaryService

+ (instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK ( ^{
        return [[SFBoundaryService alloc] initWithBaseURL:[NSURL URLWithString:@"http://ec2-184-73-61-66.compute-1.amazonaws.com/"]];
    });
}

#pragma mark - AFHTTPClient

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        //custom settings
        self.responseSerializer = [AFJSONResponseSerializer serializer];

        [self.requestSerializer setValue:@"sunlight-congress-ios" forHTTPHeaderField:@"User-Agent"];

        __weak SFBoundaryService *weakSelf = self;
        [self.reachabilityManager setReachabilityStatusChangeBlock: ^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusNotReachable) {
                [weakSelf.operationQueue cancelAllOperations];
            }
        }];
    }

    return self;
}

#pragma mark - SFBoundaryService

- (NSString *)districtIDForState:(NSString *)state district:(NSNumber *)district {
    NSArray *delegates = [NSArray arrayWithObjects:@"as", @"dc", @"gu", @"mp", @"vi", nil];
    NSArray *atLarge = [NSArray arrayWithObjects:@"ak", @"de", @"mt", @"nd", @"sd", @"vt", @"wy", nil];

    NSString *districtID = nil;
    state = [state lowercaseString];
    if ([delegates containsObject:state]) {
        districtID = [NSString stringWithFormat:@"%@-delegate-district-at-large", state];
    }
    else if ([atLarge containsObject:state]) {
        districtID = [NSString stringWithFormat:@"%@-congressional-district-at-large", state];
    }
    else if ([state isEqualToString:@"pr"]) {
        districtID = @"pr-resident-commissioner-district-at-large";
    }
    else {
        districtID = [NSString stringWithFormat:@"%@-%@", state, district];
    }
    return districtID;
}

- (void)boundsForState:(NSString *)state
       completionBlock:(void (^)(CLLocationCoordinate2D northEast, CLLocationCoordinate2D southWest))completionBlock {
    NSString *boundsPath = [NSString stringWithFormat:@"boundaries/state/%@/", [state lowercaseString]];

    [self GET:boundsPath parameters:nil success: ^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *coordinates = [responseObject objectForKey:@"extent"];
        NSLog(@"%@", coordinates);
        NSLog(@"%f", [coordinates[1] doubleValue]);
        completionBlock(CLLocationCoordinate2DMake([coordinates[1] doubleValue], [coordinates[0] doubleValue]),
                        CLLocationCoordinate2DMake([coordinates[3] doubleValue], [coordinates[2] doubleValue]));
    } failure: ^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)centroidForState:(NSString *)state district:(NSNumber *)district completionBlock:(void (^)(CLLocationCoordinate2D centroid))completionBlock {
    NSString *centroidPath = [NSString stringWithFormat:@"boundaries/cd/%@/centroid", [self districtIDForState:state district:district]];
    [self GET:centroidPath parameters:nil success: ^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *coordinate = [responseObject objectForKey:@"coordinates"];
        completionBlock(CLLocationCoordinate2DMake([coordinate[1] doubleValue], [coordinate[0] doubleValue]));
    } failure: ^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)shapeForState:(NSString *)state district:(NSNumber *)district completionBlock:(void (^)(NSArray *coordinates))completionBlock {
    NSString *shapePath = [NSString stringWithFormat:@"boundaries/cd/%@/simple_shape", [self districtIDForState:state district:district]];
    [self GET:shapePath parameters:nil success: ^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *coordinates = [responseObject objectForKey:@"coordinates"];
        completionBlock(coordinates);
    } failure: ^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
