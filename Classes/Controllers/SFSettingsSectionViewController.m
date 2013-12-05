//
//  SFSettingsSectionViewController.m
//  Congress
//
//  Created by Daniel Cloud on 3/11/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFSettingsSectionViewController.h"
#import "IIViewDeckController.h"
#import "SFSettingsSectionView.h"
#import "SFLabel.h"
#import "TTTAttributedLabel.h"
#import "SFCongressButton.h"
#import "SFCongressURLService.h"

@interface SFSettingsSectionViewController()  <UIGestureRecognizerDelegate, TTTAttributedLabelDelegate>

@end

@implementation SFSettingsSectionViewController
{
    SFSettingsSectionView *_settingsView;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.screenName = @"Settings Screen";
        self.restorationIdentifier = NSStringFromClass(self.class);
        self.title = @"Settings";
    }
    return self;
}

- (void)loadView
{
    _settingsView = [[SFSettingsSectionView alloc] initWithFrame:CGRectZero];
    _settingsView.frame = [[UIScreen mainScreen] applicationFrame];
    self.view = _settingsView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor primaryBackgroundColor];

    [_settingsView.disclaimerLabel setText:@"Sunlight uses Google Analytics to learn about aggregate usage of the app. Nothing personally identifiable is recorded."];

    [_settingsView.analyticsOptOutSwitchLabel setText:@"Enable anonymous analytics reporting."];

    [_settingsView.analyticsOptOutSwitch addTarget:self action:@selector(handleOptOutSwitch) forControlEvents:UIControlEventTouchUpInside];

    // This needs the same buttons as SFMainDeckTableViewController
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem menuButtonWithTarget:self.viewDeckController action:@selector(toggleLeftView)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_settingsView.scrollView flashScrollIndicators];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self resizeScrollView];
}

- (void)resizeScrollView
{
    UIView *bottomView = _settingsView.disclaimerLabel;
    [_settingsView.scrollView layoutIfNeeded];
    [_settingsView.scrollView setContentSize:CGSizeMake(_settingsView.width, bottomView.bottom+_settingsView.contentInset.bottom)];
}


#pragma mark - UIGestureRecognizerDelegate

- (void)handleLogoTouch:(UIPanGestureRecognizer *)recognizer
{
    NSURL *theURL = [NSURL URLWithString:@"http://sunlightfoundation.com/"];
    [[UIApplication sharedApplication] openURL:theURL];
}

#pragma mark - SFSettingsSectionViewController button actions

- (void)handleFeedbackButtonPress
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *subject = [NSString stringWithFormat:@"%@ - v%@", kSFContactEmailSubject, version];
    NSString *mailToURIString = [NSString stringWithFormat:@"mailto:%@?subject=%@", kSFContactEmailAddress, subject];
    NSURL *theURL = [NSURL URLWithString:[mailToURIString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    [[UIApplication sharedApplication] openURL:theURL];
}

- (void)handleJoinButtonPress
{
    NSURL *theURL = [NSURL URLWithString:@"http://sunlightfoundation.com/join"];
    [[UIApplication sharedApplication] openURL:theURL];
}

- (void)handleDonateButtonPress
{
    NSURL *theURL = [NSURL URLWithString:@"http://sunlightfoundation.com/donate"];
    [[UIApplication sharedApplication] openURL:theURL];
}

- (void)handleOptOutSwitch
{
    BOOL optOut = !_settingsView.analyticsOptOutSwitch.isOn;
    [[SFAppSettings sharedInstance] setGoogleAnalyticsOptOut:optOut];
}

#pragma mark - SFActivity

- (NSArray *)activityItems
{
    return @[@"Keep tabs on Capitol Hill: Use @congress_app to follow bills, contact legislators and more.",
             [SFCongressURLService globalLandingPage]];
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)theURL
{
    [[UIApplication sharedApplication] openURL:theURL];
}


#pragma mark - Application state

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {

    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {

    [super decodeRestorableStateWithCoder:coder];
}

@end
