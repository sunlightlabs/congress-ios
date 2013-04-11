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
#import "SFLegislatorTableViewController.h"
#import "SFLegislator.h"
#import "SFLegislatorService.h"
#import "SFCellDataTransformers.h"
#import "SFCellData.h"
#import "SFPanopticCell.h"
#import "SFOpticView.h"
#import "SFCongressButton.h"

@interface SFVoteDetailViewController () <UITableViewDataSource, UITableViewDelegate>
{
    SFDataTableViewController *_voteTableVC;
    SFLegislatorTableViewController *_legislatorVoteVC;
    SFLegislatorTableViewController *_followedLegislatorVC;
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
        self.trackedViewName = @"Vote Detail Screen";
        self.restorationIdentifier = NSStringFromClass(self.class);
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

        NSArray *allFollowedLegislators = [SFLegislator allObjectsToPersist];
        _followedLegislatorVC.items = [allFollowedLegislators mtl_filterUsingBlock:^BOOL(id obj) {
            return [((SFLegislator *)obj).chamber isEqualToString:_vote.chamber];
        }];
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

    _legislatorVoteVC = [[SFLegislatorTableViewController alloc] initWithStyle:UITableViewStylePlain];

    _voteDetailView.followedVoterLabel.text = @"Votes by legislators you follow";
    [self _initFollowedLegislatorVC];
}

- (void)_initFollowedLegislatorVC
{
    _followedLegislatorVC = [[SFLegislatorTableViewController alloc] initWithStyle:UITableViewStylePlain];
    __weak SFVoteDetailViewController *weakDetailVC = self;
    __weak SFLegislatorTableViewController *weakLegislatorVC = _followedLegislatorVC;
    _followedLegislatorVC.cellForIndexPathHandler = ^id(NSIndexPath *indexPath){
        if (indexPath == nil) return nil;

        __strong SFLegislatorTableViewController *strongLegislatorVC = weakLegislatorVC;
        SFLegislator *legislator = (SFLegislator *)[strongLegislatorVC itemForIndexPath:indexPath];
        NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:SFLegislatorVoteCellTransformerName];
        SFCellData *cellData = [transformer transformedValue:legislator];

        SFPanopticCell *cell;
        cell = [weakDetailVC.voteDetailView.followedVoterTable dequeueReusableCellWithIdentifier:cell.cellIdentifier];

        // Configure the cell...
        if(!cell) {
            cell = [[SFPanopticCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell.cellIdentifier];
        }

        [cell setCellData:cellData];
        if (cellData.persist && [cell respondsToSelector:@selector(setPersistStyle)]) {
            [cell performSelector:@selector(setPersistStyle)];
        }
        CGFloat cellHeight = [cellData heightForWidth:weakDetailVC.voteDetailView.followedVoterTable.width];
        [cell setFrame:CGRectMake(0, 0, cell.width, cellHeight)];

        if (weakDetailVC.vote) {
            SFOpticView *legVoteView = [[SFOpticView alloc] initWithFrame:CGRectZero];
            NSString *voteCast = (NSString *)[weakDetailVC.vote.voterDict safeObjectForKey:legislator.bioguideId];
            if (voteCast)
            {
                legVoteView.textLabel.text = [NSString stringWithFormat:@"Vote: %@", voteCast];
            }
            else
            {
                legVoteView.textLabel.text = [NSString stringWithFormat:@"No vote recorded"];
            }
            [cell addPanelView:legVoteView];

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
        cell.selectable = ([totalCount integerValue] > 0);

        return cell;
    };
    [self addChildViewController:_voteTableVC];
    self.voteDetailView.voteTable = _voteTableVC.tableView;
    _voteTableVC.tableView.delegate = self;
}

@end
