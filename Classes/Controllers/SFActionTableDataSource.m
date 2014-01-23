//
//  SFActionDataSource.m
//  Congress
//
//  Created by Daniel Cloud on 11/25/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFActionTableDataSource.h"
#import "SFBillAction.h"
#import "SFRollCallVote.h"

@implementation SFActionTableDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == nil) return nil;

    id object = [self itemForIndexPath:indexPath];

    Class objectClass = [object class];
    NSValueTransformer *valueTransformer;
    if (objectClass == [SFBillAction class]) {
        valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultBillActionCellTransformerName];
    }
    else if (objectClass == [SFRollCallVote class]) {
        valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultRollCallVoteCellTransformerName];
    }

    SFCellData *cellData = [valueTransformer transformedValue:object];
    SFTableCell *cell = (SFTableCell *)[tableView dequeueReusableCellWithIdentifier:[SFTableCell defaultCellIdentifer] forIndexPath:indexPath];
    [cell setCellData:cellData];

    if (cellData.persist && [cell respondsToSelector:@selector(setPersistStyle)]) {
        [cell performSelector:@selector(setPersistStyle)];
    }
    CGFloat cellHeight = [cellData heightForWidth:tableView.width];
    [cell setFrame:CGRectMake(0, 0, cell.width, cellHeight)];

    return cell;
}

@end
