//
//  SFHTTPClientUtils.h
//  Congress
//
//  Created by Daniel Cloud on 11/16/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "AFNetworking.h"

#ifndef Congress_SFHTTPClientUtils_h
#define Congress_SFHTTPClientUtils_h

typedef void (^SFHTTPClientSuccess)(AFJSONRequestOperation *operation, id responseObject);
typedef void (^SFHTTPClientFailure)(AFJSONRequestOperation *operation, NSError *error);
typedef void (^ResultsListCompletionBlock)(NSArray *resultsArray);

#endif
