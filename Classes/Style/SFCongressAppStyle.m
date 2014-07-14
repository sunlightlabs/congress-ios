//
//  SFCongressAppStyle.m
//  Congress
//
//  Created by Daniel Cloud on 3/6/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCongressAppStyle.h"
#import "SFCongressTableViewController.h"

@implementation UIColor (SFCongressAppStyle)

static NSString * const SFCongressDefaultTintColor             = @"1F748D";

static NSString *const SFCongressPrimaryBackgroundColor       = @"FAFBEB";
static NSString *const SFCongressSecondaryBackgroundColor     = @"f5f4da";
static NSString *const SFCongressSearchTextColor              = @"fcfcee";

static NSString *const SFCongressPrimaryTextColor             = @"434338";
static NSString *const SFCongressSecondaryTextColor           = @"67675d";
static NSString *const SFCongressLinkTextColor                = @"c8a70d";
static NSString *const SFCongressPrimaryHighlightColor        = @"c53f24";
static NSString *const SFCongressSecondaryHighlightColor      = @"e47c68";

static NSString *const SFCongressNavigationBarColor           = @"70b6b7";
static NSString *const SFCongressNavigationBarTextColor       = @"fcfcee";
static NSString *const SFCongressNavigationBarTextShadowColor = @"4c918f";

static NSString *const SFCongressMenuBackgroundColor          = @"c64d22";
static NSString *const SFCongressMenuSelectionBgColor         = @"b63c17";
static NSString *const SFCongressMenuTextColor                = @"f2e1d1";
static NSString *const SFCongressMenuDividerBottomInsetColor  = @"b63b19";
static NSString *const SFCongressMenuDividerBottomColor       = @"d05b30";

static NSString *const SFCongressTableSeparatorColor          = @"e9e8cf";
static NSString *const SFCongressTableHeaderTextColor         = @"828875";
static NSString *const SFCongressTableHeaderBackgroundColor   = @"e7e9ce";
static NSString *const SFCongressTableCellSelectedColor       = @"e9e8cf";

static NSString *const SFCongressDetailLineColor              = @"e9e8cf";
static NSString *const SFCongressMapBorderLineColor           = @"d6d5bc";

+ (UIColor *)defaultTintColor {
//    return [UIColor sam_colorWithHex:SFCongressDefaultTintColor];
    return [UIColor colorWithRed:0.18f green:0.44f blue:0.51f alpha:1.00f];
}

+ (UIColor *)primaryBackgroundColor {
    return [UIColor sam_colorWithHex:SFCongressPrimaryBackgroundColor];
}

+ (UIColor *)secondaryBackgroundColor {
    return [UIColor sam_colorWithHex:SFCongressSecondaryBackgroundColor];
}

+ (UIColor *)selectedCellBackgroundColor {
    return [UIColor sam_colorWithHex:SFCongressTableCellSelectedColor];
}

+ (UIColor *)menuBackgroundColor {
    return [UIColor sam_colorWithHex:SFCongressMenuBackgroundColor];
}

+ (UIColor *)menuSelectionBackgroundColor {
    return [UIColor sam_colorWithHex:SFCongressMenuSelectionBgColor];
}

+ (UIColor *)menuTextColor {
    return [UIColor sam_colorWithHex:SFCongressMenuTextColor];
}

+ (UIColor *)segmentedControlTintColor {
    return [UIColor sam_colorWithHex:SFCongressNavigationBarColor];
}

+ (UIColor *)primaryTextColor {
    return [UIColor sam_colorWithHex:SFCongressPrimaryTextColor];
}

+ (UIColor *)secondaryTextColor {
    return [UIColor sam_colorWithHex:SFCongressSecondaryTextColor];
}

+ (UIColor *)linkTextColor {
    return [UIColor sam_colorWithHex:SFCongressLinkTextColor];
}

+ (UIColor *)linkHighlightedTextColor {
    return [UIColor sam_colorWithHex:SFCongressPrimaryHighlightColor];
}

+ (UIColor *)menuDividerBottomInsetColor {
    return [UIColor sam_colorWithHex:SFCongressMenuDividerBottomInsetColor];
}

+ (UIColor *)menuDividerBottomColor {
    return [UIColor sam_colorWithHex:SFCongressMenuDividerBottomColor];
}

+ (UIColor *)navigationBarBackgroundColor {
    return [UIColor sam_colorWithHex:SFCongressNavigationBarColor];
}

+ (UIColor *)navigationBarTextColor {
    return [UIColor sam_colorWithHex:SFCongressNavigationBarTextColor];
}

+ (UIColor *)navigationBarTextShadowColor {
    return [UIColor sam_colorWithHex:SFCongressNavigationBarTextShadowColor];
}

+ (UIColor *)tableSeparatorColor {
    return [UIColor sam_colorWithHex:SFCongressTableSeparatorColor];
}

