//
//  SFEditFavoritesViewController.m
//  Congress
//
//  Created by Daniel Cloud on 3/12/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFEditFavoritesViewController.h"
#import "SFSegmentedViewController.h"
#import "SFEditFavoritesTableViewController.h"
#import "SFBill.h"
#import "SFBillCell.h"
#import "SFLegislator.h"
#import "SFLegislatorCell.h"

@interface SFEditFavoritesViewController ()

@end

@implementation SFEditFavoritesViewController
{
    SFSegmentedViewController *_segmentedVC;
    SFEditFavoritesTableViewController *_followedBillsVC;
    SFEditFavoritesTableViewController *_followedLegislatorsVC;

}

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Settings";
        
        _segmentedVC = [[SFSegmentedViewController alloc] initWithNibName:nil bundle:nil];
        [self addChildViewController:_segmentedVC];
        
        _followedBillsVC = [[SFEditFavoritesTableViewController alloc] initWithStyle:UITableViewStylePlain];
        __weak SFEditFavoritesTableViewController *weak_followedBillsVC = _followedBillsVC;
        _followedBillsVC.cellForIndexPathHandler = ^(NSIndexPath *indexPath) {
            __strong SFEditFavoritesTableViewController *strongTableVC = weak_followedBillsVC;
            static NSString *CellIdentifier = @"SFBillCell";
            SFBillCell *cell = [strongTableVC.tableView dequeueReusableCellWithIdentifier:CellIdentifier];

            if(!cell) {
                cell = [[SFBillCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            else
            {
                [cell prepareForReuse];
            }

            cell.bill = (SFBill *)[[strongTableVC.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.panels = nil;
            return cell;
        };
        
        _followedLegislatorsVC = [[SFEditFavoritesTableViewController alloc] initWithStyle:UITableViewStylePlain];
        __weak SFEditFavoritesTableViewController *weak_followedLegislatorsVC = _followedLegislatorsVC;
        _followedLegislatorsVC.cellForIndexPathHandler = ^(NSIndexPath *indexPath) {
            __strong SFEditFavoritesTableViewController *strongTableVC = weak_followedLegislatorsVC;
            static NSString *CellIdentifier = @"SFLegislatorCell";
            SFLegislatorCell *cell = [strongTableVC.tableView dequeueReusableCellWithIdentifier:CellIdentifier];

            if(!cell) {
                cell = [[SFLegislatorCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            else
            {
                [cell prepareForReuse];
            }

            cell.legislator = (SFLegislator *)[[strongTableVC.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.panels = nil;
            return cell;
        };

        [_segmentedVC setViewControllers:@[_followedBillsVC, _followedLegislatorsVC] titles:@[@"Bills", @"Legislators"]];

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

    _followedBillsVC.items = [SFBill allObjectsToPersist];
    _followedBillsVC.sections = @[_followedBillsVC.items];
    [_followedBillsVC reloadTableView];

    _followedLegislatorsVC.items = [SFLegislator allObjectsToPersist];
    _followedLegislatorsVC.sections = @[_followedLegislatorsVC.items];
    [_followedLegislatorsVC reloadTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
