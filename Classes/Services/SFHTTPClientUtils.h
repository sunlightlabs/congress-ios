//
//  SFHTTPClientUtils.h
//  Congress
//
//  Created by Daniel Cloud on 11/16/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#ifndef Congress_SFHTTPClientUtils_h
#define Congress_SFHTTPClientUtils_h

typedef void (^SFHTTPClientSuccess)(NSURLSessionDataTask *task, id responseObject);
typedef void (^SFHTTPClientFailure)(NSURLSessionDataTask *task, NSError *error);
typedef void (^ResultsListCompletionBlock)(NSArray *resultsArray);

#endif