+ (UIColor *)tableHeaderTextColor {
    return [UIColor sam_colorWithHex:SFCongressTableHeaderTextColor];
}

+ (UIColor *)tableHeaderBackgroundColor {
    return [UIColor sam_colorWithHex:SFCongressTableHeaderBackgroundColor];
}

+ (UIColor *)titleColor {
    return [UIColor sam_colorWithHex:SFCongressPrimaryTextColor];
}

+ (UIColor *)subtitleColor {
    return [UIColor sam_colorWithHex:SFCongressSecondaryTextColor];
}

+ (UIColor *)detailLineColor {
    return [UIColor sam_colorWithHex:SFCongressDetailLineColor];
}

+ (UIColor *)primaryHighlightColor {
    return [UIColor sam_colorWithHex:SFCongressPrimaryHighlightColor];
}

+ (UIColor *)secondaryHighlightColor {
    return [UIColor sam_colorWithHex:SFCongressSecondaryHighlightColor];
}

+ (UIColor *)searchTextColor {
    return [UIColor sam_colorWithHex:SFCongressSearchTextColor];
}

+ (UIColor *)mapBorderLineColor {
    return [UIColor sam_colorWithHex:SFCongressMapBorderLineColor];
}

@end

@implementation UIFont (SFCongressAppStyle)

+ (UIFont *)navigationBarFont {
    return [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:19.0f];
}

+ (UIFont *)menuFont {
    return [UIFont fontWithName:@"EuphemiaUCAS" size:18.0f];
}

+ (UIFont *)menuSelectedFont {
    return [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:18.0f];
}

+ (UIFont *)buttonFont {
    return [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:18.0f];
}

+ (UIFont *)bodyTextFont {
    return [UIFont fontWithName:@"HoeflerText-Regular" size:13.0f];
}

+ (UIFont *)bodySmallFont {
    return [UIFont fontWithName:@"HoeflerText-Regular" size:12.0f];
}

+ (UIFont *)billTitleFont {
    return [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
}

+ (UIFont *)subitleFont {
    return [UIFont fontWithName:@"Helvetica" size:10.0f];
}

+ (UIFont *)subitleStrongFont {
    return [UIFont fontWithName:@"Helvetica-Bold" size:10.0f];
}

+ (UIFont *)subitleEmFont {
    return [UIFont fontWithName:@"HoeflerText-Italic" size:13.0f];
}

+ (UIFont *)legislatorTitleFont {
    return [UIFont fontWithName:@"EuphemiaUCAS-Bold" size:15.0f];
}

+ (UIFont *)linkFont {
    return [UIFont fontWithName:@"Helvetica-Bold" size:13.0f];
}

+ (UIFont *)cellTextFont {
    return [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];
}

+ (UIFont *)cellImportantDetailFont {
    return [UIFont fontWithName:@"Helvetica" size:13.0f];
}

+ (UIFont *)cellSecondaryDetailFont {
    return [UIFont fontWithName:@"Helvetica-Bold" size:10.0f];
}

+ (UIFont *)cellDecorativeDetailFont {
    return [UIFont fontWithName:@"HoeflerText-Italic" size:11.0f];
}

+ (UIFont *)tableSectionHeaderFont {
    return [UIFont fontWithName:@"Helvetica-Bold" size:10.0f];
}

+ (UIFont *)searchBarFont {
    return [UIFont fontWithName:@"Helvetica" size:14.0f];
}

+ (UIFont *)selectedSegmentFont {
    return [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
}

+ (UIFont *)unselectedSegmentFont {
    return [UIFont fontWithName:@"Helvetica" size:12.0f];
}

@end

@implementation NSMutableAttributedString (SFCongressAppStyle)

+ (NSMutableAttributedString *)underlinedStringFor:(NSString *)string {
    NSMutableAttributedString *linkString = [[NSMutableAttributedString alloc] initWithString:string];
    [linkString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, linkString.length)];
    return linkString;
}

+ (NSMutableAttributedString *)linkStringFor:(NSString *)string {
    NSMutableAttributedString *linkString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange stringRange = NSMakeRange(0, linkString.length);
    [linkString addAttribute:NSForegroundColorAttributeName value:[UIColor linkTextColor] range:stringRange];
    return linkString;
}

+ (NSMutableAttributedString *)highlightedLinkStringFor:(NSString *)string {
    NSMutableAttributedString *linkString = [NSMutableAttributedString linkStringFor:string];
    NSRange stringRange = NSMakeRange(0, linkString.length);
    [linkString addAttribute:NSForegroundColorAttributeName value:[UIColor linkHighlightedTextColor] range:stringRange];
    return linkString;
}

+ (NSMutableAttributedString *)underlinedLinkStringFor:(NSString *)string {
    NSMutableAttributedString *linkString = [NSMutableAttributedString underlinedLinkStringFor:string];
    NSRange stringRange = NSMakeRange(0, linkString.length);
    [linkString addAttribute:NSForegroundColorAttributeName value:[UIColor linkTextColor] range:stringRange];
    return linkString;
}

+ (NSMutableAttributedString *)underlinedHighlightedLinkStringFor:(NSString *)string {
    NSMutableAttributedString *linkString = [NSMutableAttributedString underlinedLinkStringFor:string];
    NSRange stringRange = NSMakeRange(0, linkString.length);
    [linkString addAttribute:NSForegroundColorAttributeName value:[UIColor linkHighlightedTextColor] range:stringRange];
    return linkString;
}

@end

@implementation NSParagraphStyle (SFCongressAppStyle)

static CGFloat const SFCongressParagraphLineSpacing = 6.0f;

+ (NSParagraphStyle *)congressParagraphStyle {
    NSMutableParagraphStyle *object = [[NSMutableParagraphStyle alloc] init];
    object.lineSpacing = SFCongressParagraphLineSpacing;
    object.paragraphSpacing = floorf(SFCongressParagraphLineSpacing * 2);

    return (NSParagraphStyle *)object;
}

+ (CGFloat)lineSpacing {
    return SFCongressParagraphLineSpacing;
}

@end

@implementation SFCongressAppStyle

+ (void)setUpGlobalStyles {
    NSInteger statusBarStyleValue;
    UITableView *tableViewStyle = [UITableView appearance];
    tableViewStyle.sectionIndexColor = [UIColor primaryTextColor];

    __weak UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.backgroundColor = [UIColor primaryBackgroundColor];

    statusBarStyleValue = UIStatusBarStyleLightContent;
    tableViewStyle.sectionIndexBackgroundColor = [UIColor clearColor];
    window.tintColor = [UIColor defaultTintColor];

    UIToolbar *toolBar = [UIToolbar appearance];
    [toolBar setBarTintColor:[UIColor navigationBarBackgroundColor]];
    [toolBar setTintColor:[UIColor defaultTintColor]];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self _setUpNavigationBarAppearance];
    [self _setUpSegmentedControlAppearance];
    [self _setUpSearchBarAppearance];
    [self _setUpSwitchAppearance];

    [SFMessage addCustomDesignFromFileWithName:@"messagestyles.json"];
}

