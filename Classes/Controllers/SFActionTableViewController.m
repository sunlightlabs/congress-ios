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
#import "SFTableCell.h"
#import "GAI.h"

@interface SFActionTableViewController ()

@end

@implementation SFActionTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.restorationIdentifier = NSStringFromClass(self.class);
        self.sectionTitleGenerator = ^NSArray *(NSArray *items) {
            NSMutableArray *possibleSectionTitles = [NSMutableArray arrayWithArray:[items valueForKeyPath:@"@distinctUnionOfObjects.actedAt"]];
            [possibleSectionTitles addObjectsFromArray:[items valueForKeyPath:@"@distinctUnionOfObjects.votedAt"]];
            [possibleSectionTitles removeObjectIdenticalTo:[NSNull null]];
            [possibleSectionTitles sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"timeIntervalSince1970" ascending:NO]]];
            possibleSectionTitles = [possibleSectionTitles valueForKeyPath:@"stringWithMediumDateOnly"];
            NSOrderedSet *sectionTitlesSet = [NSOrderedSet orderedSetWithArray:possibleSectionTitles];
            return [sectionTitlesSet array];
        };
        self.sortIntoSectionsBlock = ^NSUInteger(id item, NSArray *sectionTitles) {

            NSString *dateString = @"";
            if ([item isKindOfClass:[SFBillAction class]]) {
                dateString = [item valueForKeyPath:@"actedAt.stringWithMediumDateOnly"];
            }
            else if ([item isKindOfClass:[SFRollCallVote class]])
            {
                dateString = [item valueForKeyPath:@"votedAt.stringWithMediumDateOnly"];
            }
            NSUInteger index = [sectionTitles indexOfObject:dateString];
            if (index != NSNotFound) {
                return index;
            }
            return 0;
        };

    }
    return self;
}

- (void)viewDidLoad
{
    self.tableView.delegate = self;
    [super viewDidLoad];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Action List Screen"];
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
    if (objectClass == [SFBillAction class]) {
        valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultBillActionCellTransformerName];
    }
    else if (objectClass == [SFRollCallVote class])
    {
        valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultRollCallVoteCellTransformerName];
    }
    SFCellData *cellData = [valueTransformer transformedValue:object];

    SFTableCell *cell;
    if (self.cellForIndexPathHandler) {
        cell = self.cellForIndexPathHandler(indexPath);
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cell.cellIdentifier];
        // Configure the cell...
        if(!cell) {
            cell = [[SFTableCell alloc] initWithStyle:cellData.cellStyle reuseIdentifier:cell.cellIdentifier];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id selection = [self itemForIndexPath:indexPath];
    if ([selection isKindOfClass:[SFRollCallVote class]]) {
        SFRollCallVote *vote = (SFRollCallVote *)selection;
        SFVoteDetailViewController *detailViewController = [[SFVoteDetailViewController alloc] initWithNibName:nil bundle:nil];
        detailViewController.vote = vote;
        detailViewController.title = vote.question;
        [self.navigationController pushViewController:detailViewController animated:YES];

    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self itemForIndexPath:indexPath];

    Class objectClass = [object class];
    NSValueTransformer *valueTransformer;
    if (objectClass == [SFBillAction class]) {
        valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultBillActionCellTransformerName];
    }
    else if (objectClass == [SFRollCallVote class])
    {
        valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultRollCallVoteCellTransformerName];
    }
    SFCellData *cellData = [valueTransformer transformedValue:object];

    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return cellHeight;
}

@end
