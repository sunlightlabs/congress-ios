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
#import "SFCommitteesTableDataSource.h"

SFDataTableOrderItemsInSectionsBlock const primaryNameOrderBlock = ^NSArray *(NSArray *sectionItems) {
    return [sectionItems sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"primaryName" ascending:YES]]];
};

SFDataTableSectionTitleGenerator const subcommitteeSectionGenerator = ^NSArray *(NSArray *items) {
    return @[@"Subcommittees"];
};

SFDataTableSortIntoSectionsBlock const subcommitteeSectionSorter = ^NSUInteger (id item, NSArray *sectionTitles) {
    return 0;
};

@interface SFCommitteesTableViewController ()

@end

@implementation SFCommitteesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataProvider = [SFCommitteesTableDataSource new];

    [self.dataProvider setOrderItemsInSectionsBlock:primaryNameOrderBlock];

    id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Committee List Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![tableView isEditing]) {
        SFCommittee *selectedCommittee = (SFCommittee *)[self.dataProvider itemForIndexPath:indexPath];
        SFCommitteeSegmentedViewController *vc = [[SFCommitteeSegmentedViewController alloc] initWithNibName:nil bundle:nil];
        [SFCommitteeService committeeWithId:selectedCommittee.committeeId completionBlock: ^(SFCommittee *committee) {
            [vc updateWithCommittee:committee];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFCommittee *committee = (SFCommittee *)[self.dataProvider itemForIndexPath:indexPath];

    if (!committee) return 0;

    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultCommitteeCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:committee];

    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return fmaxf(cellHeight, 52.0f);
}

#pragma mark - UIDataSourceModelAssociation

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view {
    SFCommittee *committee;
    if ([self.dataProvider.sections count] == 0) {
        committee = (SFCommittee *)[self.dataProvider.items objectAtIndex:idx.row];
    }
    else {
        committee = (SFCommittee *)[[self.dataProvider.sections objectAtIndex:idx.section] objectAtIndex:idx.row];
    }
    return committee.remoteID;
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view {
    __block NSIndexPath *path = nil;
    return path;
}

@end
