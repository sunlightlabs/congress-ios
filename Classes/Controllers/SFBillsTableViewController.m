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

@interface SFBillsTableViewController ()

@end

@implementation SFBillsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.dataArray = @[];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    // Configure the cell...
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSUInteger row = [indexPath row];
    SFBill *bill = (SFBill *)[self.dataArray objectAtIndex:row];
    BOOL shortTitleIsNull = [bill.shortTitle isEqual:[NSNull null]] || bill.shortTitle == nil;
    [[cell textLabel] setText:(!shortTitleIsNull ? bill.shortTitle : bill.officialTitle)];
    NSDateFormatter *dateFormatter = nil;
    NSString *dateDescription = @"";
    if (bill.lastActionAt) {
        if (bill.lastActionAtIsDateTime) {
            dateFormatter = [NSDateFormatter mediumDateShortTimeFormatter];
        }
        else
        {
            dateFormatter = [NSDateFormatter ISO8601DateOnlyFormatter];
            dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        }
        dateDescription = [NSString stringWithFormat:@"Last Action At: %@", [dateFormatter stringFromDate:bill.lastActionAt] ];
    }
    else if (bill.introducedOn)
    {
        dateFormatter = [NSDateFormatter ISO8601DateOnlyFormatter];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateDescription = [NSString stringWithFormat:@"Introduced on: %@", [dateFormatter stringFromDate:bill.introducedOn] ];
    }
    [[cell detailTextLabel] setText:dateDescription];

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFBillSegmentedViewController *detailViewController = [[SFBillSegmentedViewController alloc] initWithNibName:nil bundle:nil];
    detailViewController.bill = [self.dataArray objectAtIndex:[indexPath row]];

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
