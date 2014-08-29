//
//  UIImage+SFCongressAppStyle.m
//  Congress
//
//  Created by Daniel Cloud on 5/30/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "UIImage+SFCongressAppStyle.h"

@implementation UIImage (SFCongressAppStyle)

static NSString *const SFCongressBackButtonImage = @"UIIconsBack";
static NSString *const SFCongressShareImage = @"UIIconsShare";
static NSString *const SFCongressMenuImage = @"UIIconsHamburger";

static NSString *const SFCongressCalloutImage = @"BillSummaryMainBack";

static NSString *const SFCongressMapExpandButton = @"LegislatorMapExpand";
static NSString *const SFCongressMapExpandSelectedButton = @"LegislatorMapExpandPress";
static NSString *const SFCongressMapCollapseButton = @"LegislatorMapCollapse";
static NSString *const SFCongressMapCollapseSelectedButton = @"LegislatorMapCollapsePress";

static NSString *const SFCongressDefaultButtonImage = @"Button";
static NSString *const SFCongressHighlightedButtonImage = @"ButtonPress";

static NSString *const SFCongressFollowingNavImage = @"FavoriteNav";
static NSString *const SFCongressFollowingNavButtonImage = @"FavoriteNavButton";

static NSString *const SFFollowedCellBorder = @"FavoritedListBorder";
static NSString *const SFFollowedCellIcon = @"FavoriteList";
static NSString *const SFFollowedCellTabImage = @"ParentListItem";
static NSString *const SFFollowedCellSelectedTabImage = @"ParentListItemPress";
static NSString *const SFFollowedPanelBorder = @"FavoritedSubListBorder";

static NSString *const SFPhotoPlaceholderImage = @"LegislatorNoImage";

static NSString *const SFCongressCellAccessoryDisclosureImage = @"UINavListArrow";
static NSString *const SFCongressCellAccessoryDisclosureHighlightedImage = @"UINavListArrowPress";

static NSString *const SFCongressFacebookImage = @"LegislatorContactFacebook";
static NSString *const SFCongressTwitterImage = @"LegislatorContactTwitter";
static NSString *const SFCongressYoutubeImage = @"LegislatorContactYouTube";
static NSString *const SFCongressWebsiteImage = @"LinkIcon";

static NSString *const SFCongressPhotoFrame = @"LegislatorBorderBg";

static NSString *const SFCongressSettingsButtonImage = @"NavSettings";
static NSString *const SFCongressSettingsButtonSelectedImage = @"NavSettingsActive";

static NSString *const SFCongressClearImage = @"ClearImage";

static NSString *const SFOpenCongressLogoImage = @"OpenCongress";
static NSString *const SFSunlightLogoImage = @"SunlightFoundation";

static NSString *const SFFollowingHelpImage = @"FollowScreen_intro";
static NSString *const SFFollowedSelectedImage = @"FavoriteSelected";
static NSString *const SFFollowedUnselectedImage = @"FavoriteUnselected";

static NSString *const SFLocationImage = @"LocationIcon";
static NSString *const SFCalendarImage = @"CalendarIcon";
static NSString *const SFDownloadImage = @"Download";
static NSString *const SFCloudDownloadImage = @"CloudDownload";

+ (UIImage *)clearImage {
    return [UIImage imageNamed:SFCongressClearImage];
}

+ (UIImage *)buttonDefaultBackgroundImage {
    UIImage *img = [UIImage imageNamed:SFCongressDefaultButtonImage];
    return [img resizableImageWithCapInsets:UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f)];
}

+ (UIImage *)buttonSelectedBackgroundImage {
    UIImage *img = [UIImage imageNamed:SFCongressHighlightedButtonImage];
    return [img resizableImageWithCapInsets:UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f)];
}

+ (UIImage *)backButtonImage {
    UIImage *img = [UIImage imageNamed:SFCongressBackButtonImage];
    img = [img imageWithAlignmentRectInsets:UIEdgeInsetsMake(4.0f, 0, 4.0f, 0)];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return img;
}

+ (UIImage *)shareButtonImage {
    UIImage *img = [UIImage imageNamed:SFCongressShareImage];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, img.size.width, 0, (img.size.width - 10.0f))];
    if ([img respondsToSelector:@selector(imageWithRenderingMode:)]) {
//        img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return img;
}

