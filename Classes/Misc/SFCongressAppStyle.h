//
//  SFCongressAppStyle.h
//  Congress
//
//  Created by Daniel Cloud on 3/6/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (SFCongressAppStyle)

+ (UIColor *)primaryBackgroundColor;
+ (UIColor *)menuBackgroundColor;
+ (UIColor *)menuFontColor;
+ (UIColor *)menuDividerColor;
+ (UIColor *)navigationBarBackgroundColor;

@end


@interface SFCongressAppStyle : NSObject

+ (void)setUpGlobalStyles;


@end
