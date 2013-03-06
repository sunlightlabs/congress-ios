//
//  SFCongressAppStyle.m
//  Congress
//
//  Created by Daniel Cloud on 3/6/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCongressAppStyle.h"

@implementation UIColor (SFCongressAppStyle)

static NSString * const SFCongressNavigationBarColor = @"70b6b6";
static NSString * const SFCongressPrimaryBackgroundColor = @"FAFBEB";
static NSString * const SFCongressMenuBackgroundColor = @"e6d53d";
static NSString * const SFCongressMenuFontColor = @"bcaa1a";
static NSString * const SFCongressMenuDividerColor = @"ede14f";

static NSString * const SFCongressNavigationBarBackgroundImage = @"NavigationBarBg.png";

+ (UIColor *)primaryBackgroundColor
{
    return [UIColor colorWithHex:SFCongressPrimaryBackgroundColor];
}

+ (UIColor *)menuBackgroundColor
{
    return [UIColor colorWithHex:SFCongressMenuBackgroundColor];
}

+ (UIColor *)menuFontColor
{
    return [UIColor colorWithHex:SFCongressMenuFontColor];
}

+ (UIColor *)menuDividerColor
{
    return [UIColor colorWithHex:SFCongressMenuDividerColor];
}

+ (UIColor *)navigationBarBackgroundColor
{
    return [UIColor colorWithHex:SFCongressNavigationBarColor];
}

@end


@implementation SFCongressAppStyle

+ (void)setUpGlobalStyles
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [self _setUpNavigationBarAppearance];
    [[UISegmentedControl appearance] setTintColor:[UIColor navigationBarBackgroundColor]];
//    [[UISegmentedControl appearance] setBackgroundImage:[UIImage imageNamed:SFCongressMenuBackgroundImage] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    [[UISearchBar appearance] setBackgroundImage:[UIImage imageNamed:SFCongressNavigationBarBackgroundImage]];
}

+ (void)_setUpNavigationBarAppearance
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:SFCongressNavigationBarBackgroundImage] forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:SFCongressNavigationBarBackgroundImage] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

@end
