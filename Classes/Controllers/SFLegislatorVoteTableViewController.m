//
//  SFLegislatorVoteTableViewController.m
//  Congress
//
//  Created by Daniel Cloud on 4/11/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorVoteTableViewController.h"
#import "SFLegislator.h"
#import "SFLegislatorSegmentedViewController.h"
#import "SFLegislatorVoteTableDataSource.h"
#import "SFCellData.h"

@interface SFLegislatorVoteTableViewController ()

@end

@implementation SFLegislatorVoteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.restorationIdentifier = NSStringFromClass(self.class);
    self.tableView.delegate = self;
    self.dataProvider = [SFLegislatorVoteTableDataSource new];

    id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Legislator Vote List Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFLegislator *legislator = (SFLegislator *)[self.dataProvider itemForIndexPath:indexPath];
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:SFLegislatorVoteCellTransformerName];
    SFCellData *cellData = [transformer transformedValue:@{ @"legislator": legislator }];
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return cellHeight;
}

@end
