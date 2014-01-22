//
//  SFCongressApiClient.m
//  Congress
//
//  Created by Daniel Cloud on 11/15/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFCongressApiClient.h"
#import <AFNetworking/AFURLResponseSerialization.h>

static const NSInteger kCacheControlMaxAgeSeconds = 180;

@implementation SFCongressApiClient

+(instancetype)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[SFCongressApiClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://congress.api.sunlightfoundation.com/"]];
    });
}

#pragma mark - AFHTTPSessionManager

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {

        self.responseSerializer = [AFJSONResponseSerializer serializer];

        self.requestSerializer = [AFHTTPRequestSerializer serializer];

        //custom settings
        [self.requestSerializer setValue:@"sunlight-congress-ios" forHTTPHeaderField:@"User-Agent"];
        [self.requestSerializer setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
                      forHTTPHeaderField:@"X-App-Version"];
        [self.requestSerializer setValue:[NSString stringWithFormat:@"iOS %@ - %@",
                                          [[UIDevice currentDevice] systemVersion],
                                          [[UIDevice currentDevice] modelName]]
                      forHTTPHeaderField:@"X-OS-Version"];
        [self.requestSerializer setValue:kSFAPIKey forHTTPHeaderField:@"X-APIKEY"];

        __cacheControlHeader = [NSString stringWithFormat:@"max-age=%i", kCacheControlMaxAgeSeconds];

        __weak SFCongressApiClient *weakSelf = self;
        [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusNotReachable) {
                [weakSelf.operationQueue cancelAllOperations];
            }
        }];

        __weak NSString *cacheControlHeader = __cacheControlHeader;
        [self setDataTaskWillCacheResponseBlock:^NSCachedURLResponse *(NSURLSession *session, NSURLSessionDataTask *dataTask, NSCachedURLResponse *proposedResponse) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)[proposedResponse response];
            if([session configuration].requestCachePolicy == NSURLRequestUseProtocolCachePolicy) {
                NSDictionary *headers = [httpResponse allHeaderFields];
                NSString *cacheControl = [headers valueForKey:@"Cache-Control"];
                NSString *expires = [headers valueForKey:@"Expires"];
                if((cacheControl == nil) && (expires == nil)) {
//                    NSLog(@"server does not provide expiration information and we are using NSURLRequestUseProtocolCachePolicy");
                    NSMutableDictionary *modifiedHeaders = [NSMutableDictionary dictionaryWithDictionary:headers];
                    modifiedHeaders[@"Cache-Control"] = [cacheControlHeader copy];
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSDate date] forKey:@"cachedDate"];
                    NSHTTPURLResponse *modifiedResponse = [[NSHTTPURLResponse alloc] initWithURL:httpResponse.URL
                                                                                      statusCode:httpResponse.statusCode HTTPVersion:@"HTTP/1.1" headerFields:modifiedHeaders];
                    NSCachedURLResponse *newCachedResponse = [[NSCachedURLResponse alloc] initWithResponse:modifiedResponse data:[proposedResponse data]
                                                                                                  userInfo:userInfo storagePolicy:[proposedResponse storagePolicy]];
                    return newCachedResponse;
                }
            }
            return proposedResponse;
        }];
    }
    
    return self;
}

@end
