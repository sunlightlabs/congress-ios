//
//  UIBarButtonItem+Congress.m
//  Congress
//
//  Created by Daniel Cloud on 1/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "UIBarButtonItem+Congress.h"

@implementation UIBarButtonItem (Congress)

+(instancetype)settingsButton
{
    UIBarButtonItem *button = [self settingsButtonWithTarget:nil action:nil];
    return button;
}

+(instancetype)settingsButtonWithTarget:(id)target action:(SEL)action
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                        style:UIBarButtonItemStylePlain target:target action:action];
    return button;
}

+(instancetype)backButton
{
    UIBarButtonItem *button = [self backButtonWithTarget:nil action:nil];
    return button;
}

+(instancetype)backButtonWithTarget:(id)target action:(SEL)action
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                               style:UIBarButtonItemStylePlain target:target action:action];
    return button;
}

@end
