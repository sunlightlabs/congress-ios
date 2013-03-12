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

static NSString * const SFCongressNavigationBarColor = @"70b6b6";
//static NSString * const SFCongressBarButtonTintColor = @"184969";

static NSString * const SFCongressMenuBackgroundColor = @"c64d22";
static NSString * const SFCongressMenuSelectionBgColor = @"b63c17";
static NSString * const SFCongressMenuTextColor = @"f2e1d1";
static NSString * const SFCongressMenuDividerBottomInsetColor = @"b63b19";
static NSString * const SFCongressMenuDividerBottomColor = @"d05b30";

static NSString * const SFCongressTableSeparatorColor = @"eeeed2";

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

+ (UIColor *)tableSeparatorColor
{
    return [UIColor colorWithHex:SFCongressTableSeparatorColor];
}

@end

@implementation UIFont (SFCongressAppStyle)

+ (UIFont *)navigationBarFont
{
    return [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:20.0f];
}

+ (UIFont *)menuFont
{
    return [UIFont fontWithName:@"EuphemiaUCAS" size:18.0f];
}

+ (UIFont *)menuSelectedFont
{
    return [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:18.0f];
}

@end

@implementation UIImage (SFCongressAppStyle)

static NSString * const SFCongressNavigationBarBackgroundImage = @"NavigationBarBg.png";

+ (UIImage *)barButtonDefaultBackgroundImage
{
    return [UIImage imageNamed:SFCongressNavigationBarBackgroundImage];
}

@end

@implementation SFCongressAppStyle

+ (void)setUpGlobalStyles
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [self _setUpNavigationBarAppearance];
    [[UISegmentedControl appearance] setTintColor:[UIColor navigationBarBackgroundColor]];
//    [[UISegmentedControl appearance] setBackgroundImage:[UIImage imageNamed:SFCongressMenuBackgroundImage] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [[UISearchBar appearance] setBackgroundImage:[UIImage barButtonDefaultBackgroundImage]];
}

+ (void)_setUpNavigationBarAppearance
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage barButtonDefaultBackgroundImage] forBarMetrics:UIBarMetricsDefault];
    [navBar setTitleTextAttributes:@{UITextAttributeFont: [UIFont navigationBarFont]}];
    [navBar setTitleVerticalPositionAdjustment:-4.0f forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage barButtonDefaultBackgroundImage] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

@end
