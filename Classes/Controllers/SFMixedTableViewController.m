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
#import "SFPanopticCell.h"
#import "SFBill.h"
#import "SFBillSegmentedViewController.h"
#import "SFLegislator.h"
#import "SFLegislatorDetailViewController.h"

@interface SFMixedTableViewController () <UIDataSourceModelAssociation>

@end

@implementation SFMixedTableViewController

@synthesize items;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.items = [NSMutableArray array];
        self.tableView.dataSource = self;
//        self.restorationClass= [self class];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) return nil;

    id object = [self itemForIndexPath:indexPath];

    Class objectClass = [object class];
    NSValueTransformer *valueTransformer;
    if (objectClass == [SFBill class]) {
        valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultBillCellTransformerName];
    }
    else if (objectClass == [SFLegislator class])
    {
        valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultLegislatorCellTransformerName];
    }
    SFCellData *cellData = [valueTransformer transformedValue:object];

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
    id object = [self itemForIndexPath:indexPath];
    id detailViewController = nil;
    if ([object isKindOfClass:SFBill.class]) {
        SFBillSegmentedViewController *vc = [[SFBillSegmentedViewController alloc] initWithNibName:nil bundle:nil];
        vc.bill = (SFBill *)object;
        detailViewController = vc;
    }
    else if ([object isKindOfClass:SFLegislator.class])
    {
        SFLegislatorDetailViewController *vc = [[SFLegislatorDetailViewController alloc] initWithNibName:nil bundle:nil];
        vc.legislator = (SFLegislator *)object;
        detailViewController = vc;
    }
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self itemForIndexPath:indexPath];

    Class objectClass = [object class];
    NSValueTransformer *valueTransformer;
    if (objectClass == [SFBill class]) {
        valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultBillCellTransformerName];
    }
    else if (objectClass == [SFLegislator class])
    {
        valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultLegislatorCellTransformerName];
    }
    SFCellData *cellData = [valueTransformer transformedValue:object];

    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return cellHeight;
}

#pragma mark - Application state

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%@: encodeRestorableStateWithCoder", self.restorationIdentifier);
    [coder encodeObject:self.items forKey:@"items"];
    [coder encodeFloat:self.tableView.contentOffset.y forKey:@"contentOffset_y"];
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSLog(@"%@: encodeRestorableStateWithCoder", self.restorationIdentifier);
    [super decodeRestorableStateWithCoder:coder];
    NSMutableArray *sItems = [coder decodeObjectForKey:@"items"];
    self.items = sItems;
    CGFloat contentOffset_y = [coder decodeFloatForKey:@"contentOffset_y"];
    self.tableView.contentOffset = CGPointMake(0.0f, contentOffset_y);
    [self.tableView reloadData];
}

#pragma mark - UIDataSourceModelAssociation protocol

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view
{
    NSLog(@"%@: modelIdentifierForElementAtIndexPath", self.restorationIdentifier);
    SFBill *bill = (SFBill *)[self.items objectAtIndex:idx.row];
    return bill.remoteID;
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view
{
    NSLog(@"%@: indexPathForElementWithModelIdentifier", self.restorationIdentifier);
    __block NSIndexPath* path = nil;
    SFBill *bill = [SFBill existingObjectWithRemoteID:identifier];
    NSInteger rowIndex = [self.items indexOfObjectIdenticalTo:bill];
    path = [NSIndexPath indexPathForItem:rowIndex inSection:0];
    return path;
}

@end
