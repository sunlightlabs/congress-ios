//
//  SFHearingBillsTableViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 10/15/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFHearingBillsTableViewController.h"
#import "SFBill.h"
#import "SFCellData.h"
#import "SFTableCell.h"

@interface SFHearingBillsTableViewController ()

@end

@implementation SFHearingBillsTableViewController

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil || ([self.items count] == 0)) return nil;
    
    SFBill *bill  = (SFBill *)[self itemForIndexPath:indexPath];
    if (!bill) return nil;
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFBillNoExtraDataCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:bill];
    
    SFTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hearings.bills"];
    if(!cell) {
        cell = [[SFTableCell alloc] initWithStyle:cellData.cellStyle reuseIdentifier:@"hearings.bills"];
    }
    
    [cell setCellData:cellData];
    if (cellData.persist && [cell respondsToSelector:@selector(setPersistStyle)]) {
        [cell performSelector:@selector(setPersistStyle)];
    }
    
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    [cell setFrame:CGRectMake(0, 0, cell.width, cellHeight)];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil || ([self.items count] == 0)) return 0;
    SFBill *bill  = (SFBill *)[self itemForIndexPath:indexPath];
    if (!bill) return 0;
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFBillNoExtraDataCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:bill];
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return cellHeight;
}

@end
