//
//  SFSettingsSectionViewController.m
//  Congress
//
//  Created by Daniel Cloud on 3/11/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFSettingsSectionViewController.h"
#import "IIViewDeckController.h"
#import "SFEditFavoritesViewController.h"
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
        self.title = @"Info";
        _settingsView = [[SFSettingsSectionView alloc] initWithFrame:CGRectZero];
        _shareableObjects = [NSMutableArray array];
        [_shareableObjects addObject:@"Keep tabs on Capitol Hill: Use @congress_app to follow bills, contact legislators and more."];
        [_shareableObjects addObject:[SFCongressURLService globalLandingPage]];

    }
    return self;
}

- (void)loadView
{
    _settingsView.frame = [[UIScreen mainScreen] applicationFrame];
    _settingsView.autoresizesSubviews = YES;
    self.view = _settingsView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor primaryBackgroundColor];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    NSMutableAttributedString *headerText = [[NSMutableAttributedString alloc] initWithString:@"ABOUT " attributes:@{NSFontAttributeName: [UIFont subitleStrongFont]}];
    [headerText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Congress  v%@", version] attributes:@{NSFontAttributeName: [UIFont subitleEmFont]}]];
    _settingsView.headerLabel.attributedText = headerText;

    NSDictionary *descriptionAttributes = @{ NSParagraphStyleAttributeName: [NSParagraphStyle congressParagraphStyle],
                                             NSForegroundColorAttributeName: [UIColor primaryTextColor],
                                             NSFontAttributeName: [UIFont bodyTextFont]
                                            };
    _settingsView.descriptionLabel.delegate = self;
    _settingsView.descriptionLabel.dataDetectorTypes = UIDataDetectorTypeAll;
    NSAttributedString *descriptionText = [[NSAttributedString alloc] initWithString:@"This app is made by the Sunlight Foundation, a nonpartisan nonprofit dedicated to increasing government transparency through the power of technology.\nThe data for Sunlight Congress comes directly from official congressional sources via the Sunlight Congress API and district boundaries come from the U.S. Census Bureau.\nMaps powered by MapBox. View terms, conditions and attribution for map data." attributes:descriptionAttributes];
    [_settingsView.descriptionLabel setText:descriptionText];
    _settingsView.descriptionLabel.linkAttributes = @{ NSForegroundColorAttributeName: [UIColor linkTextColor],
                                                       NSFontAttributeName: [UIFont linkFont],
                                                       NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
    _settingsView.descriptionLabel.activeLinkAttributes = @{ NSForegroundColorAttributeName: [UIColor linkHighlightedTextColor],
                                                             NSFontAttributeName: [UIFont linkFont],
                                                             NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
    NSDictionary *links = @{
                            @"Sunlight Foundation": @"http://sunlightfoundation.com/",
                            @"Sunlight Congress API": @"http://sunlightlabs.github.io/congress/",
                            @"U.S. Census Bureau": @"http://www.census.gov/geo/maps-data/data/tiger-line.html",
                            @"MapBox": @"http://www.mapbox.com/",
                            @"terms, conditions and attribution": @"http://www.mapbox.com/about/maps/",
                            };
    [links enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSRange range = [_settingsView.descriptionLabel.text rangeOfString:key];
        [_settingsView.descriptionLabel addLinkToURL:[NSURL URLWithString:obj] withRange:range];
    }];


    [_settingsView.disclaimerLabel setText:@"Sunlight uses Google Analytics to learn about aggregate usage of the app. Nothing personally identifiable is recorded."];
    [_settingsView.analyticsOptOutSwitchLabel setText:@"Enable anonymous analytics reporting."];

    [_settingsView.feedbackButton addTarget:self action:@selector(handleFeedbackButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [_settingsView.joinButton addTarget:self action:@selector(handleJoinButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [_settingsView.donateButton addTarget:self action:@selector(handleDonateButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [_settingsView.analyticsOptOutSwitch addTarget:self action:@selector(handleOptOutSwitch) forControlEvents:UIControlEventTouchUpInside];

    _settingsView.logoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *logoTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLogoTouch:)];
    logoTapRecognizer.numberOfTapsRequired = 1;
    logoTapRecognizer.numberOfTouchesRequired = 1;
    logoTapRecognizer.delegate = self;
    [_settingsView.logoView addGestureRecognizer:logoTapRecognizer];

    // This needs the same buttons as SFMainDeckTableViewController
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem menuButtonWithTarget:self.viewDeckController action:@selector(toggleLeftView)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_settingsView.scrollView flashScrollIndicators];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIGestureRecognizerDelegate

- (void)handleLogoTouch:(UIPanGestureRecognizer *)recognizer
{
    NSURL *theURL = [NSURL URLWithString:@"http://sunlightfoundation.com/"];
    [[UIApplication sharedApplication] openURL:theURL];
}

#pragma mark - SFSettingsSectionViewController button actions

- (void)handleEditFavoritesPress
{
    SFEditFavoritesViewController *editFavoritesVC = [[SFEditFavoritesViewController alloc] init];
    [self.navigationController pushViewController:editFavoritesVC animated:YES];
}

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
