//
//  SFSafariActivity.h
//  Congress
//
//  Created by Jeremy Carbaugh on 8/27/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFActivity.h"

@interface SFSafariActivity : SFActivity

@property (nonatomic, strong) NSURL *url;

+ (instancetype)activityForURL:(NSURL *)url;

@end
