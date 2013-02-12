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

@interface SFVoteDetailViewController () <UITableViewDataSource, UITableViewDelegate>

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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    // Configure the cell...
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    NSUInteger row = [indexPath row];
    NSString *choiceKey = _vote.choices[row];
    
    [[cell textLabel] setText:choiceKey];
    NSNumber *totalCount = _vote.totals[choiceKey];
    [[cell detailTextLabel] setText:[totalCount stringValue]];

    if ([totalCount integerValue] > 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSString *choiceKey = _vote.choices[row];
    NSArray *voter_ids = [_vote voterIdsForChoice:choiceKey];

    SFLegislatorListViewController *legislatorListVC = [[SFLegislatorListViewController alloc] initWithStyle:UITableViewStylePlain];
    // Retrieve legislators by ids. 
    __weak SFVoteDetailViewController *weakSelf = self;
    [SFLegislatorService legislatorsWithIds:voter_ids completionBlock:^(NSArray *resultsArray) {
        legislatorListVC.legislatorList = resultsArray;
        legislatorListVC.sections = @[resultsArray];
        [weakSelf.navigationController pushViewController:legislatorListVC animated:YES];
    }];
}

#pragma mark - Private

-(void)_initialize
{
    if (!_voteDetailView) {
        _voteDetailView = [[SFVoteDetailView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _voteDetailView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
}

@end
