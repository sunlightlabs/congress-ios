//
//  SFRealTimeCongressApiClient.m
//  Congress
//
//  Created by Daniel Cloud on 11/19/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFRealTimeCongressApiClient.h"

@implementation SFRealTimeCongressApiClient

+(id)sharedInstance {
    static SFRealTimeCongressApiClient *_sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[SFRealTimeCongressApiClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.realtimecongress.org/api/v1"]];
    });
    
    return _sharedInstance;
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

@end
