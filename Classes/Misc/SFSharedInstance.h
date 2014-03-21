//
//  SFSharedService.h
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFSharedInstance <NSObject>

@required
+ (instancetype)sharedInstance;
@end