+ (UIImage *)menuButtonImage {
    UIImage *img = [UIImage imageNamed:SFCongressMenuImage];
    if ([img respondsToSelector:@selector(imageWithRenderingMode:)]) {
        //        img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return img;
}

+ (UIImage *)followingNavImage {
    return [UIImage imageNamed:SFCongressFollowingNavImage];
}

+ (UIImage *)followingNavButtonImage {
    UIImage *img = [UIImage imageNamed:SFCongressFollowingNavButtonImage];
    if ([img respondsToSelector:@selector(imageWithRenderingMode:)]) {
        img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return img;
}

+ (UIImage *)followedCellBorderImage {
    return [UIImage imageNamed:SFFollowedCellBorder];
}

+ (UIImage *)followedPanelBorderImage {
    return [UIImage imageNamed:SFFollowedPanelBorder];
}

+ (UIImage *)followedCellIcon {
    return [UIImage imageNamed:SFFollowedCellIcon];
}

+ (UIImage *)followedCellTabImage {
    UIImage *img = [UIImage imageNamed:SFFollowedCellTabImage];
    UIEdgeInsets insets = UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f);
    return [img resizableImageWithCapInsets:insets];
}

+ (UIImage *)followedCellSelectedTabImage {
    UIImage *img = [UIImage imageNamed:SFFollowedCellSelectedTabImage];
    UIEdgeInsets insets = UIEdgeInsetsMake(1.0f, 1.0f, 1.0f, 1.0f);
    return [img resizableImageWithCapInsets:insets];
}

+ (UIImage *)mapExpandButton {
    UIImage *img = [UIImage imageNamed:SFCongressMapExpandButton];
    return img;
}

+ (UIImage *)mapExpandSelectedButton {
    UIImage *img = [UIImage imageNamed:SFCongressMapExpandSelectedButton];
    return img;
}

+ (UIImage *)mapCollapseButton {
    UIImage *img = [UIImage imageNamed:SFCongressMapCollapseButton];
    return img;
}

+ (UIImage *)mapCollapseSelectedButton {
    UIImage *img = [UIImage imageNamed:SFCongressMapCollapseSelectedButton];
    return img;
}

+ (UIImage *)calloutBoxBackgroundImage {
    UIImage *img = [UIImage imageNamed:SFCongressCalloutImage];
    UIEdgeInsets insets = UIEdgeInsetsMake(1.0f, 30.0f, 10.0f, 1.0f);
    return [img resizableImageWithCapInsets:insets];
}

+ (UIImage *)cellAccessoryDisclosureImage {
    UIImage *img = [UIImage imageNamed:SFCongressCellAccessoryDisclosureImage];
    return img;
}

+ (UIImage *)cellAccessoryDisclosureHighlightedImage {
    UIImage *img = [UIImage imageNamed:SFCongressCellAccessoryDisclosureHighlightedImage];
    return img;
}

+ (UIImage *)photoFrame {
    UIImage *img = [UIImage imageNamed:SFCongressPhotoFrame];
    UIEdgeInsets insets = UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f);
    return [img resizableImageWithCapInsets:insets];
}

+ (UIImage *)photoPlaceholderImage {
    return [UIImage imageNamed:SFPhotoPlaceholderImage];
}

+ (UIImage *)facebookImage {
    UIImage *img = [UIImage imageNamed:SFCongressFacebookImage];
    return img;
}

+ (UIImage *)twitterImage {
    UIImage *img = [UIImage imageNamed:SFCongressTwitterImage];
    return img;
}

+ (UIImage *)youtubeImage {
    UIImage *img = [UIImage imageNamed:SFCongressYoutubeImage];
    return img;
}

+ (UIImage *)websiteImage {
    UIImage *img = [UIImage imageNamed:SFCongressWebsiteImage];
    return img;
}

+ (UIImage *)settingsButtonImage {
    UIImage *img = [UIImage imageNamed:SFCongressSettingsButtonImage];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return img;
}

+ (UIImage *)infoButtonImage {
    UIImage *img = [UIImage imageNamed:@"Info"];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return img;
}

+ (UIImage *)ocLogoImage {
    UIImage *img = [UIImage imageNamed:SFOpenCongressLogoImage];
    return img;
}

+ (UIImage *)sfLogoImage {
    UIImage *img = [UIImage imageNamed:SFSunlightLogoImage];
    return img;
}

+ (UIImage *)followingHelpImage {
    UIImage *img = [UIImage imageNamed:SFFollowingHelpImage];
    return img;
}

+ (UIImage *)followIsSelectedImage {
    UIImage *img = [UIImage imageNamed:SFFollowedSelectedImage];
    return img;
}

+ (UIImage *)followUnselectedImage {
    UIImage *img = [UIImage imageNamed:SFFollowedUnselectedImage];
    return img;
}

+ (UIImage *)locationButtonImage {
    UIImage *img = [UIImage imageNamed:SFLocationImage];
    if ([img respondsToSelector:@selector(imageWithRenderingMode:)]) {
        img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return img;
}

+ (UIImage *)calendarButtonImage {
    UIImage *img = [UIImage imageNamed:SFCalendarImage];
    if ([img respondsToSelector:@selector(imageWithRenderingMode:)]) {
        img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return img;
}

+ (UIImage *)downloadImage {
    UIImage *img = [UIImage imageNamed:SFDownloadImage];
    if ([img respondsToSelector:@selector(imageWithRenderingMode:)]) {
        img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return img;
}

+ (UIImage *)cloudDownloadImage {
    UIImage *img = [UIImage imageNamed:SFCloudDownloadImage];
    if ([img respondsToSelector:@selector(imageWithRenderingMode:)]) {
        img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return img;
}

@end
