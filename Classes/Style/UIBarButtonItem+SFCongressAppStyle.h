//
//  UIBarButtonItem+SFCongressAppStyle.h
//  Congress
//
//  Created by Daniel Cloud on 1/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (SFCongressAppStyle)

+ (instancetype)menuButton;
+ (instancetype)menuButtonWithTarget:(id)target action:(SEL)action;
+ (instancetype)clearButton;
+ (instancetype)clearButtonWithTarget:(id)target action:(SEL)action;
+ (instancetype)actionButton;
+ (instancetype)actionButtonWithTarget:(id)target action:(SEL)action;
+ (instancetype)locationButton;
+ (instancetype)locationButtonWithTarget:(id)target action:(SEL)action;
+ (instancetype)calendarButtonWithTarget:(id)target action:(SEL)action;
+ (instancetype)cloudDownloadButtonWithTarget:(id)target action:(SEL)action;

@end
