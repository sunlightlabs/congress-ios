//
//  SFCongressAppStyle.h
//  Congress
//
//  Created by Daniel Cloud on 3/6/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIBarButtonItem+SFCongressAppStyle.h"

@interface UIColor (SFCongressAppStyle)

+ (UIColor *)primaryBackgroundColor;
+ (UIColor *)menuBackgroundColor;
+ (UIColor *)menuSelectionBackgroundColor;
+ (UIColor *)menuTextColor;
+ (UIColor *)primaryTextColor;
+ (UIColor *)linkTextColor;
+ (UIColor *)linkHighlightedTextColor;
+ (UIColor *)menuDividerBottomInsetColor;
+ (UIColor *)menuDividerBottomColor;
+ (UIColor *)navigationBarBackgroundColor;
+ (UIColor *)navigationBarTextColor;
+ (UIColor *)navigationBarTextShadowColor;
+ (UIColor *)tableSeparatorColor;
+ (UIColor *)h1Color;
+ (UIColor *)h2Color;
+ (UIColor *)selectedSegmentedTextColor;
+ (UIColor *)unselectedSegmentedTextColor;

@end

@interface UIImage (SFCongressAppStyle)

+ (UIImage *)barButtonDefaultBackgroundImage;
+ (UIImage *)shareButtonImage;
+ (UIImage *)backButtonImage;
+ (UIImage *)menuButtonImage;
+ (UIImage *)segmentedBarBackgroundImage;
+ (UIImage *)segmentedBarDividerImage;
+ (UIImage *)segmentedBarSelectedImage;
+ (UIImage *)calloutBoxBackgroundImage;

@end

@interface UIFont (SFCongressAppStyle)

+ (UIFont *)navigationBarFont;
+ (UIFont *)menuFont;
+ (UIFont *)menuSelectedFont;
+ (UIFont *)buttonFont;
+ (UIFont *)bodyTextFont;
+ (UIFont *)h1Font;
+ (UIFont *)h2Font;
+ (UIFont *)h2EmFont;
+ (UIFont *)linkFont;
+ (UIFont *)cellTextFont;
+ (UIFont *)cellDetailTextFont;

@end

@interface NSMutableAttributedString (SFCongressAppStyle)

+ (NSMutableAttributedString *)underlinedStringFor:(NSString *)string;
+ (NSMutableAttributedString *)linkStringFor:(NSString *)string;
+ (NSMutableAttributedString *)highlightedLinkStringFor:(NSString *)string;

@end

@interface NSParagraphStyle (SFCongressAppStyle)

+ (CGFloat)lineSpacing;

@end

@interface SFCongressAppStyle : NSObject

+ (void)setUpGlobalStyles;

@end
