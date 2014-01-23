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
#import "SFTableCell.h"
#import "SFCellData.h"
#import "SFCellDataTransformers.h"
#import "SFDateFormatterUtil.h"
#import "SFBillTableDataSource.h"

SFDataTableSectionTitleGenerator const lastActionAtTitleBlock = ^NSArray *(NSArray *items) {
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
SFDataTableSortIntoSectionsBlock const lastActionAtSorterBlock = ^NSUInteger (id item, NSArray *sectionTitles) {
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

- (void)viewDidLoad {
    self.dataProvider = [SFBillTableDataSource new];
    self.tableView.delegate = self;
    [super viewDidLoad];

    id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Bill List Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![tableView isEditing]) {
        SFBillSegmentedViewController *detailViewController = [[SFBillSegmentedViewController alloc] initWithNibName:nil bundle:nil];
        SFBill *bill  = (SFBill *)[self.dataProvider itemForIndexPath:indexPath];

        detailViewController.bill = bill;

        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFBill *bill  = (SFBill *)[self.dataProvider itemForIndexPath:indexPath];
    if (!bill) return 0;
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultBillCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:bill];
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return cellHeight;
}

#pragma mark - UIDataSourceModelAssociation protocol

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view {
    SFBill *bill;
    if ([self.dataProvider.sections count] == 0) {
        bill = (SFBill *)[self.dataProvider.items objectAtIndex:idx.row];
    }
    else {
        bill = (SFBill *)[[self.dataProvider.sections objectAtIndex:idx.section] objectAtIndex:idx.row];
    }
    return bill.remoteID;
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view {
    __block NSIndexPath *path = nil;
//    SFBill *bill = [SFBill existingObjectWithRemoteID:identifier];
    return path;
}

@end
