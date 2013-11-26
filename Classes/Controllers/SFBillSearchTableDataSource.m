//
//  SFBillSearchTableDataSource.m
//  Congress
//
//  Created by Daniel Cloud on 11/25/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillSearchTableDataSource.h"
#import "SFBill.h"

@implementation SFBillSearchTableDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil || ([self.items count] == 0)) return nil;

    id bill  = [self itemForIndexPath:indexPath];
    if (!bill) return nil;
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFBillSearchCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:bill];

    SFTableCell *cell;
    if (self.cellForIndexPathHandler) {
        cell = self.cellForIndexPathHandler(indexPath);
    }
    else
    {
        cell = (SFTableCell *)[tableView dequeueReusableCellWithIdentifier:[SFTableCell defaultCellIdentifer] forIndexPath:indexPath];
    }
    [cell setCellData:cellData];
    if (cellData.persist && [cell respondsToSelector:@selector(setPersistStyle)]) {
        [cell performSelector:@selector(setPersistStyle)];
    }
    CGFloat cellHeight = [cellData heightForWidth:tableView.width];
    [cell setFrame:CGRectMake(0, 0, cell.width, cellHeight)];

    return cell;
}


@end
