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
static NSString * const SFCongressSecondaryBackgroundColor = @"f5f4da";
static NSString * const SFCongressSearchTextColor = @"fcfcee";

static NSString * const SFCongressPrimaryTextColor = @"434338";
static NSString * const SFCongressLinkTextColor = @"c8a70d";
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
static NSString * const SFCongressTableHeaderTextColor = @"828875";
static NSString * const SFCongressTableHeaderBackgroundColor = @"e7e9ce";
static NSString * const SFCongressTableCellSelectedColor = @"e9e8cf";

static NSString * const SFCongressTitleColor = @"434338";
static NSString * const SFCongressSubtitleColor = @"67675d";

static NSString * const SFCongressDetailLineColor = @"e9e8cf";
static NSString * const SFCongressMapBorderLineColor = @"d6d5bc";

+ (UIColor *)primaryBackgroundColor
{
    return [UIColor colorWithHex:SFCongressPrimaryBackgroundColor];
}

+ (UIColor *)secondaryBackgroundColor
{
    return [UIColor colorWithHex:SFCongressSecondaryBackgroundColor];
}

+ (UIColor *)selectedCellBackgroundColor
{
    return [UIColor colorWithHex:SFCongressTableCellSelectedColor];
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

+ (UIColor *)tableHeaderTextColor
{
    return [UIColor colorWithHex:SFCongressTableHeaderTextColor];
}

+ (UIColor *)tableHeaderBackgroundColor
{
    return [UIColor colorWithHex:SFCongressTableHeaderBackgroundColor];
}

+ (UIColor *)titleColor
{
    return [UIColor colorWithHex:SFCongressTitleColor];
}

+ (UIColor *)subtitleColor
{
    return  [UIColor colorWithHex:SFCongressSubtitleColor];
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
    return [UIColor colorWithHex:SFCongressDetailLineColor];
}

+ (UIColor *)searchTextColor
{
    return [UIColor colorWithHex:SFCongressSearchTextColor];
}

+ (UIColor *)mapBorderLineColor
{
    return [UIColor colorWithHex:SFCongressMapBorderLineColor];
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

+ (UIFont *)billTitleFont
{
    return [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
}

+ (UIFont *)subitleFont
{
    return [UIFont fontWithName:@"Helvetica" size:10.0f];
}

+ (UIFont *)subitleStrongFont
{
    return [UIFont fontWithName:@"Helvetica-Bold" size:10.0f];
}

+ (UIFont *)subitleEmFont
{
    return [UIFont fontWithName:@"HoeflerText-Italic" size:13.0f];
}

+ (UIFont *)legislatorTitleFont
{
    return [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:18.0f];
}

+ (UIFont *)linkFont
{
    return [UIFont fontWithName:@"Helvetica-Bold" size:13.0f];
}

+ (UIFont *)cellTextFont
{
    return [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
}

+ (UIFont *)cellDetailTextFont
{
    return [UIFont fontWithName:@"Helvetica-Bold" size:10.0f];
}

+ (UIFont *)cellPanelTextFont
{
    return [UIFont fontWithName:@"Helvetica" size:13.0f];
}

+ (UIFont *)tableSectionHeaderFont
{
    return [UIFont fontWithName:@"Helvetica-Bold" size:10.0f];
}

+ (UIFont *)searchBarFont
{
    return [UIFont fontWithName:@"HoeflerText-Italic" size:14.0f];
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

static NSString * const SFCongressMapExpandButton = @"LegislaterMapExpand";
static NSString * const SFCongressMapExpandSelectedButton = @"LegislaterMapExpandPress";
static NSString * const SFCongressMapCollapseButton = @"LegislaterMapCollapse";
static NSString * const SFCongressMapCollapseSelectedButton = @"LegislaterMapCollapsePress";

static NSString * const SFCongressDefaultButtonImage = @"Button";
static NSString * const SFCongressHighlightedButtonImage = @"ButtonPress";

static NSString * const SFCongressSearchBarBackgroundImage = @"UISearchBarBg";
static NSString * const SFCongressSearchBarAreaImage = @"UISearchBarArea";
static NSString * const SFCongressSearchBarCancelImage = @"UISearchBarCancel";
static NSString * const SFCongressSearchBarIconImage = @"UISearchBarIcon";

static NSString * const SFCongressFavoriteNavImage = @"FavoriteNav";

static NSString * const SFFavoritedCellBorder = @"FavoritedListBorder";
static NSString * const SFFavoritedCellIcon = @"FavoriteList";
static NSString * const SFFavoritedCellTabImage = @"ParentListItem";
static NSString * const SFFavoritedCellSelectedTabImage = @"ParentListItemPress";
static NSString * const SFFavoritedPanelBorder = @"FavoritedSubListBorder";

static NSString * const SFPhotoPlaceholderImage = @"LegislaterNoImage";

static NSString * const SFCongressCellAccessoryDisclosureImage = @"UINavListArrow";
static NSString * const SFCongressCellAccessoryDisclosureHighlightedImage = @"UINavListArrowPress";

static NSString * const SFCongressFacebookImage = @"LegislatorContactFacebook";
static NSString * const SFCongressTwitterImage = @"LegislatorContactTwitter";
static NSString * const SFCongressYoutubeImage = @"LegislatorContactYouTube";
static NSString * const SFCongressPhotoFrame = @"LegislaterBorderBg";

static NSString * const SFCongressSettingsButtonImage = @"NavSettings";
static NSString * const SFCongressSettingsButtonSelectedImage = @"NavSettingsActive";

static NSString * const SFCongressClearImage = @"ClearImage";

static NSString * const SFSunlightLogoImage = @"SunlightFoundation";

static NSString * const SFFavoritesHelpImage = @"FollowScreen_intro";

+ (UIImage *)clearImage
{
    return [UIImage imageNamed:SFCongressClearImage];
}

+ (UIImage *)barButtonDefaultBackgroundImage
{
    return [UIImage imageNamed:SFCongressNavigationBarBackgroundImage];
}

+ (UIImage *)buttonDefaultBackgroundImage
{
    UIImage *img = [UIImage imageNamed:SFCongressDefaultButtonImage];
    return [img resizableImageWithCapInsets:UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f)];
}

+ (UIImage *)buttonSelectedBackgroundImage
{
    UIImage *img = [UIImage imageNamed:SFCongressHighlightedButtonImage];
    return [img resizableImageWithCapInsets:UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f)];
}

+ (UIImage *)backButtonImage
{
    UIImage *img = [UIImage imageNamed:SFCongressBackButtonImage];
    return [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, img.size.width, 0, 0)];
}

+ (UIImage *)shareButtonImage
{
    UIImage *img = [UIImage imageNamed:SFCongressShareImage];
    return [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, img.size.width, 0, (img.size.width-10.0f))];
}

+ (UIImage *)menuButtonImage
{
    UIImage *img = [UIImage imageNamed:SFCongressMenuImage];
    return img;
//    return [img resizableImageWithCapInsets:UIEdgeInsetsMake(img.size.height, img.size.width, img.size.height, img.size.width) resizingMode:UIImageResizingModeTile];
}

+ (UIImage *)favoriteNavImage
{
    return [UIImage imageNamed:SFCongressFavoriteNavImage];
}

+ (UIImage *)favoritedCellBorderImage
{
    return [UIImage imageNamed:SFFavoritedCellBorder];
}

+ (UIImage *)favoritedPanelBorderImage
{
    return [UIImage imageNamed:SFFavoritedPanelBorder];
}

+ (UIImage *)favoritedCellIcon
{
    return [UIImage imageNamed:SFFavoritedCellIcon];
}

+ (UIImage *)favoritedCellTabImage
{
    UIImage *img = [UIImage imageNamed:SFFavoritedCellTabImage];
    UIEdgeInsets insets = UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f);
    return [img resizableImageWithCapInsets:insets];
}

