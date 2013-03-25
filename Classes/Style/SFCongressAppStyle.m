//
//  SFCongressAppStyle.m
//  Congress
//
//  Created by Daniel Cloud on 3/6/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCongressAppStyle.h"

@implementation UIColor (SFCongressAppStyle)

static NSString * const SFCongressPrimaryBackgroundColor = @"FAFBEB";
static NSString * const SFCongressPrimaryTextColor = @"4b4b3f";
static NSString * const SFCongressLinkTextColor = @"d5bc5f";
static NSString * const SFCongresslinkHighlightedTextColor = @"c53f24";

static NSString * const SFCongressNavigationBarColor = @"70b6b7";
static NSString * const SFCongressNavigationBarTextColor = @"fcfcee";
static NSString * const SFCongressNavigationBarTextShadowColor = @"4c918f";

static NSString * const SFCongressSelectedSegmentedTextColor = @"434338";
static NSString * const SFCongressUnselectedSegmentedTextColor = @"c8a70d";

static NSString * const SFCongressMenuBackgroundColor = @"c64d22";
static NSString * const SFCongressMenuSelectionBgColor = @"b63c17";
static NSString * const SFCongressMenuTextColor = @"f2e1d1";
static NSString * const SFCongressMenuDividerBottomInsetColor = @"b63b19";
static NSString * const SFCongressMenuDividerBottomColor = @"d05b30";

static NSString * const SFCongressTableSeparatorColor = @"e9e8cf";

static NSString * const SFCongressH1Color = @"434338";
static NSString * const SFCongressH2Color = @"67675d";

static NSString * const SFDetailLineColor = @"e9e8cf";

+ (UIColor *)primaryBackgroundColor
{
    return [UIColor colorWithHex:SFCongressPrimaryBackgroundColor];
}

+ (UIColor *)menuBackgroundColor
{
    return [UIColor colorWithHex:SFCongressMenuBackgroundColor];
}

+ (UIColor *)menuSelectionBackgroundColor
{
    return [UIColor colorWithHex:SFCongressMenuSelectionBgColor];
}

+ (UIColor *)menuTextColor
{
    return [UIColor colorWithHex:SFCongressMenuTextColor];
}

+ (UIColor *)primaryTextColor
{
    return [UIColor colorWithHex:SFCongressPrimaryTextColor];
}

+ (UIColor *)linkTextColor
{
    return [UIColor colorWithHex:SFCongressLinkTextColor];
}

+ (UIColor *)linkHighlightedTextColor
{
    return [UIColor colorWithHex:SFCongresslinkHighlightedTextColor];
}

+ (UIColor *)menuDividerBottomInsetColor
{
    return [UIColor colorWithHex:SFCongressMenuDividerBottomInsetColor];
}

+ (UIColor *)menuDividerBottomColor
{
    return [UIColor colorWithHex:SFCongressMenuDividerBottomColor];
}

+ (UIColor *)navigationBarBackgroundColor
{
    return [UIColor colorWithHex:SFCongressNavigationBarColor];
}

+ (UIColor *)navigationBarTextColor
{
    return [UIColor colorWithHex:SFCongressNavigationBarTextColor];
}

+ (UIColor *)navigationBarTextShadowColor
{
    return [UIColor colorWithHex:SFCongressNavigationBarTextShadowColor];
}

+ (UIColor *)tableSeparatorColor
{
    return [UIColor colorWithHex:SFCongressTableSeparatorColor];
}

+ (UIColor *)h1Color
{
    return [UIColor colorWithHex:SFCongressH1Color];
}

+ (UIColor *)h2Color
{
    return  [UIColor colorWithHex:SFCongressH2Color];
}

+ (UIColor *)selectedSegmentedTextColor
{
    return  [UIColor colorWithHex:SFCongressSelectedSegmentedTextColor];
}

+ (UIColor *)unselectedSegmentedTextColor
{
    return  [UIColor colorWithHex:SFCongressUnselectedSegmentedTextColor];
}

+ (UIColor *)detailLineColor
{
    return [UIColor colorWithHex:SFDetailLineColor];
}

@end

@implementation UIFont (SFCongressAppStyle)

+ (UIFont *)navigationBarFont
{
    return [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:19.0f];
}