+ (void)_setUpSearchBarAppearance {
    UISearchBar *searchBar = [UISearchBar appearance];
    [searchBar setBarStyle:UIBarStyleDefault];
    [searchBar setSearchBarStyle:UISearchBarStyleMinimal];

    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont searchBarFont]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor primaryTextColor]];
    [[UIButton appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundImage:nil forState:UIControlStateNormal];
    [[UIButton appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundImage:nil forState:UIControlStateHighlighted];
    [[UIButton appearanceWhenContainedIn:[UISearchBar class], nil] setTitleColor:[UIColor searchTextColor] forState:UIControlStateDisabled];
    [[UIButton appearanceWhenContainedIn:[UISearchBar class], nil] setTitleColor:[UIColor navigationBarTextColor] forState:UIControlStateNormal];
}

+ (void)_setUpSegmentedControlAppearance {
    UISegmentedControl *sControl = [UISegmentedControl appearance];
    [sControl setTintColor:[UIColor segmentedControlTintColor]];
    [sControl setTitleTextAttributes:@{
         NSForegroundColorAttributeName :[UIColor navigationBarTextColor],
         NSFontAttributeName:[UIFont selectedSegmentFont]
     } forState:UIControlStateSelected];
    [sControl setTitleTextAttributes:@{
         NSForegroundColorAttributeName: [UIColor segmentedControlTintColor],
         NSFontAttributeName: [UIFont unselectedSegmentFont]
     } forState:UIControlStateNormal];
}

+ (void)_setUpNavigationBarAppearance {
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.barTintColor =[UIColor navigationBarBackgroundColor];
    navBar.shadowImage = [UIImage new];
    navBar.tintColor = [UIColor navigationBarTextColor];
    navBar.titleTextAttributes = @{
         NSFontAttributeName :[UIFont navigationBarFont],
         NSForegroundColorAttributeName:[UIColor navigationBarTextColor]
    };
    navBar.backIndicatorImage = [UIImage backButtonImage];
    navBar.backIndicatorTransitionMaskImage = navBar.backIndicatorImage;
}

+ (void)_setUpSwitchAppearance {
    UISwitch *switchApperance = [UISwitch appearance];
    [switchApperance setOnTintColor:[UIColor navigationBarBackgroundColor]];
    [switchApperance setTintColor:[UIColor sam_colorWithHex:@"CCCCCC"]];
}

@end