+ (UIImage *)favoritedCellSelectedTabImage
{
    UIImage *img = [UIImage imageNamed:SFFavoritedCellSelectedTabImage];
    UIEdgeInsets insets = UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f);
    return [img resizableImageWithCapInsets:insets];
}

+ (UIImage *)mapExpandButton
{
    UIImage *img = [UIImage imageNamed:SFCongressMapExpandButton];
    return img;
}

+ (UIImage *)mapExpandSelectedButton
{
    UIImage *img = [UIImage imageNamed:SFCongressMapExpandSelectedButton];
    return img;
}

+ (UIImage *)mapCollapseButton
{
    UIImage *img = [UIImage imageNamed:SFCongressMapCollapseButton];
    return img;
}


+ (UIImage *)mapCollapseSelectedButton
{
    UIImage *img = [UIImage imageNamed:SFCongressMapCollapseSelectedButton];
    return img;
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

+ (UIImage *)searchBarBackgroundImage
{
    UIImage *img = [UIImage imageNamed:SFCongressSearchBarBackgroundImage];
    return img;
}

+ (UIImage *)searchBarAreaImage
{
    UIImage *img = [UIImage imageNamed:SFCongressSearchBarAreaImage];
    return img;
}

+ (UIImage *)searchBarCancelImage
{
    UIImage *img = [UIImage imageNamed:SFCongressSearchBarCancelImage];
    return img;
}

+ (UIImage *)searchBarIconImage
{
    UIImage *img = [UIImage imageNamed:SFCongressSearchBarIconImage];
    return img;
}

+ (UIImage *)calloutBoxBackgroundImage
{
    UIImage *img = [UIImage imageNamed:SFCongressCalloutImage];
    UIEdgeInsets insets = UIEdgeInsetsMake(1.0f, 30.0f, 10.0f, 1.0f);
    return [img resizableImageWithCapInsets:insets];
}

+ (UIImage *)cellAccessoryDisclosureImage
{
    UIImage *img = [UIImage imageNamed:SFCongressCellAccessoryDisclosureImage];
    return img;
}

+ (UIImage *)cellAccessoryDisclosureHighlightedImage
{
    UIImage *img = [UIImage imageNamed:SFCongressCellAccessoryDisclosureHighlightedImage];
    return img;
}

+ (UIImage *)photoFrame
{
    UIImage *img = [UIImage imageNamed:SFCongressPhotoFrame];
    UIEdgeInsets insets = UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f);
    return [img resizableImageWithCapInsets:insets];
}

