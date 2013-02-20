//
//  SFBillsTableViewController.m
//  Congress
//
//  Created by Daniel Cloud on 2/15/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillsTableViewController.h"
#import "SFBill.h"
#import "SFBillSegmentedViewController.h"
#import "SFBillCell.h"

@interface SFBillsTableViewController ()

@end

@implementation SFBillsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.items = @[];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:SFBillCell.class forCellReuseIdentifier:@"SFBillCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SFBillCell";
    SFBillCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    // Configure the cell...
    if(!cell) {
        cell = [[SFBillCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    NSUInteger row = [indexPath row];
    SFBill *bill = (SFBill *)[self.items objectAtIndex:row];
    cell.bill = bill;

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFBillSegmentedViewController *detailViewController = [[SFBillSegmentedViewController alloc] initWithNibName:nil bundle:nil];
    detailViewController.bill = [self.items objectAtIndex:[indexPath row]];

    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - Table view helpers

-(void)reloadTableView
{
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}
@end
