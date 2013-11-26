//
//  SFCommitteesTableDataSource.m
//  Congress
//
//  Created by Daniel Cloud on 11/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteesTableDataSource.h"
#import "SFCommittee.h"

@implementation SFCommitteesTableDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) return nil;

    SFCommittee *committee  = (SFCommittee *)[self itemForIndexPath:indexPath];

    if (!committee) return nil;

    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultCommitteeCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:committee];

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
