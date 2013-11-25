//
//  SFCommitteeHearingsTableViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 10/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteeHearingsTableViewController.h"
#import "SFHearing.h"
#import "SFCellData.h"
#import "SFTableCell.h"

@implementation SFCommitteeHearingsTableViewController

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) return nil;
    
    SFHearing *hearing  = (SFHearing *)[self.dataProvider itemForIndexPath:indexPath];
    
    if (!hearing) return nil;
    
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFCommitteeHearingCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:hearing];
    
    SFTableCell *cell;
    
    if (self.dataProvider.cellForIndexPathHandler)
    {
        cell = self.dataProvider.cellForIndexPathHandler(indexPath);
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cell.cellIdentifier];
        if (!cell) {
            cell = [[SFTableCell alloc] initWithStyle:cellData.cellStyle
                                         reuseIdentifier:cell.cellIdentifier];
        }
    }
    
    [cell setCellData:cellData];
    
    if (cellData.persist && [cell respondsToSelector:@selector(setPersistStyle)]) {
        [cell performSelector:@selector(setPersistStyle)];
    }
    
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    [cell setFrame:CGRectMake(0, 0, cell.width, fminf(cellHeight, 1000000.0))];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFHearing *hearing = (SFHearing *)[self.dataProvider itemForIndexPath:indexPath];
    
    if (!hearing) return 0;
    
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFCommitteeHearingCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:hearing];
    
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return cellHeight;
}

@end