+ (UIFont *)menuFont
{
    return [UIFont fontWithName:@"EuphemiaUCAS" size:18.0f];
}

+ (UIFont *)menuSelectedFont
{
    return [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:18.0f];
}

+ (UIFont *)buttonFont
{
    return [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:18.0f];
}

+ (UIFont *)bodyTextFont
{
    return [UIFont fontWithName:@"HoeflerText-Regular" size:13.0f];
}

+ (UIFont *)h1Font
{
    return [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
}

+ (UIFont *)h2Font;
{
    return [UIFont fontWithName:@"Helvetica-Bold" size:10.0f];
}

+ (UIFont *)h2EmFont
{
    return [UIFont fontWithName:@"HoeflerText-Italic" size:13.0f];
}

+ (UIFont *)linkFont
{
    return [UIFont fontWithName:@"Helvetica" size:13.0f];
}

+ (UIFont *)cellTextFont
{
    return [UIFont fontWithName:@"Helvetica" size:16.0f];
}

+ (UIFont *)cellDetailTextFont
{
    return [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
}

@end

@implementation UIImage (SFCongressAppStyle)

static NSString * const SFCongressNavigationBarBackgroundImage = @"UINavigationBarBlueFlatBack";
static NSString * const SFCongressBackButtonImage = @"UIIconsBack";
static NSString * const SFCongressShareImage = @"UIIconsShare";
static NSString * const SFCongressMenuImage = @"UIIconsHamburger";

static NSString * const SFCongressSegmentedBackgroundBarImage = @"UISegmentedBar";
static NSString * const SFCongressSegmentedBarDividerImage = @"UISegmentedBarDivider";
static NSString * const SFCongressSegmentedBarSelectedImage = @"UISegmentedBarSelected";

static NSString * const SFCongressCalloutImage = @"BillSummaryMainBack";

static NSString * const SFCongressLightButtonImage = @"ButtonLightBack";
static NSString * const SFCongressDarkButtonImage = @"ButtonDarkBack";

static NSString * const SFCongressFavoriteNavImage = @"FavoriteNav";

+ (UIImage *)barButtonDefaultBackgroundImage
{
    return [UIImage imageNamed:SFCongressNavigationBarBackgroundImage];
}

+ (UIImage *)buttonDefaultBackgroundImage
{
    UIImage *img = [UIImage imageNamed:SFCongressLightButtonImage];
    return [img resizableImageWithCapInsets:UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f)];
}

+ (UIImage *)buttonSelectedBackgroundImage
{
    UIImage *img = [UIImage imageNamed:SFCongressDarkButtonImage];
    return [img resizableImageWithCapInsets:UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f)];
}

+ (UIImage *)backButtonImage
{
    UIImage *img = [UIImage imageNamed:SFCongressBackButtonImage];
    return [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, img.size.width, 0, 0)];
}

+ (UIImage *)shareButtonImage
{
    return [UIImage imageNamed:SFCongressShareImage];
}

+ (UIImage *)menuButtonImage
{
    return [UIImage imageNamed:SFCongressMenuImage];
}

+ (UIImage *)favoriteNavImage
{
    return [UIImage imageNamed:SFCongressFavoriteNavImage];
}

+ (UIImage *)segmentedBarBackgroundImage
{
    UIImage *img = [UIImage imageNamed:SFCongressSegmentedBackgroundBarImage];
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 1.0f, 0.0f, 1.0f);
    return [img resizableImageWithCapInsets:insets];
}

+ (UIImage *)segmentedBarDividerImage
{
    UIImage *img = [UIImage imageNamed:SFCongressSegmentedBarDividerImage];
    UIEdgeInsets insets = UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f);
    return [img resizableImageWithCapInsets:insets];
}

+ (UIImage *)segmentedBarSelectedImage
{
    UIImage *img = [UIImage imageNamed:SFCongressSegmentedBarSelectedImage];
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 1.0f, 0.0f, 1.0f);
    return [img resizableImageWithCapInsets:insets];
}

+ (UIImage *)calloutBoxBackgroundImage
{
    UIImage *img = [UIImage imageNamed:SFCongressCalloutImage];
    UIEdgeInsets insets = UIEdgeInsetsMake(1.0f, 30.0f, 10.0f, 1.0f);
    return [img resizableImageWithCapInsets:insets];
}

