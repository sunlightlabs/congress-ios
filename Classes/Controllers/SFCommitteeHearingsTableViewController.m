//
//  SFCommitteeHearingsTableViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 10/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteeHearingsTableViewController.h"
#import "SFHearing.h"
#import "SFCommitteeHearingsTableDataSource.h"

@implementation SFCommitteeHearingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataProvider = [SFCommitteeHearingsTableDataSource new];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFHearing *hearing = (SFHearing *)[self.dataProvider itemForIndexPath:indexPath];

    if (!hearing) return 0;

    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFCommitteeHearingCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:hearing];

    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return cellHeight;
}

@end
