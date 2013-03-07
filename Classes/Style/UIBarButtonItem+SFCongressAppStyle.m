//
//  UIBarButtonItem+SFCongressAppStyle.m
//  Congress
//
//  Created by Daniel Cloud on 1/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "UIBarButtonItem+SFCongressAppStyle.h"

@implementation UIBarButtonItem (SFCongressAppStyle)

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
    [button setBackButtonBackgroundImage:[UIImage barButtonDefaultBackgroundImage] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    return button;
}

+(instancetype)favoriteButton
{
    UIBarButtonItem *button = [self favoriteButtonWithTarget:nil action:nil];
    return button;
}

+(instancetype)favoriteButtonWithTarget:(id)target action:(SEL)action
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Favorite"
                                                               style:UIBarButtonItemStylePlain target:target action:action];
    return button;
}

+(instancetype)actionButton
{
    UIBarButtonItem *button = [self actionButtonWithTarget:nil action:nil];
    return button;
}

+(instancetype)actionButtonWithTarget:(id)target action:(SEL)action
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                            target:target action:action];
    return button;
}

@end
