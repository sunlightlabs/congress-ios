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

@implementation SFMenuViewController {
    NSArray *_controllers;
    NSArray *_menuLabels;
    NSUInteger _selectedIndex;
    UIViewController *_settingsViewController;
    UIViewController *_informationViewController;
    UIView *_headerView;
}

@synthesize tableView = _tableView;
@synthesize settingsButton = _settingsButton;
@synthesize infoButton = _infoButton;
@synthesize headerImageView = _headerImageView;

static NSString *cellIdentifier = @"SFNavTableCell";

- (id)initWithControllers:(NSArray *)controllers menuLabels:(NSArray *)menuLabels
                 settings:(UIViewController *)settingsViewController info:(UIViewController *)informationViewController {
    self = [super init];
    if (self) {
        self.restorationIdentifier = NSStringFromClass(self.class);
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor menuBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;

        _headerView = [[UIView alloc] initWithFrame:CGRectZero];
        _headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NavHeader"]];

        _settingsButton = [SFImageButton buttonWithDefaultImage:[UIImage settingsButtonImage]];
//        [_settingsButton setImage:[UIImage settingsButtonSelectedImage] forState:UIControlStateHighlighted];
        [_settingsButton setTintColor:[UIColor colorWithRed:0.627 green:0.149 blue:0.035 alpha:1.0]];
        [_settingsButton setAccessibilityLabel:@"Settings"];

        _infoButton = [SFImageButton buttonWithDefaultImage:[UIImage infoButtonImage]];
//        [_infoButton setImage:[UIImage infoButtonHighlightedImage] forState:UIControlStateHighlighted];
        [_infoButton setTintColor:[UIColor colorWithRed:0.627 green:0.149 blue:0.035 alpha:1.0]];
        [_infoButton setAccessibilityLabel:@"Information"];

        _controllers = controllers;
        _menuLabels = menuLabels;
        _settingsViewController = settingsViewController;
        _informationViewController = informationViewController;

        _selectedIndex = -1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.opaque = YES;
    self.view.backgroundColor = [UIColor menuBackgroundColor];

    _headerView.translatesAutoresizingMaskIntoConstraints = NO;
    _headerView.backgroundColor = [UIColor navigationBarTextColor];
    [self.view addSubview:_headerView];
    _headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_headerView addSubview:_headerImageView];

    [_tableView registerClass:[SFNavTableCell class] forCellReuseIdentifier:cellIdentifier];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_tableView];

    _settingsButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_settingsButton sizeToFit];
    [self.view addSubview:_settingsButton];

    _infoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_infoButton sizeToFit];
    [self.view addSubview:_infoButton];

    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_tableView, _settingsButton, _headerView, _infoButton);

    [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_headerImageView]|" options:NSLayoutFormatAlignAllBottom metrics:nil views:NSDictionaryOfVariableBindings(_headerImageView)]];
    CGFloat headerHeight = _headerImageView.height;
    if ([[UIDevice currentDevice] systemMajorVersion] > 6) {
        CGFloat headerPadding = [[UIApplication sharedApplication] statusBarFrame].size.height;
        headerHeight += headerPadding;
    }
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[_headerView]|"
                                                   options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[_tableView]|"
                                                   options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[_headerView(headerHeight)]-[_tableView]-[_settingsButton]-4-|"
                                                   options:0 metrics:@{ @"headerHeight":@(headerHeight) } views:viewsDictionary]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_infoButton attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_settingsButton attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0f constant:0]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-4-[_settingsButton]-12-[_infoButton]"
                                                   options:0 metrics:nil views:viewsDictionary]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self selectMenuItemForIndex:_selectedIndex animated:NO];
}

- (void)selectMenuItemForController:(UIViewController *)controller animated:(BOOL)animated {
    _selectedIndex = [_controllers indexOfObject:controller];
    [self selectMenuItemForIndex:_selectedIndex animated:animated];
}

- (void)selectMenuItemForIndex:(NSUInteger)index animated:(BOOL)animated {
    for (NSUInteger i = 0; i < _menuLabels.count; i++) {
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:i inSection:0];
        SFNavTableCell *cell = (SFNavTableCell *)[self.tableView cellForRowAtIndexPath:idxPath];
        if (i == index) {
            [cell setSelected:YES animated:animated];
//            [cell toggleFontFaceForSelected:YES];
        }
        else {
            [cell setSelected:NO animated:animated];
//            [cell toggleFontFaceForSelected:NO];
        }
    }
}

#pragma mark - UITableViewDataSource delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_menuLabels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFNavTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    NSString *label = [_menuLabels objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:label];
    if ([label isEqualToString:@"Following"]) {
        [cell.imageView setImage:[UIImage followingNavImage]];
    }
    else {
        [cell.imageView setImage:nil];
    }

    return cell;
}

@end
