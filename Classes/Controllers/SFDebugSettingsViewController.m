//
//  SFDebugSettingsViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 9/5/14.
//  Copyright (c) 2014 Sunlight Foundation. All rights reserved.
//

#import "SFDebugSettingsViewController.h"
#import "SFDataTableViewController.h"
#import "SFSettingsSectionView.h"
#import "SFDebugSettingsDataSource.h"
#import "SFSettingCell.h"

@interface SFDebugSettingsViewController () <UITableViewDelegate>

@end

@implementation SFDebugSettingsViewController {
    SFSettingsSectionView *_settingsView;
    SFDataTableViewController *_settingsTableVC;
}

- (id)init {
    self = [super init];
    if (self) {
        self.screenName = @"Debug Settings";
        self.restorationIdentifier = NSStringFromClass(self.class);
        self.title = @"Debug Settings";
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView {
    _settingsView = [[SFSettingsSectionView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = _settingsView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor primaryBackgroundColor];
    
    [self _initializeTable];
    [_settingsView.settingsTable removeFromSuperview];
    _settingsView.settingsTable = _settingsTableVC.tableView;
    [_settingsView.scrollView addSubview:_settingsView.settingsTable];
    [_settingsTableVC didMoveToParentViewController:self];
    [_settingsView setNeedsUpdateConstraints];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_settingsView updateConstraints];
    [self resizeScrollView];
    [_settingsView.scrollView flashScrollIndicators];
}

- (void)viewWillLayoutSubviews {
    [_settingsView updateConstraints];
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self resizeScrollView];
}

- (void)resizeScrollView {
    UIView *bottomView = _settingsView.settingsTable;
    [_settingsView.scrollView layoutIfNeeded];
    [_settingsView.scrollView setContentSize:CGSizeMake(_settingsView.width, bottomView.bottom + _settingsView.contentInset.bottom)];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFCellData *cellData = [_settingsTableVC.dataProvider cellDataForItemAtIndexPath:indexPath];
    
    CGFloat cellHeight = [cellData heightForWidth:tableView.width];
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFCellData *cellData = [_settingsTableVC.dataProvider cellDataForItemAtIndexPath:indexPath];
    
    CGFloat cellHeight = [cellData heightForWidth:tableView.width - 50];
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    if ([_settingsTableVC.dataProvider.sectionTitles count]) {
        return 24.0f;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([_settingsTableVC.dataProvider.sectionTitles count]) {
        return 24.0f;
    }
    return 0;
}

#pragma mark - UIApplicationWillEnterForegroundNotification handler

- (void)handleAppWillEnterForeground:(NSNotification *)notification {
    [_settingsView.settingsTable reloadData];
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)theURL {
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

- (void)_initializeTable {
    _settingsTableVC = [[SFDataTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    _settingsTableVC.dataProvider = [SFDebugSettingsDataSource new]; // This data source holds data we need
    [_settingsTableVC.tableView registerClass:[SFSettingCell class] forCellReuseIdentifier:NSStringFromClass([SFSettingCell class])];
    //    [_settingsTableVC.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_settingsTableVC.tableView setAllowsSelection:NO];
    _settingsTableVC.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [_settingsTableVC.tableView setScrollEnabled:NO];
    _settingsTableVC.tableView.delegate = self;
    
    [self addChildViewController:_settingsTableVC];
}

@end
