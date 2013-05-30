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
+ (UIColor *)selectedCellBackgroundColor;
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
+ (UIColor *)titleColor;
+ (UIColor *)subtitleColor;
+ (UIColor *)selectedSegmentedTextColor;
+ (UIColor *)unselectedSegmentedTextColor;
+ (UIColor *)detailLineColor;
+ (UIColor *)searchTextColor;
+ (UIColor *)mapBorderLineColor;

@end

@interface UIImage (SFCongressAppStyle)

+ (UIImage *)clearImage;
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
+ (UIImage *)favoritedCellSelectedTabImage;
+ (UIImage *)mapExpandButton;
+ (UIImage *)mapExpandSelectedButton;
+ (UIImage *)mapCollapseButton;
+ (UIImage *)mapCollapseSelectedButton;
+ (UIImage *)segmentedBarBackgroundImage;
+ (UIImage *)segmentedBarDividerImage;
+ (UIImage *)segmentedBarSelectedImage;
+ (UIImage *)searchBarBackgroundImage;
+ (UIImage *)searchBarAreaImage;
+ (UIImage *)searchBarCancelImage;
+ (UIImage *)searchBarIconImage;
+ (UIImage *)calloutBoxBackgroundImage;
+ (UIImage *)cellAccessoryDisclosureImage;
+ (UIImage *)cellAccessoryDisclosureHighlightedImage;
+ (UIImage *)photoFrame;
+ (UIImage *)photoPlaceholderImage;
+ (UIImage *)facebookImage;
+ (UIImage *)twitterImage;
+ (UIImage *)youtubeImage;
+ (UIImage *)settingsButtonImage;
+ (UIImage *)settingsButtonSelectedImage;
+ (UIImage *)sfLogoImage;
+ (UIImage *)favoritesHelpImage;
+ (UIImage *)favoriteSelectedImage;
+ (UIImage *)favoriteUnselectedImage;
+ (UIImage *)locationButtonImage;

@end

@interface UIFont (SFCongressAppStyle)

+ (UIFont *)navigationBarFont;
+ (UIFont *)menuFont;
+ (UIFont *)menuSelectedFont;
+ (UIFont *)buttonFont;
+ (UIFont *)bodyTextFont;
+ (UIFont *)billTitleFont;
+ (UIFont *)subitleFont;
+ (UIFont *)subitleStrongFont;
+ (UIFont *)subitleEmFont;
+ (UIFont *)legislatorTitleFont;
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
+ (NSMutableAttributedString *)underlinedLinkStringFor:(NSString *)string;
+ (NSMutableAttributedString *)underlinedHighlightedLinkStringFor:(NSString *)string;

@end

@interface NSParagraphStyle (SFCongressAppStyle)

+ (NSParagraphStyle *)congressParagraphStyle;
+ (CGFloat)lineSpacing;

@end

@interface SFCongressAppStyle : NSObject

+ (void)setUpGlobalStyles;

@end
