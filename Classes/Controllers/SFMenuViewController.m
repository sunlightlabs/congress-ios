//
//  SFNavViewController.m
//  Congress
//
//  Created by Daniel Cloud on 11/29/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//
// TODO: replace navList identifiers with real ones.

#import "SFMenuViewController.h"
#import "SFViewDeckController.h"
#import "SFCongressNavigationController.h"
#import "SFNavTableCell.h"
#import "SFImageButton.h"

@implementation SFMenuViewController{
    NSArray *_controllers;
    NSArray *_menuLabels;
    UIViewController *_settingsViewController;
}

@synthesize tableView = _tableView;
@synthesize settingsButton = _settingsButton;
@synthesize headerImageView = _headerImageView;

-(id)initWithControllers:(NSArray *)controllers menuLabels:(NSArray *)menuLabels settings:(UIViewController *)settingsViewController
{
    self = [super init];
    if (self)
    {
        self.restorationIdentifier = NSStringFromClass(self.class);
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor menuBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;

        _headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavHeader"]];

        _settingsButton =[SFImageButton button];
        [_settingsButton setImage:[UIImage settingsButtonImage] forState:UIControlStateNormal];
        [_settingsButton setImage:[UIImage settingsButtonSelectedImage] forState:UIControlStateHighlighted];
        [_settingsButton addTarget:self action:@selector(handleSettingsPress) forControlEvents:UIControlEventTouchUpInside];
        [_settingsButton setAccessibilityLabel:@"Settings"];

        _controllers = controllers;
        _menuLabels = menuLabels;
        _settingsViewController = settingsViewController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.opaque = YES;
    self.view.backgroundColor = [UIColor menuBackgroundColor];

    _headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_headerImageView];

    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_tableView];

    _settingsButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_settingsButton sizeToFit];
    [self.view addSubview:_settingsButton];

    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_tableView, _settingsButton, _headerImageView);

    CGSize headerImageSize = [_headerImageView size];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[_headerImageView]"
                               options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[_tableView]|"
                               options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[_headerImageView(headerHeight)]-[_tableView]-[_settingsButton]-8-|"
                               options:0 metrics:@{@"headerHeight": @(headerImageSize.height)} views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-8-[_settingsButton]"
                               options:0 metrics:nil views:viewsDictionary]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)deselectLabels
{
    for (NSUInteger i=0; i < _menuLabels.count; i++) {
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:i inSection:0];
        [[self.tableView cellForRowAtIndexPath:idxPath] setSelected:NO];
    }
}

- (void)handleSettingsPress
{
    [(SFViewDeckController *)self.parentViewController navigateToSettings];
}

- (void)selectMenuItemForController:(UIViewController*)controller animated:(BOOL)animated
{
    int index = [_controllers indexOfObject:controller];
    if (index != NSNotFound) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        SFNavTableCell *cell = (SFNavTableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:YES animated:animated];
        [cell toggleFontFaceForSelected:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_menuLabels count];
}

@end
