//
//  SFRealTimeCongressApiClient.h
//  Congress
//
//  Created by Daniel Cloud on 11/19/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

@interface SFRealTimeCongressApiClient : AFHTTPClient

+ (id)sharedInstance;

@end
