//
//  SFHearingsTableViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/30/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFHearingsTableViewController.h"
#import "SFHearing.h"
#import "SFCellData.h"
#import "SFPanopticCell.h"
#import <GAI.h>
//#import <ISO8601DateFormatter.h>

SFDataTableSectionTitleGenerator const hearingSectionGenerator = ^NSArray*(NSArray *items) {
    return @[@"Upcoming Hearings", @"Recent Hearings"];
};
SFDataTableSortIntoSectionsBlock const hearingSectionSorter = ^NSUInteger(id item, NSArray *sectionTitles) {
    SFHearing *hearing = (SFHearing *)item;
    NSComparisonResult comp = [(NSDate*)[NSDate date] compare:hearing.occursAt];
    NSInteger index = (comp == NSOrderedDescending) ? 0 : 1;
    return [sectionTitles objectAtIndex:index];
};

@interface SFHearingsTableViewController ()

@end

@implementation SFHearingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Hearing List Screen"];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) return nil;
    
    SFHearing *hearing  = (SFHearing *)[self itemForIndexPath:indexPath];
    
    if (!hearing) return nil;
    
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultHearingCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:hearing];
    
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

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    SFHearing *hearing = (SFHearing *)[self itemForIndexPath:indexPath];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFHearing *hearing = (SFHearing *)[self itemForIndexPath:indexPath];
    
    if (!hearing) return 0;
    
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultHearingCellTransformerName];
    SFCellData *cellData = [valueTransformer transformedValue:hearing];
    
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return cellHeight;
}

#pragma mark - UIDataSourceModelAssociation

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view
{
    SFHearing *hearing;
    if ([self.sections count] == 0)
    {
        hearing = (SFHearing *)[self.items objectAtIndex:idx.row];
    }
    else
    {
        hearing = (SFHearing *)[[self.sections objectAtIndex:idx.section] objectAtIndex:idx.row];
    }
    return hearing.remoteID;
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view
{
    __block NSIndexPath* path = nil;
    return path;
}

@end
