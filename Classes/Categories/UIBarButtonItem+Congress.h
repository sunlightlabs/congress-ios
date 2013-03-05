//
//  UIBarButtonItem+Congress.h
//  Congress
//
//  Created by Daniel Cloud on 1/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Congress)

+(instancetype)settingsButton;
+(instancetype)settingsButtonWithTarget:(id)target action:(SEL)action;
+(instancetype)backButton;
+(instancetype)backButtonWithTarget:(id)target action:(SEL)action;
+(instancetype)favoriteButton;
+(instancetype)favoriteButtonWithTarget:(id)target action:(SEL)action;


@end
