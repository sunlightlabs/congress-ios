//
//  SFLegislatorBillsTableViewController.m
//  Congress
//
//  Created by Daniel Cloud on 6/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorBillsTableViewController.h"
#import "SFBill.h"
#import "SFTableCell.h"
#import "SFCellData.h"
#import "SFCellDataTransformers.h"

@interface SFLegislatorBillsTableViewController ()

@end

@implementation SFLegislatorBillsTableViewController

@synthesize legislator = _legislator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Table view data source

// SFDataTableViewController doesn't handle this method currently
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil || ([self.items count] == 0)) return nil;

    SFBill *bill  = (SFBill *)[self itemForIndexPath:indexPath];
    if (!bill) return nil;
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFBillSponsorCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:@{@"bill": bill, @"legislator":self.legislator}];

    SFTableCell *cell;
    if (self.cellForIndexPathHandler) {
        cell = self.cellForIndexPathHandler(indexPath);
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cell.cellIdentifier];

        // Configure the cell...
        if(!cell) {
            cell = [[SFTableCell alloc] initWithStyle:cellData.cellStyle reuseIdentifier:cell.cellIdentifier];
        }
    }
    [cell setCellData:cellData];
    if (cellData.persist && [cell respondsToSelector:@selector(setPersistStyle)]) {
        [cell performSelector:@selector(setPersistStyle)];
    }
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    [cell setFrame:CGRectMake(0, 0, cell.width, cellHeight)];

    return cell;
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil || ([self.items count] == 0)) return 0;
    SFBill *bill  = (SFBill *)[self itemForIndexPath:indexPath];
    if (!bill) return 0;
    if (!bill.sponsor && self.legislator) bill.sponsor = self.legislator;
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFBillSponsorCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:@{@"bill": bill, @"legislator":self.legislator}];
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return cellHeight;
}

@end
