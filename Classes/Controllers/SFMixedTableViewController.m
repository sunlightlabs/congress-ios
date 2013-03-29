//
//  SFMixedCellTableViewController.m
//  Congress
//
//  Created by Daniel Cloud on 2/20/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFMixedTableViewController.h"
#import "SFPanopticCell.h"
#import "SFBill.h"
#import "SFBillCell.h"
#import "SFBillSegmentedViewController.h"
#import "SFLegislator.h"
#import "SFLegislatorCell.h"
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self.tableView registerClass:SFBillCell.class forCellReuseIdentifier:@"SFBillCell"];
    [self.tableView registerClass:SFLegislatorCell.class forCellReuseIdentifier:@"SFLegislatorCell"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    id object = [self.items objectAtIndex:row];
    NSString *cellIdentifier = @"UITableViewCell";
    Class cellClass = nil;
    if ([object isKindOfClass:SFBill.class]) {
        cellIdentifier = @"SFBillCell";
        cellClass = SFBillCell.class;
    }
    else if ([object isKindOfClass:SFLegislator.class])
    {
        cellIdentifier = @"SFLegislatorCell";
        cellClass = SFLegislatorCell.class;
   }
    id cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // Configure the cell...
    if(!cell) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    if ([cell isKindOfClass:NSClassFromString(@"SFBillCell")]) {
        ((SFBillCell *)cell).bill = (SFBill *)object;
    }
    else if ([cell isKindOfClass:NSClassFromString(@"SFLegislatorCell")]) {
        ((SFLegislatorCell *)cell).legislator = (SFLegislator *)object;
    }

    [cell setFrame:CGRectMake(0, 0, ((SFPanopticCell *)cell).width, ((SFPanopticCell *)cell).cellHeight)];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.items objectAtIndex:[indexPath row]];
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
    id cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    CGFloat height = 44.0f;
    if ([cell isKindOfClass:SFPanopticCell.class]) {
        height = ((SFPanopticCell *)cell).cellHeight;
    }
    return height;
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
