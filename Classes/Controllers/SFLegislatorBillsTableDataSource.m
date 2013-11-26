//
//  SFLegislatorBillsTableDataSource.m
//  Congress
//
//  Created by Daniel Cloud on 11/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorBillsTableDataSource.h"
#import "SFBill.h"
#import "SFLegislator.h"

@implementation SFLegislatorBillsTableDataSource

#pragma mark - Table view data source

// SFDataTableViewController doesn't handle this method currently
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil || ([self.items count] == 0)) return nil;

    SFBill *bill  = (SFBill *)[self itemForIndexPath:indexPath];
    if (!bill) return nil;
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFBillSponsorCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:@{@"bill": bill}];

    SFTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[SFTableCell defaultCellIdentifer]];
    [cell setCellData:cellData];
    if (cellData.persist && [cell respondsToSelector:@selector(setPersistStyle)]) {
        [cell performSelector:@selector(setPersistStyle)];
    }
    CGFloat cellHeight = [cellData heightForWidth:tableView.width];
    [cell setFrame:CGRectMake(0, 0, cell.width, cellHeight)];

    return cell;
}

@end
