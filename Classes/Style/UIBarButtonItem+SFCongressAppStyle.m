//
//  UIBarButtonItem+SFCongressAppStyle.m
//  Congress
//
//  Created by Daniel Cloud on 1/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "UIBarButtonItem+SFCongressAppStyle.h"

@implementation UIBarButtonItem (SFCongressAppStyle)

+(instancetype)menuButton
{
    UIBarButtonItem *button = [self menuButtonWithTarget:nil action:nil];
    return button;
}

+(instancetype)menuButtonWithTarget:(id)target action:(SEL)action
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                        style:UIBarButtonItemStylePlain target:target action:action];
    [button setImage:[UIImage menuButtonImage]];
    return button;
}

+(instancetype)backButton
{
    UIBarButtonItem *button = [self backButtonWithTarget:nil action:nil];
    return button;
}

+(instancetype)backButtonWithTarget:(id)target action:(SEL)action
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:target action:action];
    [button setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor clearColor], UITextAttributeTextShadowColor: [UIColor clearColor]}
                          forState:UIControlStateNormal];
    [button setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor clearColor], UITextAttributeTextShadowColor: [UIColor clearColor]}
                          forState:UIControlStateSelected];
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
    [button setImage:[UIImage shareButtonImage]];
    return button;
}

@end
