//
//  SFEditFavoritesViewController.m
//  Congress
//
//  Created by Daniel Cloud on 3/12/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFEditFavoritesViewController.h"
#import "SFSegmentedViewController.h"
#import "SFLegislatorListViewController.h"
#import "SFBillsTableViewController.h"
#import "SFBill.h"
#import "SFLegislator.h"
#import "SFEditFavoriteCell.h"
#import "SFCongressButton.h"
#import "SFFavoriteButton.h"
#import "SFDataArchiver.h"

@interface SFEditFavoritesViewController ()  <UIGestureRecognizerDelegate>

@end

@implementation SFEditFavoritesViewController
{
    SFSegmentedViewController *_segmentedVC;
    SFBillsTableViewController *_followedBillsVC;
    SFLegislatorListViewController *_followedLegislatorsVC;
}

@synthesize saveButton = _saveButton;

- (id)init
{
    self = [super init];
    self.trackedViewName = @"Favorites Edit Screen";
    if (self) {
        self.title = @"Settings";
        
        _segmentedVC = [[SFSegmentedViewController alloc] initWithNibName:nil bundle:nil];
        _segmentedVC.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addChildViewController:_segmentedVC];

        _saveButton = [[SFCongressButton alloc] init];
        [_saveButton setTitle:@"Save" forState:UIControlStateNormal];
        _saveButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_saveButton addTarget:self action:@selector(saveButtonPress:) forControlEvents:UIControlEventTouchUpInside];

        _followedBillsVC = [[SFBillsTableViewController alloc] initWithStyle:UITableViewStylePlain];
        __weak SFBillsTableViewController *weak_followedBillsVC = _followedBillsVC;
        _followedBillsVC.cellForIndexPathHandler = ^(NSIndexPath *indexPath) {
            __strong SFBillsTableViewController *strongTableVC = weak_followedBillsVC;
            static NSString *CellIdentifier = @"SFEditFavoriteCell";
            SFEditFavoriteCell *cell = [strongTableVC.tableView dequeueReusableCellWithIdentifier:CellIdentifier];

            if(!cell) {
                cell = [[SFEditFavoriteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            else
            {
                [cell prepareForReuse];
            }
            SFBill *bill = (SFBill *)[[strongTableVC.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.syncObject = bill;
            cell.textLabel.numberOfLines = 3;
            cell.textLabel.text = bill.shortTitle ? bill.shortTitle : bill.officialTitle;
            return cell;
        };
        
        _followedLegislatorsVC = [[SFLegislatorListViewController alloc] initWithStyle:UITableViewStylePlain];
        __weak SFLegislatorListViewController *weak_followedLegislatorsVC = _followedLegislatorsVC;
        _followedLegislatorsVC.cellForIndexPathHandler = ^(NSIndexPath *indexPath) {
            __strong SFLegislatorListViewController *strongTableVC = weak_followedLegislatorsVC;
            static NSString *CellIdentifier = @"SFEditFavoriteCell";
            SFEditFavoriteCell *cell = [strongTableVC.tableView dequeueReusableCellWithIdentifier:CellIdentifier];

            if(!cell) {
                cell = [[SFEditFavoriteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            else
            {
                [cell prepareForReuse];
            }
            SFLegislator *legislator = (SFLegislator *)[[strongTableVC.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.syncObject = legislator;
            cell.textLabel.text = legislator.fullName;
            return cell;
        };

        [_segmentedVC setViewControllers:@[_followedBillsVC, _followedLegislatorsVC] titles:@[@"Bills", @"Legislators"]];


        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDidSave:) name:SFDataArchiveCompleteNotification object:nil];
    }
    return self;
}


-(void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor primaryBackgroundColor];
	self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _segmentedVC.view.frame = self.view.frame;
    [self.view addSubview:_segmentedVC.view];
    [_segmentedVC didMoveToParentViewController:self];
    [_segmentedVC displayViewForSegment:0];

    [self.view addSubview:_saveButton];

    NSDictionary *viewsDictionary = @{@"segmentedView": _segmentedVC.view, @"saveButton":_saveButton};
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[segmentedView]-[saveButton]-5-|"
                               options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[segmentedView]|"
                               options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-[saveButton]-|"
                               options:0 metrics:nil views:viewsDictionary]];
}

- (void)viewWillAppear:(BOOL)animated
{
    _followedBillsVC.items = [SFBill allObjectsToPersist];
    [_followedBillsVC reloadTableView];

    _followedLegislatorsVC.items = [SFLegislator allObjectsToPersist];
    [_followedLegislatorsVC reloadTableView];

    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveButtonPress:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:SFDataArchiveRequestNotification object:nil]];
}

- (void)handleDidSave:(id)sender
{
    _followedBillsVC.items = [SFBill allObjectsToPersist];
    [_followedBillsVC reloadTableView];

    _followedLegislatorsVC.items = [SFLegislator allObjectsToPersist];
    [_followedLegislatorsVC reloadTableView];
}

@end
