//
//  SFFollowing.h
//  Congress
//
//  Created by Daniel Cloud on 3/5/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SFFollowButton;

@protocol SFFollowing <NSObject>

@required

- (void)handleFollowButtonPress;

@end
