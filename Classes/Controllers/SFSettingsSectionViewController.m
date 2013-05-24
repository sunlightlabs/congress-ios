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
#import "SFCongressButton.h"
#import "GAI.h"
#import "SFCongressURLService.h"

@implementation SFSettingsSectionViewController
{
    SFSettingsSectionView *_settingsView;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.trackedViewName = @"Settings Screen";
        self.restorationIdentifier = NSStringFromClass(self.class);
        self.title = @"Info";
        _settingsView = [[SFSettingsSectionView alloc] initWithFrame:CGRectZero];
        _shareableObjects = [NSMutableArray array];
        [_shareableObjects addObject:@"Keep tabs on Capitol Hill: Use the Sunlight Foundation's Congress app to follow bills, contact legislators and more."];
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

    NSMutableAttributedString *headerText = [[NSMutableAttributedString alloc] initWithString:@"ABOUT " attributes:@{NSFontAttributeName: [UIFont subitleStrongFont]}];
    [headerText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"Congress" attributes:@{NSFontAttributeName: [UIFont subitleEmFont]}]];
    _settingsView.headerLabel.attributedText = headerText;

    _settingsView.descriptionView.delegate = self;
    NSString *aboutPath = [[NSBundle mainBundle] pathForResource:@"about.html" ofType:nil];
    NSURL *aboutURL = [NSURL fileURLWithPath:aboutPath];
    [_settingsView.descriptionView loadURL:aboutURL];

    [_settingsView.disclaimerLabel setText:@"Sunlight uses Google Analytics to learn about aggregate usage of the app. Nothing personally identifiable is recorded."];

    [_settingsView.feedbackButton addTarget:self action:@selector(handleFeedbackButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [_settingsView.joinButton addTarget:self action:@selector(handleJoinButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [_settingsView.donateButton addTarget:self action:@selector(handleDonateButtonPress) forControlEvents:UIControlEventTouchUpInside];

    // This needs the same buttons as SFMainDeckTableViewController
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem menuButtonWithTarget:self.viewDeckController action:@selector(toggleLeftView)];

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Action List Screen"];
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

#pragma mark - SFSettingsSectionViewController button actions

- (void)handleEditFavoritesPress
{
    SFEditFavoritesViewController *editFavoritesVC = [[SFEditFavoritesViewController alloc] init];
    [self.navigationController pushViewController:editFavoritesVC animated:YES];
}

- (void)handleFeedbackButtonPress
{
    NSString *mailToURIString = [NSString stringWithFormat:@"mailto:%@?subject=%@", kSFContactEmailAddress, kSFContactEmailSubject];
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

#pragma mark - SSWebViewDelegate

- (BOOL)webView:(SSWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)aRequest navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[aRequest URL]];
        return NO;
    }

    return YES;
}

- (void)webViewDidFinishLoad:(SSWebView *)aWebView
{
    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    aWebView.frame = frame;
    frame.size.height = aWebView.scrollView.contentSize.height;
    aWebView.frame = frame;
    [self.view layoutSubviews];
}

#pragma mark - Application state

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {

    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {

    [super decodeRestorableStateWithCoder:coder];
}

@end
