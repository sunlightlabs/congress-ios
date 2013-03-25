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
#import "SFTableCell.h"
#import "GAI.h"

@interface SFActionTableViewController ()

@end

@implementation SFActionTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
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
    static NSString *CellIdentifier = @"SFTableCell";
    SFTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell) {
        cell = [[SFTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.numberOfLines = 3;
    
    id object = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[SFBillAction class]]) {
        SFBillAction *action = (SFBillAction *)object;
        cell.textLabel.text = action.text;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectable = NO;
    }
    else if ([object isKindOfClass:[SFRollCallVote class]])
    {
        SFRollCallVote *vote = (SFRollCallVote *)object;
        cell.textLabel.text = vote.question;
        cell.selectable = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id selection = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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
    SFTableCell *cell = (SFTableCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return ((SFTableCell *)cell).cellHeight;
}

@end