@end

@implementation NSMutableAttributedString (SFCongressAppStyle)

+ (NSMutableAttributedString *)underlinedStringFor:(NSString *)string
{
    NSMutableAttributedString *linkString = [[NSMutableAttributedString alloc] initWithString:string];
    [linkString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, linkString.length)];
    return linkString;
}

+ (NSMutableAttributedString *)linkStringFor:(NSString *)string
{
    NSMutableAttributedString *linkString = [NSMutableAttributedString underlinedStringFor:string];
    NSRange stringRange = NSMakeRange(0, linkString.length);
    [linkString addAttribute:NSForegroundColorAttributeName value:[UIColor linkTextColor] range:stringRange];
    return linkString;
}

+ (NSMutableAttributedString *)highlightedLinkStringFor:(NSString *)string
{
    NSMutableAttributedString *linkString = [NSMutableAttributedString linkStringFor:string];
    NSRange stringRange = NSMakeRange(0, linkString.length);
    [linkString addAttribute:NSForegroundColorAttributeName value:[UIColor linkHighlightedTextColor] range:stringRange];
    return linkString;
}

@end

@implementation NSParagraphStyle (SFCongressAppStyle)

static CGFloat const SFCongressParagraphLineSpacing = 6.0f;

+ (NSParagraphStyle *)congressParagraphStyle
{
    NSMutableParagraphStyle *object = [[NSMutableParagraphStyle alloc] init];
    object.lineSpacing = SFCongressParagraphLineSpacing;

    return (NSParagraphStyle *)object;
}

+ (CGFloat)lineSpacing
{
    return SFCongressParagraphLineSpacing;
}

@end

@implementation SFCongressAppStyle

+ (void)setUpGlobalStyles
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [self _setUpNavigationBarAppearance];
    [self _setUpSegmentedControlAppearance];

    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage barButtonDefaultBackgroundImage] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage backButtonImage] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    [[UISearchBar appearance] setBackgroundImage:[UIImage barButtonDefaultBackgroundImage]];
}

+ (void)_setUpSegmentedControlAppearance
{
    UISegmentedControl *sControl = [UISegmentedControl appearance];
    //    [sControl setTintColor:[UIColor navigationBarBackgroundColor]];
    [sControl setBackgroundImage:[UIImage segmentedBarBackgroundImage] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [sControl setBackgroundImage:[UIImage segmentedBarSelectedImage] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [sControl setDividerImage:[UIImage segmentedBarDividerImage]
          forLeftSegmentState:UIControlStateNormal
            rightSegmentState:UIControlStateNormal
                   barMetrics:UIBarMetricsDefault];
    [sControl setDividerImage:[UIImage segmentedBarDividerImage]
          forLeftSegmentState:UIControlStateSelected
            rightSegmentState:UIControlStateNormal
                   barMetrics:UIBarMetricsDefault];
    [sControl setDividerImage:[UIImage segmentedBarDividerImage]
          forLeftSegmentState:UIControlStateNormal
            rightSegmentState:UIControlStateSelected
                   barMetrics:UIBarMetricsDefault];
    [sControl setTitleTextAttributes:@{
            UITextAttributeTextColor: [UIColor selectedSegmentedTextColor],
      UITextAttributeTextShadowColor: [UIColor clearColor]
     } forState:UIControlStateSelected];
    [sControl setTitleTextAttributes:@{
            UITextAttributeTextColor: [UIColor unselectedSegmentedTextColor],
      UITextAttributeTextShadowColor: [UIColor clearColor]
     } forState:UIControlStateNormal];
}

+ (void)_setUpNavigationBarAppearance
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage barButtonDefaultBackgroundImage] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setShadowImage:[[UIImage alloc] init]];
    [navBar setTitleTextAttributes:@{
               UITextAttributeFont: [UIFont navigationBarFont],
          UITextAttributeTextColor: [UIColor navigationBarTextColor],
    UITextAttributeTextShadowColor: [UIColor navigationBarTextShadowColor],
   UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(1.0f, 1.0f)]
     }];
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage barButtonDefaultBackgroundImage] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

@end
