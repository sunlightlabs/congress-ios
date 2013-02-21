//
//  SFMixedCellTableViewController.m
//  Congress
//
//  Created by Daniel Cloud on 2/20/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFMixedTableViewController.h"
#import "SFBill.h"
#import "SFBillCell.h"
#import "SFBillSegmentedViewController.h"
#import "SFLegislator.h"
#import "SFLegislatorCell.h"
#import "SFLegislatorDetailViewController.h"

@interface SFMixedTableViewController ()

@end

@implementation SFMixedTableViewController

@synthesize items;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.items = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self.tableView registerClass:SFBillCell.class forCellReuseIdentifier:@"SFBillCell"];
    [self.tableView registerClass:SFLegislatorCell.class forCellReuseIdentifier:@"SFLegislatorCell"];

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
    NSUInteger row = [indexPath row];
    id object = [self.items objectAtIndex:row];
    NSString *cellIdentifier = @"UITableViewCell";
    Class cellClass = nil;
    if ([object isKindOfClass:SFBill.class]) {
        cellIdentifier = @"SFBillCell";
        cellClass = SFBillCell.class;
    }
    else if ([object isKindOfClass:SFLegislator.class])
    {
        cellIdentifier = @"SFLegislatorCell";
        cellClass = SFLegislatorCell.class;
   }
    id cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // Configure the cell...
    if(!cell) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    if ([cell isKindOfClass:NSClassFromString(@"SFBillCell")]) {
        ((SFBillCell *)cell).bill = (SFBill *)object;
    }
    else if ([cell isKindOfClass:NSClassFromString(@"SFLegislatorCell")]) {
        ((SFLegislatorCell *)cell).legislator = (SFLegislator *)object;
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.items objectAtIndex:[indexPath row]];
    id detailViewController = nil;
    if ([object isKindOfClass:SFBill.class]) {
        SFBillSegmentedViewController *vc = [[SFBillSegmentedViewController alloc] initWithNibName:nil bundle:nil];
        vc.bill = (SFBill *)object;
        detailViewController = vc;
    }
    else if ([object isKindOfClass:SFLegislator.class])
    {
        SFLegislatorDetailViewController *vc = [[SFLegislatorDetailViewController alloc] initWithNibName:nil bundle:nil];
        vc.legislator = (SFLegislator *)object;
        detailViewController = vc;
    }
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
