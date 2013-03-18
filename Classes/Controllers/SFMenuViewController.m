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
#import "SFActivityListViewController.h"
#import "SFLegislatorsSegmentedViewController.h"
#import "SFNavTableCell.h"

@implementation SFMenuViewController{
    NSArray *_controllers;
    NSArray *_menuLabels;
    SFNavTableCell *_selectedCell;
}


-(id)initWithControllers:(NSArray *)controllers menuLabels:(NSArray *)menuLabels
{
    if(self = [super initWithNibName:nil bundle:nil])
    {
        self = [super initWithStyle:UITableViewStylePlain];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _controllers = controllers;
        _menuLabels = menuLabels;
        _selectedCell = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor menuBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    SFNavTableCell *topCell = (SFNavTableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (!_selectedCell) {
        _selectedCell = topCell;
    }

    [_selectedCell toggleFontFaceForSelected:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [[cell textLabel] setText:[_menuLabels objectAtIndex:row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFNavTableCell *menuCell = (SFNavTableCell *)cell;
    [menuCell toggleFontFaceForSelected:menuCell.selected];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFNavTableCell *cell = (SFNavTableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    _selectedCell = cell;
    [_selectedCell toggleFontFaceForSelected:YES];
    for (NSUInteger i=0; i < _menuLabels.count; i++) {
        SFNavTableCell *cell = (SFNavTableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (![cell isEqual:_selectedCell]) {
            [cell setSelected:NO];
        }
    }

    [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        self.viewDeckController.centerController = [_controllers objectAtIndex:indexPath.row];
    }];
}

@end
