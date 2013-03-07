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
#import "SFTableCell.h"

@interface SFVoteDetailViewController () <UITableViewDataSource, UITableViewDelegate>
{
    SFLegislatorListViewController *__legislatorVoteVC;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	_voteDetailView.voteTable.delegate = self;
	_voteDetailView.voteTable.dataSource = self;
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

        self.title = [_vote.voteType capitalizedString];
        [self.view layoutSubviews];
        [_voteDetailView.voteTable reloadData];
    }];

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (!_vote) {
        return 0;
    }
    return [_vote.choices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SFTableCell";
    SFTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    // Configure the cell...
    if(!cell) {
        cell = [[SFTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    NSUInteger row = [indexPath row];
    NSString *choiceKey = _vote.choices[row];
    
    [[cell textLabel] setText:choiceKey];
    NSNumber *totalCount = _vote.totals[choiceKey];
    [[cell detailTextLabel] setText:[totalCount stringValue]];

    if ([totalCount integerValue] > 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSString *choiceKey = _vote.choices[row];
    NSArray *voter_ids = [_vote voterIdsForChoice:choiceKey];

    if ([voter_ids count] > 0) {
        // Retrieve legislators by ids.
        __weak SFVoteDetailViewController *weakSelf = self;
        [SFLegislatorService legislatorsWithIds:voter_ids completionBlock:^(NSArray *resultsArray) {
            [__legislatorVoteVC.tableView scrollToTop];
            __legislatorVoteVC.items = resultsArray;
            __legislatorVoteVC.sections = @[resultsArray];
            [__legislatorVoteVC.tableView reloadData];
            __legislatorVoteVC.title = [NSString stringWithFormat:@"%@: %@", [_vote.voteType capitalizedString], choiceKey];
            [weakSelf.navigationController pushViewController:__legislatorVoteVC animated:YES];
        }];
    }
    [_voteDetailView.voteTable deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Private

-(void)_initialize
{
    if (!_voteDetailView) {
        _voteDetailView = [[SFVoteDetailView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _voteDetailView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }

    __legislatorVoteVC = [[SFLegislatorListViewController alloc] initWithStyle:UITableViewStylePlain];
}

@end
