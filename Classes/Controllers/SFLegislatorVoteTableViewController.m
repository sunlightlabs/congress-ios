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
#import "SFTableCell.h"
#import "SFCellData.h"

@interface SFLegislatorVoteTableViewController ()

@end

@implementation SFLegislatorVoteTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.restorationIdentifier = NSStringFromClass(self.class);
    self.tableView.delegate = self;

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Legislator Vote List Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) return nil;

    SFLegislator *legislator = (SFLegislator *)[self.dataProvider itemForIndexPath:indexPath];
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:SFLegislatorVoteCellTransformerName];
    SFCellData *cellData = [transformer transformedValue:@{@"legislator": legislator}];

    SFTableCell *cell;
    if (self.dataProvider.cellForIndexPathHandler) {
        cell =  self.dataProvider.cellForIndexPathHandler(indexPath);
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cell.cellIdentifier];

        // Configure the cell...
        if(!cell) {
            cell = [[SFTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell.cellIdentifier];
        }
        [cell setCellData:cellData];
    }

    if (cellData.persist && [cell respondsToSelector:@selector(setPersistStyle)]) {
        [cell performSelector:@selector(setPersistStyle)];
    }
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    [cell setFrame:CGRectMake(0, 0, cell.width, cellHeight)];

    return cell;
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFLegislator *legislator = (SFLegislator *)[self.dataProvider itemForIndexPath:indexPath];
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:SFLegislatorVoteCellTransformerName];
    SFCellData *cellData = [transformer transformedValue:@{@"legislator": legislator}];
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return cellHeight;
}

@end
