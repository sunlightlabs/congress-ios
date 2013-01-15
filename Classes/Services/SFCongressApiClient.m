//
//  SFCongressApiClient.m
//  Congress
//
//  Created by Daniel Cloud on 11/15/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFCongressApiClient.h"
#import "AFJSONRequestOperation.h"

@implementation SFCongressApiClient

+(id)sharedInstance {    
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[SFCongressApiClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://congress.api.sunlightfoundation.com/"]];
    });
}

#pragma mark - AFHTTPClient

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        //custom settings
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self setDefaultHeader:@"X-APIKEY" value:kSFAPIKey];
        
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    
    return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    NSMutableDictionary *params_override = [NSMutableDictionary dictionaryWithCapacity:parameters.count+1];
    [params_override addEntriesFromDictionary:parameters];
    if (![params_override valueForKey:@"apikey"]) {
        [params_override setValue:kSFAPIKey forKey:@"apikey"];
    }
    NSMutableURLRequest *request = [super requestWithMethod:method path:path parameters:params_override];
    return request;
}

@end
