//
//  SFHearingsTableViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/30/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFHearingsTableViewController.h"
#import "SFHearingDetailViewController.h"
#import "SFHearing.h"
#import "SFHearingsTableDataSource.h"

SFDataTableSectionTitleGenerator const hearingSectionGenerator = ^NSArray *(NSArray *items) {
    NSDate *now = [NSDate date];
    NSMutableArray *sections = [NSMutableArray array];
    BOOL hasUpcoming = NSNotFound != [items indexOfObjectPassingTest: ^BOOL (id obj, NSUInteger idx, BOOL *stop) {
        return [now compare:[(SFHearing *)obj occursAt]] != NSOrderedDescending;
    }];
    BOOL hasRecent = NSNotFound != [items indexOfObjectPassingTest: ^BOOL (id obj, NSUInteger idx, BOOL *stop) {
        return [now compare:[(SFHearing *)obj occursAt]] == NSOrderedDescending;
    }];
    if (hasUpcoming) [sections addObject:@"Upcoming Hearings"];
    if (hasRecent) [sections addObject:@"Recent Hearings"];
    return sections;
};

SFDataTableSortIntoSectionsBlock const hearingSectionSorter = ^NSUInteger (id item, NSArray *sectionTitles) {
    SFHearing *hearing = (SFHearing *)item;
    NSComparisonResult comp = [(NSDate *)[NSDate date] compare : hearing.occursAt];
    return (comp == NSOrderedDescending) ? [sectionTitles indexOfObject:@"Recent Hearings"] : [sectionTitles indexOfObject:@"Upcoming Hearings"];
};

@interface SFHearingsTableViewController ()

@end

@implementation SFHearingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataProvider = [SFHearingsTableDataSource new];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Hearing List Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SFHearing *hearing = (SFHearing *)[self.dataProvider itemForIndexPath:indexPath];
    SFHearingDetailViewController *vc = [[SFHearingDetailViewController alloc] initWithNibName:nil bundle:nil];
    [vc updateWithHearing:hearing];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFHearing *hearing = (SFHearing *)[self.dataProvider itemForIndexPath:indexPath];

    if (!hearing) return 0;

    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultHearingCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:hearing];

    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return cellHeight;
}

#pragma mark - UIDataSourceModelAssociation

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view {
    SFHearing *hearing;
    if ([self.dataProvider.sections count] == 0) {
        hearing = (SFHearing *)[self.dataProvider.items objectAtIndex:idx.row];
    }
    else {
        hearing = (SFHearing *)[[self.dataProvider.sections objectAtIndex:idx.section] objectAtIndex:idx.row];
    }
    return hearing.remoteID;
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view {
    __block NSIndexPath *path = nil;
    return path;
}

@end
