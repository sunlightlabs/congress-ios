//
//  UIBarButtonItem+SFCongressAppStyle.m
//  Congress
//
//  Created by Daniel Cloud on 1/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "UIBarButtonItem+SFCongressAppStyle.h"

@implementation UIBarButtonItem (SFCongressAppStyle)

+ (instancetype)menuButton {
    UIBarButtonItem *button = [self menuButtonWithTarget:nil action:nil];
    return button;
}

+ (instancetype)menuButtonWithTarget:(id)target action:(SEL)action {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage menuButtonImage] style:UIBarButtonItemStylePlain target:target action:action];
    [button setBackgroundImage:[UIImage clearImage] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [button setAccessibilityLabel:@"Menu"];
    [button setAccessibilityHint:@"Tap to open the main navigation menu"];
    [button setTintColor:[UIColor navigationBarTextColor]];
    return button;
}

+ (instancetype)clearButton {
    UIBarButtonItem *button = [self clearButtonWithTarget:nil action:nil];
    return button;
}

+ (instancetype)clearButtonWithTarget:(id)target action:(SEL)action {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage clearImage] style:UIBarButtonItemStylePlain target:target action:action];
    return button;
}

+ (instancetype)actionButton {
    UIBarButtonItem *button = [self actionButtonWithTarget:nil action:nil];
    return button;
}

+ (instancetype)actionButtonWithTarget:(id)target action:(SEL)action {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage shareButtonImage] style:UIBarButtonItemStylePlain target:target action:action];
    [button setBackgroundImage:[UIImage clearImage] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [button setTintColor:[UIColor navigationBarTextColor]];
    return button;
}

+ (instancetype)locationButton {
    UIBarButtonItem *button = [self locationButtonWithTarget:nil action:nil];
    return button;
}

+ (instancetype)locationButtonWithTarget:(id)target action:(SEL)action {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage locationButtonImage]
                                                               style:UIBarButtonItemStylePlain target:target action:action];
    [button setBackgroundImage:[UIImage clearImage] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [button setTintColor:[UIColor navigationBarTextColor]];
    return button;
}

+ (instancetype)calendarButtonWithTarget:(id)target action:(SEL)action {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage calendarButtonImage]
                                                               style:UIBarButtonItemStylePlain target:target action:action];
    [button setBackgroundImage:[UIImage clearImage] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [button setTintColor:[UIColor navigationBarTextColor]];
    return button;
}

+ (instancetype)cloudDownloadButtonWithTarget:(id)target action:(SEL)action {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage cloudDownloadImage]
                                                               style:UIBarButtonItemStylePlain target:target action:action];
    [button setBackgroundImage:[UIImage clearImage] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [button setTintColor:[UIColor navigationBarTextColor]];
    return button;
}

@end
