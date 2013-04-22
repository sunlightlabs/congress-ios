//
//  SFNavViewController.m
//  Congress
//
//  Created by Daniel Cloud on 11/29/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//
// TODO: replace navList identifiers with real ones.

#import "SFMenuViewController.h"
#import "IIViewDeckController.h"
#import "SFCongressNavigationController.h"
#import "SFNavTableCell.h"
#import "SFImageButton.h"

@implementation SFMenuViewController{
    NSArray *_controllers;
    NSArray *_menuLabels;
    NSIndexPath *_selectedIndexPath;
    SFNavTableCell *_selectedCell;
    BOOL _settingsSelected;
    UIViewController *_settingsViewController;
}

@synthesize tableView = _tableView;
@synthesize settingsButton = _settingsButton;

-(id)initWithControllers:(NSArray *)controllers menuLabels:(NSArray *)menuLabels settings:(UIViewController *)settingsViewController
{
    self = [super init];
    if (self)
    {
        self.restorationIdentifier = NSStringFromClass(self.class);
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor menuBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;

        _settingsButton =[SFImageButton button];
        [_settingsButton setImage:[UIImage settingsButtonImage] forState:UIControlStateNormal];
        [_settingsButton setImage:[UIImage settingsButtonSelectedImage] forState:UIControlStateHighlighted];
        [_settingsButton addTarget:self action:@selector(handleSettingsPress) forControlEvents:UIControlEventTouchUpInside];

        _controllers = controllers;
        _menuLabels = menuLabels;
        _settingsViewController = settingsViewController;

        _selectedIndexPath = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.opaque = YES;
    self.view.backgroundColor = [UIColor menuBackgroundColor];

    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_tableView];

    _settingsButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_settingsButton sizeToFit];
    [self.view addSubview:_settingsButton];

    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_tableView, _settingsButton);

    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[_tableView]|"
                               options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[_tableView]-[_settingsButton]-8-|"
                               options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-8-[_settingsButton]"
                               options:0 metrics:nil views:viewsDictionary]];
    _settingsSelected = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_settingsSelected) {
        _selectedIndexPath = _selectedIndexPath ?: [NSIndexPath indexPathForRow:0 inSection:0];
        [self selectMenuItemAtIndexPath:_selectedIndexPath];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSettingsPress
{
    _settingsSelected = YES;
    [self selectViewController:_settingsViewController];
    [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {}];
    [_selectedCell toggleFontFaceForSelected:NO];
    for (NSUInteger i=0; i < _menuLabels.count; i++) {
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:i inSection:0];
        SFNavTableCell *cell = (SFNavTableCell *)[self.tableView cellForRowAtIndexPath:idxPath];
        [cell setSelected:NO];
    }
}

- (void)selectViewController:(UIViewController *)selectedViewController
{
    UINavigationController *navController = (UINavigationController *) self.viewDeckController.centerController;
    [navController.visibleViewController removeFromParentViewController];
    [navController setViewControllers:[NSArray arrayWithObject:selectedViewController] animated:NO];
}

- (void)selectMenuItemAtIndexPath:(NSIndexPath*)indexPath
{
    _settingsSelected = NO;
    _selectedIndexPath = indexPath;
    _selectedCell = (SFNavTableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"--- SELECTED CELL --->>> %@", _selectedCell);
    [_selectedCell setSelected:YES animated:YES];
    [_selectedCell toggleFontFaceForSelected:YES];
    for (NSUInteger i=0; i < _menuLabels.count; i++) {
        SFNavTableCell *cell = (SFNavTableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (![cell isEqual:_selectedCell]) {
            [cell setSelected:NO];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_menuLabels count];
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SFNavTableCell";
    SFNavTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if(!cell) {
        cell = [[SFNavTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    NSUInteger row = [indexPath row];
    NSString *label = [_menuLabels objectAtIndex:row];
    [[cell textLabel] setText:label];
    if ([label isEqualToString:@"Following"])
    {
        [cell.imageView setImage:[UIImage favoriteNavImage]];
    }
    else
    {
        [cell.imageView setImage:nil];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFNavTableCell *menuCell = (SFNavTableCell *)cell;
    [menuCell toggleFontFaceForSelected:menuCell.selected];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectMenuItemAtIndexPath:indexPath];
    [self selectViewController:[_controllers objectAtIndex:indexPath.row]];
    [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {}];
}

#pragma mark - Application state

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    [coder encodeBool:_settingsSelected forKey:@"settingsSelected"];
    [coder encodeObject:_selectedIndexPath forKey:@"selectedIndex"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    _selectedIndexPath = [coder decodeObjectForKey:@"selectedIndex"];
    _settingsSelected = [coder decodeBoolForKey:@"settingsSelected"] ?: NO;
    NSLog(@"SFMenuViewController decodeRestorableStateWithCoder");
}

@end
