//
//  SFCongressApiClient.h
//  Congress
//
//  Created by Daniel Cloud on 11/15/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

@interface SFCongressApiClient : AFHTTPClient

+ (id)sharedInstance;

@end
