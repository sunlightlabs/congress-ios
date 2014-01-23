//
//  SFActionListViewController.m
//  Congress
//
//  Created by Daniel Cloud on 1/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFActionTableViewController.h"
#import "SFBillAction.h"
#import "SFVoteDetailViewController.h"
#import "SFRollCallVote.h"
#import "SFCellDataTransformers.h"
#import "SFCellData.h"
#import "SFDateFormatterUtil.h"
#import "SFActionTableDataSource.h"

@implementation SFActionTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.restorationIdentifier = NSStringFromClass(self.class);
    }
    return self;
}

- (void)viewDidLoad {
    self.tableView.delegate = self;
    self.dataProvider = [SFActionTableDataSource new];
    self.dataProvider.sectionTitleGenerator = ^NSArray *(NSArray *items) {
        NSMutableArray *possibleSectionTitleValues = [NSMutableArray arrayWithArray:[items valueForKeyPath:@"@distinctUnionOfObjects.actedAt"]];
        [possibleSectionTitleValues addObjectsFromArray:[items valueForKeyPath:@"@distinctUnionOfObjects.votedAt"]];
        [possibleSectionTitleValues removeObjectIdenticalTo:[NSNull null]];
        [possibleSectionTitleValues sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"timeIntervalSince1970" ascending:NO]]];
        NSMutableArray *sectionTitleStrings = [NSMutableArray array];
        NSDateFormatter *dateFormatter = [SFDateFormatterUtil mediumDateNoTimeFormatter];
        for (NSDate *date in possibleSectionTitleValues) {
            [sectionTitleStrings addObject:[dateFormatter stringFromDate:date]];
        }
        NSOrderedSet *sectionTitlesSet = [NSOrderedSet orderedSetWithArray:sectionTitleStrings];
        return [sectionTitlesSet array];
    };
    self.dataProvider.sortIntoSectionsBlock = ^NSUInteger (id item, NSArray *sectionTitles) {
        NSString *dateString = @"";
        NSDateFormatter *df = [SFDateFormatterUtil mediumDateNoTimeFormatter];
        if ([item isKindOfClass:[SFBillAction class]]) {
            dateString = [df stringFromDate:[item valueForKeyPath:@"actedAt"]];
        }
        else if ([item isKindOfClass:[SFRollCallVote class]]) {
            dateString = [df stringFromDate:[item valueForKeyPath:@"votedAt"]];
        }
        NSUInteger index = [sectionTitles indexOfObject:dateString];
        if (index != NSNotFound) {
            return index;
        }
        return 0;
    };

    [super viewDidLoad];

    id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Action List Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id selection = [self.dataProvider itemForIndexPath:indexPath];
    id rollId = [selection valueForKeyPath:@"rollId"];
    if (rollId) {
        SFVoteDetailViewController *detailViewController = [[SFVoteDetailViewController alloc] initWithNibName:nil bundle:nil];
        [detailViewController retrieveVoteForId:(NSString *)rollId];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.dataProvider itemForIndexPath:indexPath];

    Class objectClass = [object class];
    NSValueTransformer *valueTransformer;
    if (objectClass == [SFBillAction class]) {
        valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultBillActionCellTransformerName];
    }
    else if (objectClass == [SFRollCallVote class]) {
        valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultRollCallVoteCellTransformerName];
    }
    SFCellData *cellData = [valueTransformer transformedValue:object];

    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return cellHeight;
}

@end
