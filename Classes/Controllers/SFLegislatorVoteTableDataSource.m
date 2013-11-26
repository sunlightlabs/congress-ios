//
//  SFLegislatorVoteTableDataSource.m
//  Congress
//
//  Created by Daniel Cloud on 11/25/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorVoteTableDataSource.h"
#import "SFLegislator.h"

@implementation SFLegislatorVoteTableDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) return nil;

    SFLegislator *legislator = (SFLegislator *)[self itemForIndexPath:indexPath];
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:SFLegislatorVoteCellTransformerName];
    SFCellData *cellData = [transformer transformedValue:@{@"legislator": legislator}];

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
