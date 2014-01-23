//
//  SFSearchBillsTableViewController.m
//  Congress
//
//  Created by Daniel Cloud on 4/15/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFSearchBillsTableViewController.h"
#import "SFBill.h"
#import "SFBillSegmentedViewController.h"
#import "SFTableCell.h"
#import "SFCellData.h"
#import "SFCellDataTransformers.h"
#import "SFBillSearchTableDataSource.h"

@interface SFSearchBillsTableViewController ()

@end

@implementation SFSearchBillsTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.dataProvider = [SFBillSearchTableDataSource new];

    id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Bill Search Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == nil || ([self.dataProvider.items count] == 0)) return 0;
    SFBill *bill  = (SFBill *)[self.dataProvider itemForIndexPath:indexPath];
    if (!bill) return 0;
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFBillSearchCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:bill];
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return cellHeight;
}

@end
