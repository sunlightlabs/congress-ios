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
#import "SFDataTableViewController.h"
#import "SFSettingsDataSource.h"
#import "SFSettingCell.h"

@interface SFSettingsSectionViewController()  <UIGestureRecognizerDelegate, TTTAttributedLabelDelegate, UITableViewDelegate>

@end

@implementation SFSettingsSectionViewController
{
    SFSettingsSectionView *_settingsView;
    SFDataTableViewController *_settingsTableVC;
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
    _settingsView = [[SFSettingsSectionView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = _settingsView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor primaryBackgroundColor];

    [self _initializeTable];
    [_settingsView.settingsTable removeFromSuperview];
    _settingsView.settingsTable = _settingsTableVC.tableView;
    [_settingsView.scrollView addSubview:_settingsView.settingsTable];
    [_settingsTableVC didMoveToParentViewController:self];
    [_settingsView setNeedsUpdateConstraints];

    [_settingsView.disclaimerLabel setText:@"Sunlight uses Google Analytics to learn about aggregate usage of the app. Nothing personally identifiable is recorded."];

    [_settingsView.analyticsOptOutSwitchLabel setText:@"Enable anonymous analytics reporting."];

    [_settingsView.analyticsOptOutSwitch addTarget:self action:@selector(handleOptOutSwitch) forControlEvents:UIControlEventTouchUpInside];

    // This needs the same buttons as SFMainDeckTableViewController
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem menuButtonWithTarget:self.viewDeckController action:@selector(toggleLeftView)];

//    NSArray *tableCells = _settingsTableVC.tableView

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
    UIView *bottomView = _settingsView.settingsTable;
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

#pragma mark - Private

- (void)_initializeTable
{
    _settingsTableVC = [[SFDataTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    _settingsTableVC.dataProvider = [SFSettingsDataSource new]; // This data source holds data we need
    [_settingsTableVC.tableView registerClass:[SFSettingCell class] forCellReuseIdentifier:NSStringFromClass([SFSettingCell class])];
    [_settingsTableVC.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_settingsTableVC.tableView setAllowsSelection:NO];
    _settingsTableVC.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [_settingsTableVC.tableView setScrollEnabled:NO];
    _settingsTableVC.tableView.delegate = self;

    [self addChildViewController:_settingsTableVC];
}

@end
