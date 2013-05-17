//
//  SFBillsTableViewController.m
//  Congress
//
//  Created by Daniel Cloud on 2/15/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillsTableViewController.h"
#import "SFBill.h"
#import "SFBillSegmentedViewController.h"
#import "SFPanopticCell.h"
#import "SFCellData.h"
#import "SFCellDataTransformers.h"
#import "SFDateFormatterUtil.h"
#import "GAI.h"

SFDataTableSectionTitleGenerator const lastActionAtTitleBlock = ^NSArray*(NSArray *items) {
    NSArray *possibleSectionTitleValues = [items valueForKeyPath:@"lastActionAt"];
    possibleSectionTitleValues = [possibleSectionTitleValues sortedArrayUsingDescriptors:
                                  @[[NSSortDescriptor sortDescriptorWithKey:@"timeIntervalSince1970" ascending:NO]]];
    NSMutableArray *sectionTitleStrings = [NSMutableArray array];
    NSDateFormatter *dateFormatter = [SFDateFormatterUtil mediumDateNoTimeFormatter];
    for (NSDate *date in possibleSectionTitleValues) {
        [sectionTitleStrings addObject:[dateFormatter stringFromDate:date]];
    }
    NSOrderedSet *sectionTitlesSet = [NSOrderedSet orderedSetWithArray:sectionTitleStrings];
    return [sectionTitlesSet array];
};
SFDataTableSortIntoSectionsBlock const lastActionAtSorterBlock = ^NSUInteger(id item, NSArray *sectionTitles) {
    NSDateFormatter *dateFormatter = [SFDateFormatterUtil mediumDateNoTimeFormatter];
    NSString *lastActionAtString = [dateFormatter stringFromDate:((SFBill *)item).lastActionAt];
    NSUInteger index = [sectionTitles indexOfObject:lastActionAtString];
    if (index != NSNotFound) {
        return index;
    }
    return 0;
};

@interface SFBillsTableViewController () <UIDataSourceModelAssociation>

@end

@implementation SFBillsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.tableView registerClass:[SFPanopticCell class] forCellReuseIdentifier:@"SFPanopticCell"];

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Bill List Screen"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// SFDataTableViewController doesn't handle this method currently
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) return nil;

    SFBill *bill  = (SFBill *)[self itemForIndexPath:indexPath];
    if (!bill) return nil;
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultBillCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:bill];

    SFPanopticCell *cell;
    if (self.cellForIndexPathHandler) {
        cell = self.cellForIndexPathHandler(indexPath);
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cell.cellIdentifier];

        // Configure the cell...
        if(!cell) {
            cell = [[SFPanopticCell alloc] initWithStyle:cellData.cellStyle reuseIdentifier:cell.cellIdentifier];
        }
    }
    [cell setCellData:cellData];
    if (cellData.persist && [cell respondsToSelector:@selector(setPersistStyle)]) {
        [cell performSelector:@selector(setPersistStyle)];
    }
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    [cell setFrame:CGRectMake(0, 0, cell.width, cellHeight)];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFBillSegmentedViewController *detailViewController = [[SFBillSegmentedViewController alloc] initWithNibName:nil bundle:nil];
    SFBill *bill  = (SFBill *)[self itemForIndexPath:indexPath];

    detailViewController.bill = bill;

    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFBill *bill  = (SFBill *)[self itemForIndexPath:indexPath];
    if (!bill) return 0;
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultBillCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:bill];
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return cellHeight;
}

#pragma mark - UIDataSourceModelAssociation protocol

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view
{
    SFBill *bill;
    if ([self.sections count] == 0) {
        bill = (SFBill *)[self.items objectAtIndex:idx.row];
    }
    else
    {
        bill = (SFBill *)[[self.sections objectAtIndex:idx.section] objectAtIndex:idx.row];
    }
    return bill.remoteID;
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view
{
    __block NSIndexPath* path = nil;
//    SFBill *bill = [SFBill existingObjectWithRemoteID:identifier];
    return path;
}

@end
