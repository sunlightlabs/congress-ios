//
//  SFCommitteeMembersTableViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/30/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteeMembersTableViewController.h"
#import "SFCommittee.h"
#import "SFLegislatorSegmentedViewController.h"
#import "SFCommitteeMembersTableDataSource.h"

@interface SFCommitteeMembersTableViewController ()

@end

@implementation SFCommitteeMembersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataProvider = [SFCommitteeMembersTableDataSource new];

    self.restorationIdentifier = NSStringFromClass(self.class);
    self.tableView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Committee Member List Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SFCommitteeMember *member = (SFCommitteeMember *)[self.dataProvider itemForIndexPath:indexPath];
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:SFCommitteeMemberCellTransformerName];
    SFCellData *cellData = [transformer transformedValue:member];
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SFCommitteeMember *member = (SFCommitteeMember *)[[self.dataProvider.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    SFLegislatorSegmentedViewController *detailViewController = [[SFLegislatorSegmentedViewController alloc] initWithNibName:nil bundle:nil bioguideId:member.legislator.bioguideId];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
