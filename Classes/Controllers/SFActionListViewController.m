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

@interface SFActionListViewController ()

@end

@implementation SFActionListViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)viewDidLoad
{
    self.tableView.delegate = self;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_sections) {
        return 0;
    }
    return [_sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_sections) {
        return [_dataArray count];
    }
    return [[_sections objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SFTableCell";
    SFTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.textColor = [UIColor blackColor];
    
    if(!cell) {
        cell = [[SFTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

#pragma mark - Accessor methods

-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self sortDataIntoSections];
    [self.tableView reloadData];
}


#pragma mark - Private

-(void)_initialize
{
    _sectionTitles = @[];
    _sections = @[];
}

-(void)sortDataIntoSections
{
    _sections = @[_dataArray];
}

@end
