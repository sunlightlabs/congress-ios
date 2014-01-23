//
//  SFLegislatorVotingRecordDataSource.m
//  Congress
//
//  Created by Daniel Cloud on 11/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorVotingRecordDataSource.h"
#import "SFRollCallVote.h"
#import "SFLegislator.h"

@implementation SFLegislatorVotingRecordDataSource

@synthesize legislator = _legislator;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == nil) return nil;

    SFRollCallVote *vote  = (SFRollCallVote *)[self itemForIndexPath:indexPath];
    if (!vote) return nil;
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFRollCallVoteByLegislatorCellTransformerName];
    NSDictionary *value = @{ @"vote":vote, @"legislator":self.legislator };
    SFCellData *cellData = [valueTransformer transformedValue:value];

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
