//
//  SFCommitteeMembersTableDataSource.m
//  Congress
//
//  Created by Daniel Cloud on 11/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteeMembersTableDataSource.h"
#import "SFCommittee.h"

@implementation SFCommitteeMembersTableDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) return nil;

    SFCommitteeMember *member = (SFCommitteeMember *)[self itemForIndexPath:indexPath];
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:SFCommitteeMemberCellTransformerName];
    SFCellData *cellData = [transformer transformedValue:member];

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
