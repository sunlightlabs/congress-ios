//
//  SFMixedCellTableViewController.m
//  Congress
//
//  Created by Daniel Cloud on 2/20/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFMixedTableViewController.h"
#import "SFCellDataTransformers.h"
#import "SFCellData.h"
#import "SFTableCell.h"
#import "SFBill.h"
#import "SFBillSegmentedViewController.h"
#import "SFLegislator.h"
#import "SFLegislatorSegmentedViewController.h"
#import "SFMixedTableDataSource.h"

@interface SFMixedTableViewController () <UIDataSourceModelAssociation>

@end

@implementation SFMixedTableViewController

- (void)viewDidLoad {
    self.dataProvider = [SFMixedTableDataSource new];
    [super viewDidLoad];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.dataProvider itemForIndexPath:indexPath];
    id detailViewController = nil;
    if ([object isKindOfClass:SFBill.class]) {
        SFBillSegmentedViewController *vc = [[SFBillSegmentedViewController alloc] initWithNibName:nil bundle:nil];
        vc.bill = (SFBill *)object;
        detailViewController = vc;
    }
    else if ([object isKindOfClass:SFLegislator.class]) {
        SFLegislatorSegmentedViewController *vc = [[SFLegislatorSegmentedViewController alloc] initWithNibName:nil bundle:nil];
        vc.legislator = (SFLegislator *)object;
        detailViewController = vc;
    }
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.dataProvider itemForIndexPath:indexPath];

    Class objectClass = [object class];
    NSValueTransformer *valueTransformer;
    if (objectClass == [SFBill class]) {
        valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultBillCellTransformerName];
    }
    else if (objectClass == [SFLegislator class]) {
        valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultLegislatorCellTransformerName];
    }
    SFCellData *cellData = [valueTransformer transformedValue:object];

    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return cellHeight;
}

#pragma mark - Application state

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.dataProvider.items forKey:@"items"];
    [coder encodeFloat:self.tableView.contentOffset.y forKey:@"contentOffset_y"];
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    NSMutableArray *sItems = [coder decodeObjectForKey:@"items"];
    self.dataProvider.items = sItems;
    CGFloat contentOffset_y = [coder decodeFloatForKey:@"contentOffset_y"];
    self.tableView.contentOffset = CGPointMake(0.0f, contentOffset_y);
    [self.tableView reloadData];
}

#pragma mark - UIDataSourceModelAssociation protocol

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view {
    NSLog(@"%@: modelIdentifierForElementAtIndexPath", self.restorationIdentifier);
    SFBill *bill = (SFBill *)[self.dataProvider.items objectAtIndex:idx.row];
    return bill.remoteID;
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view {
    NSLog(@"%@: indexPathForElementWithModelIdentifier", self.restorationIdentifier);
    __block NSIndexPath *path = nil;
    SFBill *bill = [SFBill existingObjectWithRemoteID:identifier];
    NSInteger rowIndex = [self.dataProvider.items indexOfObjectIdenticalTo:bill];
    path = [NSIndexPath indexPathForItem:rowIndex inSection:0];
    return path;
}

@end
