//
//  SFFollowingBillsTableViewController.m
//  Congress
//
//  Created by Daniel Cloud on 2/26/14.
//  Copyright (c) 2014 Sunlight Foundation. All rights reserved.
//

#import "SFFollowingBillsTableViewController.h"
#import "SFBill.h"

@interface SFFollowingBillsTableViewController ()

@end

@implementation SFFollowingBillsTableViewController

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFBill *bill  = (SFBill *)[self.dataProvider itemForIndexPath:indexPath];
    if (!bill) return 0;
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFBillNoExtraDataCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:bill];
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return cellHeight;
}



@end
