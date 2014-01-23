//
//  SFLegislatorBillsTableViewController.m
//  Congress
//
//  Created by Daniel Cloud on 6/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorBillsTableViewController.h"
#import "SFBill.h"
#import "SFLegislatorBillsTableDataSource.h"

@interface SFLegislatorBillsTableViewController ()

@end

@implementation SFLegislatorBillsTableViewController

@synthesize legislator = _legislator;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataProvider = [SFLegislatorBillsTableDataSource new];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == nil || ([self.dataProvider.items count] == 0)) return 0;
    SFBill *bill  = (SFBill *)[self.dataProvider itemForIndexPath:indexPath];
    if (!bill) return 0;
    if (!bill.sponsor && self.legislator) bill.sponsor = self.legislator;
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFBillSponsorCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:@{ @"bill": bill }];
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return cellHeight;
}

@end
