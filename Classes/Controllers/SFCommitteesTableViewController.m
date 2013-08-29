//
//  SFCommitteesTableViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/19/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteesTableViewController.h"
#import "SFCommitteeService.h"
#import "SFCommitteeSegmentedViewController.h"
#import "SFCommittee.h"
#import "SFCellData.h"
#import "SFPanopticCell.h"

SFDataTableOrderItemsInSectionsBlock const primaryNameOrderBlock = ^NSArray*(NSArray *sectionItems) {
    return [sectionItems sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"primaryName" ascending:YES]]];
};

SFDataTableSectionTitleGenerator const subcommitteeSectionGenerator = ^NSArray*(NSArray *items) {
    return @[@"Subcommittees"];
};

SFDataTableSortIntoSectionsBlock const subcommitteeSectionSorter = ^NSUInteger(id item, NSArray *sectionTitles) {
    return 0;
};

@interface SFCommitteesTableViewController ()

@end

@implementation SFCommitteesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setOrderItemsInSectionsBlock:primaryNameOrderBlock];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Committee List Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) return nil;
    
    SFCommittee *committee  = (SFCommittee *)[self itemForIndexPath:indexPath];
    
    if (!committee) return nil;
    
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultCommitteeCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:committee];
    
    SFPanopticCell *cell;
    
    if (self.cellForIndexPathHandler)
    {
        cell = self.cellForIndexPathHandler(indexPath);
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cell.cellIdentifier];
        if (!cell) {
            cell = [[SFPanopticCell alloc] initWithStyle:cellData.cellStyle
                                         reuseIdentifier:cell.cellIdentifier];
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFCommittee *selectedCommittee = (SFCommittee *)[self itemForIndexPath:indexPath];
    SFCommitteeSegmentedViewController *vc = [[SFCommitteeSegmentedViewController alloc] initWithNibName:nil bundle:nil];
    [SFCommitteeService committeeWithId:selectedCommittee.committeeId completionBlock:^(SFCommittee *committee) {
        [vc updateWithCommittee:committee];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFCommittee *committee = (SFCommittee *)[self itemForIndexPath:indexPath];
    
    if (!committee) return 0;
    
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultCommitteeCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:committee];
    
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return fmaxf(cellHeight, 52.0f);
}

#pragma mark - UIDataSourceModelAssociation

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view
{
    SFCommittee *committee;
    if ([self.sections count] == 0) {
        committee = (SFCommittee *)[self.items objectAtIndex:idx.row];
    }
    else
    {
        committee = (SFCommittee *)[[self.sections objectAtIndex:idx.section] objectAtIndex:idx.row];
    }
    return committee.remoteID;
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view
{
    __block NSIndexPath* path = nil;
    return path;
}

@end
