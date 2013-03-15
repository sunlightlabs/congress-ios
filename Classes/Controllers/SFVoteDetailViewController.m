//
//  SFVoteDetailViewController.m
//  Congress
//
//  Created by Daniel Cloud on 2/7/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFVoteDetailViewController.h"
#import "SFVoteDetailView.h"
#import "SFRollCallVote.h"
#import "SFRollCallVoteService.h"
#import "SFLegislatorListViewController.h"
#import "SFLegislator.h"
#import "SFLegislatorService.h"
#import "SFLegislatorCell.h"
#import "SFTableCell.h"
#import "SFOpticView.h"
#import "SFCongressButton.h"

@interface SFVoteDetailViewController () <UITableViewDataSource, UITableViewDelegate>
{
    SFDataTableViewController *_voteTableVC;
    SFLegislatorListViewController *_legislatorVoteVC;
    SFLegislatorListViewController *_followedLegislatorVC;
}

@end

@implementation SFVoteDetailViewController

@synthesize voteDetailView = _voteDetailView;
@synthesize vote = _vote;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadView {
    _voteDetailView.frame = [[UIScreen mainScreen] bounds];
    _voteDetailView.autoresizesSubviews = YES;
    self.view = _voteDetailView;
}

-(void)setVote:(SFRollCallVote *)vote
{
    _vote = vote;

    [SFRollCallVoteService getVoteWithId:_vote.rollId completionBlock:^(SFRollCallVote *vote) {
        _vote = vote;
        _voteDetailView.titleLabel.text = _vote.question;
        NSDateFormatter *dateFormatter = [NSDateFormatter mediumDateShortTimeFormatter];
        _voteDetailView.dateLabel.text = [NSString stringWithFormat:@"Voted at: %@", [dateFormatter stringFromDate:_vote.votedAt]];
        _voteDetailView.resultLabel.text = [_vote.result capitalizedString];

        _voteTableVC.items = _vote.choices;
        _voteTableVC.sections = @[_vote.choices];
        [_voteTableVC reloadTableView];


        _followedLegislatorVC.items = [SFLegislator allObjectsToPersist];
        _followedLegislatorVC.sections = @[_followedLegislatorVC.items];

        self.title = [_vote.voteType capitalizedString];

        [_followedLegislatorVC reloadTableView];
        [self.view layoutSubviews];
    }];

}

#pragma mark - _voteTableVC Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSString *choiceKey = _vote.choices[row];
    NSArray *voter_ids = [_vote voterIdsForChoice:choiceKey];

    if ([voter_ids count] > 0) {
        // Retrieve legislators by ids.
        __weak SFVoteDetailViewController *weakSelf = self;
        [SFLegislatorService legislatorsWithIds:voter_ids completionBlock:^(NSArray *resultsArray) {
            [_legislatorVoteVC.tableView scrollToTop];
            _legislatorVoteVC.items = resultsArray;
            _legislatorVoteVC.sections = @[resultsArray];
            [_legislatorVoteVC.tableView reloadData];
            _legislatorVoteVC.title = [NSString stringWithFormat:@"%@: %@", [_vote.voteType capitalizedString], choiceKey];
            [weakSelf.navigationController pushViewController:_legislatorVoteVC animated:YES];
        }];
    }
//    [_voteDetailView.voteTable deselectRowAtIndexPath:indexPath animated:NO];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFTableCell *cell = (SFTableCell *)[_voteTableVC tableView:_voteTableVC.tableView cellForRowAtIndexPath:indexPath];
    return ((SFTableCell *)cell).cellHeight;
}

#pragma mark - Private

-(void)_initialize
{
    if (!_voteDetailView) {
        _voteDetailView = [[SFVoteDetailView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _voteDetailView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }

    [self _initVoteTableVC];

    _legislatorVoteVC = [[SFLegislatorListViewController alloc] initWithStyle:UITableViewStylePlain];

    _voteDetailView.followedVoterLabel.text = @"Votes by legislators you follow";
    [self _initFollowedLegislatorVC];
}

- (void)_initFollowedLegislatorVC
{
    _followedLegislatorVC = [[SFLegislatorListViewController alloc] initWithStyle:UITableViewStylePlain];
    __weak SFVoteDetailViewController *weakDetailVC = self;
    __weak SFLegislatorListViewController *weakfollowedVC = _followedLegislatorVC;
    _followedLegislatorVC.cellForIndexPathHandler = ^id(NSIndexPath *indexPath){
        static NSString *CellIdentifier = @"SFLegislatorCell";
        SFLegislatorCell *cell = [weakDetailVC.voteDetailView.followedVoterTable dequeueReusableCellWithIdentifier:CellIdentifier];

        // Configure the cell...
        if(!cell) {
            cell = [[SFLegislatorCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        else
        {
            [cell prepareForReuse];
        }

        SFLegislator *leg = (SFLegislator *)[[weakfollowedVC.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.legislator = leg;

        if (weakDetailVC.vote) {
            NSString *voteCast = (NSString *)[weakDetailVC.vote.voterDict safeObjectForKey:leg.bioguideId];
            if (voteCast) {
                SFOpticView *ov = [[SFOpticView alloc] initWithFrame:CGRectZero];
                ov.textLabel.text = [NSString stringWithFormat:@"Vote: %@", voteCast];
                [cell addPanelView:ov];
            }
        }

        return cell;
    };
    [self addChildViewController:_followedLegislatorVC];
    self.voteDetailView.followedVoterTable = _followedLegislatorVC.tableView;
}

- (void)_initVoteTableVC
{
    _voteTableVC = [[SFDataTableViewController alloc] initWithStyle:UITableViewStylePlain];
    __weak SFVoteDetailViewController *weakSelf = self;
    __weak SFDataTableViewController *weakVoteTableVC = _voteTableVC;
    static NSString *SFVoteCellIdentifier = @"SFVoteCell";
    _voteTableVC.cellForIndexPathHandler = ^id(NSIndexPath *indexPath){
        SFTableCell *cell = [weakVoteTableVC.tableView dequeueReusableCellWithIdentifier:SFVoteCellIdentifier];

        // Configure the cell...
        if(!cell) {
            cell = [[SFTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SFVoteCellIdentifier];
        }

        NSUInteger row = [indexPath row];
        NSString *choiceKey = weakSelf.vote.choices[row];

        [[cell textLabel] setText:choiceKey];
        NSNumber *totalCount = weakSelf.vote.totals[choiceKey];
        [[cell detailTextLabel] setText:[totalCount stringValue]];

        return cell;
    };
    [self addChildViewController:_voteTableVC];
    self.voteDetailView.voteTable = _voteTableVC.tableView;
    _voteTableVC.tableView.delegate = self;
}

@end
