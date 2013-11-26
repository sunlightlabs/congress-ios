//
//  SFCommitteeHearingsTableDataSource.m
//  Congress
//
//  Created by Daniel Cloud on 11/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteeHearingsTableDataSource.h"
#import "SFHearing.h"

@implementation SFCommitteeHearingsTableDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) return nil;

    SFHearing *hearing  = (SFHearing *)[self itemForIndexPath:indexPath];

    if (!hearing) return nil;

    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFCommitteeHearingCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:hearing];

    SFTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[SFTableCell defaultCellIdentifer]];

    [cell setCellData:cellData];

    if (cellData.persist && [cell respondsToSelector:@selector(setPersistStyle)]) {
        [cell performSelector:@selector(setPersistStyle)];
    }

    CGFloat cellHeight = [cellData heightForWidth:tableView.width];
    [cell setFrame:CGRectMake(0, 0, cell.width, fminf(cellHeight, 1000000.0))];

    return cell;
}

@end
