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
+ (UIColor *)secondaryBackgroundColor;
+ (UIColor *)selectedBackgroundColor;
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
+ (UIColor *)tableHeaderTextColor;
+ (UIColor *)tableHeaderBackgroundColor;
+ (UIColor *)h1Color;
+ (UIColor *)h2Color;
+ (UIColor *)selectedSegmentedTextColor;
+ (UIColor *)unselectedSegmentedTextColor;
+ (UIColor *)detailLineColor;
+ (UIColor *)searchTextColor;

@end

@interface UIImage (SFCongressAppStyle)

+ (UIImage *)barButtonDefaultBackgroundImage;
+ (UIImage *)buttonDefaultBackgroundImage;
+ (UIImage *)buttonSelectedBackgroundImage;
+ (UIImage *)shareButtonImage;
+ (UIImage *)backButtonImage;
+ (UIImage *)menuButtonImage;
+ (UIImage *)favoriteNavImage;
+ (UIImage *)favoritedCellBorderImage;
+ (UIImage *)favoritedPanelBorderImage;
+ (UIImage *)favoritedCellIcon;
+ (UIImage *)favoritedCellTabImage;
+ (UIImage *)segmentedBarBackgroundImage;
+ (UIImage *)segmentedBarDividerImage;
+ (UIImage *)segmentedBarSelectedImage;
+ (UIImage *)searchBarBackgroundImage;
+ (UIImage *)searchBarAreaImage;
+ (UIImage *)searchBarCancelImage;
+ (UIImage *)searchBarIconImage;
+ (UIImage *)calloutBoxBackgroundImage;
+ (UIImage *)cellAccessoryDisclosureImage;

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
+ (UIFont *)cellPanelTextFont;
+ (UIFont *)tableSectionHeaderFont;
+ (UIFont *)searchBarFont;

@end

@interface NSMutableAttributedString (SFCongressAppStyle)

+ (NSMutableAttributedString *)underlinedStringFor:(NSString *)string;
+ (NSMutableAttributedString *)linkStringFor:(NSString *)string;
+ (NSMutableAttributedString *)highlightedLinkStringFor:(NSString *)string;

@end

@interface NSParagraphStyle (SFCongressAppStyle)

+ (NSParagraphStyle *)congressParagraphStyle;
+ (CGFloat)lineSpacing;

@end

@interface SFCongressAppStyle : NSObject

+ (void)setUpGlobalStyles;

@end
