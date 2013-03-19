//
//  SFActionListViewController.m
//  Congress
//
//  Created by Daniel Cloud on 1/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFActionListViewController.h"
#import "SFBillAction.h"
#import "SFVoteDetailViewController.h"
#import "SFRollCallVote.h"
#import "SFTableCell.h"
#import "GAI.h"

@interface SFActionListViewController ()

@end

@implementation SFActionListViewController

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
        NSDateFormatter *dateFormatter = nil;
        if (action.actedAtIsDateTime) {
            dateFormatter = [NSDateFormatter mediumDateShortTimeFormatter];
        }
        else
        {
            dateFormatter = [NSDateFormatter ISO8601DateOnlyFormatter];
            dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        }
        cell.detailTextLabel.text = [dateFormatter stringFromDate:action.actedAt];

        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if ([object isKindOfClass:[SFRollCallVote class]])
    {
        SFRollCallVote *vote = (SFRollCallVote *)object;
        cell.textLabel.text = vote.question;
        NSDateFormatter *dateFormatter = [NSDateFormatter mediumDateShortTimeFormatter];
        cell.detailTextLabel.text = [dateFormatter stringFromDate:vote.votedAt];

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
