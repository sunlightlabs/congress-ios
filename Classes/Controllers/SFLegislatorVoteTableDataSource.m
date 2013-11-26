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

@synthesize vote;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) return nil;

    SFTableCell *cell = (SFTableCell *)[tableView dequeueReusableCellWithIdentifier:[SFTableCell defaultCellIdentifer] forIndexPath:indexPath];

    SFLegislator *legislator = (SFLegislator *)[self itemForIndexPath:indexPath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:legislator forKey:@"legislator"];
    if (self.vote) {
        [dict setObject:self.vote forKey:@"rollCall"];
    }

    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:SFLegislatorVoteCellTransformerName];
    SFCellData *cellData = [transformer transformedValue:dict];
    [cell setCellData:cellData];

    if (cell.cellData.persist && [cell respondsToSelector:@selector(setPersistStyle)]) {
        [cell performSelector:@selector(setPersistStyle)];
    }
    CGFloat cellHeight = [cell.cellData heightForWidth:tableView.width];
    [cell setFrame:CGRectMake(0, 0, cell.width, cellHeight)];
    
    return cell;
}

@end
