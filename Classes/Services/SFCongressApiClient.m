//
//  SFCongressApiClient.m
//  Congress
//
//  Created by Daniel Cloud on 11/15/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFCongressApiClient.h"
#import "AFJSONRequestOperation.h"
#import <UIDeviceHardware.h>

static const NSInteger kCacheControlMaxAgeSeconds = 180;

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
        [self setDefaultHeader:@"User-Agent" value:@"sunlight-congress-ios"];
        [self setDefaultHeader:@"X-App-Version"
                         value:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        [self setDefaultHeader:@"X-OS-Version"
                         value:[NSString stringWithFormat:@"iOS %@ - %@",
                                [[UIDevice currentDevice] systemVersion],
                                [UIDeviceHardware platformString]]];
        [self setDefaultHeader:@"X-APIKEY" value:kSFAPIKey];
        __cacheControlHeader = [NSString stringWithFormat:@"max-age=%i", kCacheControlMaxAgeSeconds];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        __weak SFCongressApiClient *weakSelf = self;
        [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusNotReachable) {
                [weakSelf.operationQueue cancelAllOperations];
            }
        }];
    }
    
    return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    NSMutableDictionary *params_override = [NSMutableDictionary dictionaryWithCapacity:parameters.count+1];
    [params_override addEntriesFromDictionary:parameters];
    NSMutableURLRequest *request = [super requestWithMethod:method path:path parameters:params_override];
    return request;
}

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    AFHTTPRequestOperation *operation = [super HTTPRequestOperationWithRequest:urlRequest success:success failure:failure];
    
    [operation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)[cachedResponse response];
        if([connection currentRequest].cachePolicy == NSURLRequestUseProtocolCachePolicy) {
            NSDictionary *headers = [httpResponse allHeaderFields];
            NSString *cacheControl = [headers valueForKey:@"Cache-Control"];
            NSString *expires = [headers valueForKey:@"Expires"];
            if((cacheControl == nil) && (expires == nil)) {
//                NSLog(@"server does not provide expiration information and we are using NSURLRequestUseProtocolCachePolicy");
                NSMutableDictionary *modifiedHeaders = [NSMutableDictionary dictionaryWithDictionary:headers];
                modifiedHeaders[@"Cache-Control"] = __cacheControlHeader;
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSDate date] forKey:@"cachedDate"];
                NSHTTPURLResponse *modifiedResponse = [[NSHTTPURLResponse alloc] initWithURL:httpResponse.URL
                                                                                  statusCode:httpResponse.statusCode HTTPVersion:@"HTTP/1.1" headerFields:modifiedHeaders];
                NSCachedURLResponse *newCachedResponse = [[NSCachedURLResponse alloc] initWithResponse:modifiedResponse data:[cachedResponse data]
                                                                                              userInfo:userInfo storagePolicy:[cachedResponse storagePolicy]];
                return newCachedResponse;
            }
        }
        return cachedResponse;
    }];
    return operation;
}

@end
