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
#import "SFLegislatorVoteTableViewController.h"
#import "SFLegislator.h"
#import "SFLegislatorService.h"
#import "SFCellDataTransformers.h"
#import "SFDateFormatterUtil.h"
#import "SFCellData.h"
#import "SFPanopticCell.h"
#import "SFOpticView.h"
#import "SFCongressButton.h"

@interface SFVoteDetailViewController () <UITableViewDataSource, UITableViewDelegate>
{
    SFDataTableViewController *_voteCountTableVC;
    SFLegislatorTableViewController *_legislatorsTableVC;
    SFLegislatorVoteTableViewController *_followedLegislatorVC;
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
        NSDateFormatter *dateFormatter = [SFDateFormatterUtil mediumDateShortTimeFormatter];

        NSAttributedString *preDescriptor = [[NSAttributedString alloc] initWithString:@"Voted: "
                                                                            attributes:@{ NSFontAttributeName: [UIFont subitleFont], NSForegroundColorAttributeName: [UIColor subtitleColor] }];
        NSMutableAttributedString *attributedDateString = [[NSMutableAttributedString alloc] initWithAttributedString:preDescriptor];
        NSAttributedString *dateString = [[NSAttributedString alloc] initWithString:[dateFormatter stringFromDate:_vote.votedAt]
                                                                         attributes:@{ NSFontAttributeName: [UIFont subitleStrongFont] }];
        [attributedDateString appendAttributedString:dateString];
        _voteDetailView.dateLabel.attributedText = attributedDateString;
        
        _voteDetailView.resultLabel.text = [_vote.result capitalizedString];

        _voteCountTableVC.items = _vote.choices;
        [_voteCountTableVC reloadTableView];

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

#pragma mark - _voteCountTableVC Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *choiceKey = (NSString *)[_voteCountTableVC itemForIndexPath:indexPath];
    NSArray *voter_ids = [_vote voterIdsForChoice:choiceKey];

    if ([voter_ids count] > 0) {
        // Retrieve legislators by ids.
        __weak SFVoteDetailViewController *weakSelf = self;
        [SFLegislatorService legislatorsWithIds:voter_ids completionBlock:^(NSArray *resultsArray) {
            [_legislatorsTableVC.tableView scrollToTop];
            _legislatorsTableVC.items = resultsArray;
            [_legislatorsTableVC.tableView reloadData];
            _legislatorsTableVC.title = [NSString stringWithFormat:@"%@: %@", [_vote.voteType capitalizedString], choiceKey];
            [weakSelf.navigationController pushViewController:_legislatorsTableVC animated:YES];
        }];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *choiceKey = self.vote.choices[indexPath.row];
    NSNumber *totalCount = self.vote.totals[choiceKey];
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:SFBasicTextCellTransformerName];
    NSNumber *shouldBeSelectable = [NSNumber numberWithBool:([totalCount integerValue] > 0)];
    NSDictionary *dataObj = @{ @"textLabelString": choiceKey, @"detailTextLabelString": [totalCount stringValue], @"selectable": shouldBeSelectable};
    SFCellData *cellData = [transformer transformedValue:dataObj];
    CGFloat cellHeight = [cellData heightForWidth:_voteCountTableVC.tableView.width];
    return cellHeight;
}

#pragma mark - Private

-(void)_initialize
{
    if (!_voteDetailView) {
        _voteDetailView = [[SFVoteDetailView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _voteDetailView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }

    [self _initVoteTableVC];

    _legislatorsTableVC = [[SFLegislatorTableViewController alloc] initWithStyle:UITableViewStylePlain];

    _voteDetailView.followedVoterLabel.text = @"Votes by legislators you follow";
    [self _initFollowedLegislatorVC];
}

- (void)_initFollowedLegislatorVC
{
    _followedLegislatorVC = [[SFLegislatorVoteTableViewController alloc] initWithStyle:UITableViewStylePlain];
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
    _voteCountTableVC = [[SFDataTableViewController alloc] initWithStyle:UITableViewStylePlain];
    __weak SFVoteDetailViewController *weakSelf = self;
    __weak SFDataTableViewController *weakVoteCountTableVC = _voteCountTableVC;
    _voteCountTableVC.cellForIndexPathHandler = ^id(NSIndexPath *indexPath){
        if (!indexPath) return nil;

        NSString *choiceKey = weakSelf.vote.choices[indexPath.row];
        NSNumber *totalCount = weakSelf.vote.totals[choiceKey];
        NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:SFBasicTextCellTransformerName];
        NSNumber *shouldBeSelectable = [NSNumber numberWithBool:([totalCount integerValue] > 0)];
        NSDictionary *dataObj = @{ @"textLabelString": choiceKey, @"detailTextLabelString": [totalCount stringValue], @"selectable": shouldBeSelectable};
        SFCellData *cellData = [transformer transformedValue:dataObj];

        SFTableCell *cell;
        cell = [weakVoteCountTableVC.tableView dequeueReusableCellWithIdentifier:cell.cellIdentifier];
        if(!cell) {
            cell = [[SFTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell.cellIdentifier];
        }

        [cell setCellData:cellData];

        CGFloat cellHeight = [cellData heightForWidth:weakVoteCountTableVC.tableView.width];
        [cell setFrame:CGRectMake(0, 0, cell.width, cellHeight)];
        return cell;
    };
    [self addChildViewController:_voteCountTableVC];
    self.voteDetailView.voteTable = _voteCountTableVC.tableView;
    _voteCountTableVC.tableView.delegate = self;
}

@end