+ (UIImage *)photoPlaceholderImage
{
    return [UIImage imageNamed:SFPhotoPlaceholderImage];
}

+ (UIImage *)facebookImage
{
    UIImage *img = [UIImage imageNamed:SFCongressFacebookImage];
    return img;
}

+ (UIImage *)twitterImage
{
    UIImage *img = [UIImage imageNamed:SFCongressTwitterImage];
    return img;

}

+ (UIImage *)youtubeImage
{
    UIImage *img = [UIImage imageNamed:SFCongressYoutubeImage];
    return img;
}

+ (UIImage *)settingsButtonImage
{
    UIImage *img = [UIImage imageNamed:SFCongressSettingsButtonImage];
    return img;
}

+ (UIImage *)settingsButtonSelectedImage
{
    UIImage *img = [UIImage imageNamed:SFCongressSettingsButtonSelectedImage];
    return img;
}

+ (UIImage *)sfLogoImage
{
    UIImage *img = [UIImage imageNamed:SFSunlightLogoImage];
    return img;
}

+ (UIImage *)favoritesHelpImage
{
    UIImage *img = [UIImage imageNamed:SFFavoritesHelpImage];
    return img;
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
    NSMutableAttributedString *linkString = [[NSMutableAttributedString alloc] initWithString:string];
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

+ (NSMutableAttributedString *)underlinedLinkStringFor:(NSString *)string
{
    NSMutableAttributedString *linkString = [NSMutableAttributedString underlinedLinkStringFor:string];
    NSRange stringRange = NSMakeRange(0, linkString.length);
    [linkString addAttribute:NSForegroundColorAttributeName value:[UIColor linkTextColor] range:stringRange];
    return linkString;
}

+ (NSMutableAttributedString *)underlinedHighlightedLinkStringFor:(NSString *)string
{
    NSMutableAttributedString *linkString = [NSMutableAttributedString underlinedLinkStringFor:string];
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
    [self _setUpSearchBarAppearance];
}

+ (void)_setUpSearchBarAppearance
{
    UISearchBar *searchBar = [UISearchBar appearance];
    [searchBar setBackgroundImage:[UIImage searchBarBackgroundImage]];
    [searchBar setSearchFieldBackgroundImage:[UIImage searchBarAreaImage] forState:UIControlStateNormal];
    [searchBar setImage:[UIImage searchBarIconImage] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [searchBar setImage:[UIImage searchBarCancelImage] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    [searchBar setScopeBarButtonBackgroundImage:[UIImage searchBarBackgroundImage] forState:UIControlStateNormal];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont searchBarFont]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor primaryTextColor]];
    [[UIButton appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundImage:nil forState:UIControlStateNormal];
    [[UIButton appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundImage:nil forState:UIControlStateHighlighted];
    [[UIButton appearanceWhenContainedIn:[UISearchBar class], nil] setTitleColor:[UIColor searchTextColor] forState:UIControlStateDisabled];
    [[UIButton appearanceWhenContainedIn:[UISearchBar class], nil] setTitleColor:[UIColor navigationBarTextColor] forState:UIControlStateNormal];
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
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
        setBackgroundImage:[UIImage barButtonDefaultBackgroundImage] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
        setBackgroundImage:[UIImage barButtonDefaultBackgroundImage] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
        setBackButtonBackgroundImage:[UIImage backButtonImage] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

}

@end
