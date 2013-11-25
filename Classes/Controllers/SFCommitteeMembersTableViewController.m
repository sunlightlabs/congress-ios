//
//  SFCommitteeMembersTableViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/30/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteeMembersTableViewController.h"
#import "SFCommittee.h"
#import "SFCellData.h"
#import "SFTableCell.h"
#import "SFLegislatorSegmentedViewController.h"

@interface SFCommitteeMembersTableViewController ()

@end

@implementation SFCommitteeMembersTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.restorationIdentifier = NSStringFromClass(self.class);
    self.tableView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Committee Member List Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) return nil;
    
    SFCommitteeMember *member = (SFCommitteeMember *)[self.dataProvider itemForIndexPath:indexPath];
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:SFCommitteeMemberCellTransformerName];
    SFCellData *cellData = [transformer transformedValue:member];
    
    SFTableCell *cell;
    if (self.dataProvider.cellForIndexPathHandler)
    {
        cell =  self.dataProvider.cellForIndexPathHandler(indexPath);
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cell.cellIdentifier];
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

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFCommitteeMember *member = (SFCommitteeMember *)[self.dataProvider itemForIndexPath:indexPath];
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:SFCommitteeMemberCellTransformerName];
    SFCellData *cellData = [transformer transformedValue:member];
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFCommitteeMember *member = (SFCommitteeMember *)[[self.dataProvider.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    SFLegislatorSegmentedViewController *detailViewController = [[SFLegislatorSegmentedViewController alloc] initWithNibName:nil bundle:nil bioguideId:member.legislator.bioguideId];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
