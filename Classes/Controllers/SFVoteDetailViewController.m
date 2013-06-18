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
#import "UIScrollView+SVInfiniteScrolling.h"
#import "SVPullToRefreshView+Congress.h"

@interface SFVoteDetailViewController () <UITableViewDataSource, UITableViewDelegate>
{
    SFDataTableViewController *_voteCountTableVC;
    SFLegislatorTableViewController *_legislatorsTableVC;
    SFLegislatorVoteTableViewController *_followedLegislatorVC;
    NSString *_restorationRollId;
    SSLoadingView *_loadingView;
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
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        _restorationRollId = nil;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([_voteDetailView.dateLabel.text isEqualToString:@""]) {
        [self setVote:_vote];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_restorationRollId) {
        [SFRollCallVoteService getVoteWithId:_restorationRollId completionBlock:^(SFRollCallVote *vote) {
            if (vote) {
                [self setVote:vote];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        _restorationRollId = nil;
    }
}

- (void) loadView {
    _voteDetailView.frame = [[UIScreen mainScreen] bounds];
    _voteDetailView.autoresizesSubviews = YES;
    self.view = _voteDetailView;
}

-(void)setVote:(SFRollCallVote *)vote
{
    _vote = vote;

    [self.view addSubview:_loadingView];
    [self.view bringSubviewToFront:_loadingView];


    [self _fetchVoteData];
}

#pragma mark - _voteCountTableVC Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *choiceKey = (NSString *)[_voteCountTableVC itemForIndexPath:indexPath];
    NSArray *voter_ids = [_vote voterIdsForChoice:choiceKey];

    if ([voter_ids count] > 0) {
        // Retrieve legislators by ids.
        __weak SFVoteDetailViewController *weakSelf = self;
        _legislatorsTableVC = [[SFLegislatorTableViewController alloc] initWithStyle:UITableViewStylePlain];
        _legislatorsTableVC.sortIntoSectionsBlock = byLastNameSorterBlock;
        _legislatorsTableVC.orderItemsInSectionsBlock = lastNameFirstOrderBlock;
        _legislatorsTableVC.sectionTitleGenerator = lastNameTitlesGenerator;
        __weak SFLegislatorTableViewController *weaklegislatorsTableVC = _legislatorsTableVC;
        [_legislatorsTableVC.tableView scrollToTop];
        _legislatorsTableVC.items = @[];
        [_legislatorsTableVC.tableView reloadData];

        [_legislatorsTableVC.tableView addInfiniteScrollingWithActionHandler:^{
            NSInteger loc = [weaklegislatorsTableVC.items count];
            NSInteger unretrievedCount = [voter_ids count]-[weaklegislatorsTableVC.items count];
            if (unretrievedCount > 0) {
                NSInteger length = unretrievedCount < 50 ? unretrievedCount : 50;
                NSRange idRange = NSMakeRange(loc, length);
                NSIndexSet *retrievalIndexes = [NSIndexSet indexSetWithIndexesInRange:idRange];
                NSArray *retrievalSet = [voter_ids objectsAtIndexes:retrievalIndexes];
                BOOL didRun = [SSRateLimit executeBlock:^{
                    [SFLegislatorService legislatorsWithIds:retrievalSet count:length completionBlock:^(NSArray *resultsArray) {
                        NSArray *newItems = [resultsArray sortedArrayUsingDescriptors:
                                             @[
                                             [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES],
                                             [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES],
                                             [NSSortDescriptor sortDescriptorWithKey:@"stateName" ascending:YES]
                                             ]];
                        weaklegislatorsTableVC.items = [weaklegislatorsTableVC.items arrayByAddingObjectsFromArray:newItems];
                        [weaklegislatorsTableVC sortItemsIntoSectionsAndReload];
                        [weaklegislatorsTableVC.tableView.infiniteScrollingView stopAnimating];

                    }];
                } name:@"_legislatorsTableVC-InfiniteScroll" limit:1.0f];
                if (!didRun) {
                    [weaklegislatorsTableVC.tableView.infiniteScrollingView stopAnimating];
                }

            }
            else
            {
                [weaklegislatorsTableVC.tableView.infiniteScrollingView stopAnimating];
            }
        }];
        _legislatorsTableVC.title = [NSString stringWithFormat:@"%@: %@", [weakSelf.vote.voteType capitalizedString], choiceKey];
        [self.navigationController pushViewController:_legislatorsTableVC animated:YES];
        [_legislatorsTableVC.tableView triggerInfiniteScrolling];
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

    _voteDetailView.followedVoterLabel.text = @"Votes by legislators you follow";
    [self _initFollowedLegislatorVC];

    CGSize size = self.view.frame.size;
    _loadingView = [[SSLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    _loadingView.backgroundColor = [UIColor primaryBackgroundColor];
    _loadingView.textLabel.text = @"Loading vote info.";
    [self.view addSubview:_loadingView];
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

//        if (cellData.persist && [cell respondsToSelector:@selector(setPersistStyle)]) {
//            [cell performSelector:@selector(setPersistStyle)];
//        }
        CGFloat cellHeight = [cellData heightForWidth:weakDetailVC.voteDetailView.followedVoterTable.width];
        [cell setFrame:CGRectMake(0, 0, cell.width, cellHeight)];
        
        NSLog(@"-----> %@", cell.accessibilityValue);

        if (weakDetailVC.vote) {
            SFOpticView *legVoteView = [[SFOpticView alloc] initWithFrame:CGRectZero];
            NSString *voteCast = (NSString *)[weakDetailVC.vote.voterDict safeObjectForKey:legislator.bioguideId];
            if (voteCast)
            {
                legVoteView.textLabel.text = [NSString stringWithFormat:@"Vote: %@", voteCast];
                [cell setAccessibilityValue:[NSString stringWithFormat:@"%@ voted %@", cell.accessibilityValue, voteCast]];
            }
            else
            {
                legVoteView.textLabel.text = [NSString stringWithFormat:@"No vote recorded"];
                [cell setAccessibilityValue:[NSString stringWithFormat:@"%@ had no recorded vote", cell.accessibilityValue]];
            }
            
            [cell addPanelView:legVoteView];
        }
        
        [cell setAccessibilityLabel:@"Followed Legislator"];

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
        [cell setAccessibilityLabel:@"Vote"];
        [cell setAccessibilityValue:[NSString stringWithFormat:@"%@ %@", totalCount, choiceKey]];
        
        if ([totalCount integerValue] > 0) {
            if ([choiceKey isEqualToString:@"Not Voting"]) {
                [cell setAccessibilityHint:@"Tap to view legislators that did not vote"];
            } else {
                [cell setAccessibilityHint:[NSString stringWithFormat:@"Tap to view legislators that voted %@", choiceKey]];
            }
        }

        CGFloat cellHeight = [cellData heightForWidth:weakVoteCountTableVC.tableView.width];
        [cell setFrame:CGRectMake(0, 0, cell.width, cellHeight)];
        return cell;
    };
    [self addChildViewController:_voteCountTableVC];
    self.voteDetailView.voteTable = _voteCountTableVC.tableView;
    _voteCountTableVC.tableView.delegate = self;
}

- (void)_fetchVoteData
{
    [SFRollCallVoteService getVoteWithId:self.vote.rollId completionBlock:^(SFRollCallVote *vote) {
        _vote = vote;
        _voteDetailView.titleLabel.text = _vote.question;
        [_voteDetailView.titleLabel setAccessibilityValue:_vote.question];
        NSDateFormatter *dateFormatter = [SFDateFormatterUtil mediumDateShortTimeFormatter];

        NSAttributedString *preDescriptor = [[NSAttributedString alloc] initWithString:@"Voted: "
                                                                            attributes:@{ NSFontAttributeName: [UIFont subitleFont], NSForegroundColorAttributeName: [UIColor subtitleColor] }];
        NSMutableAttributedString *attributedDateString = [[NSMutableAttributedString alloc] initWithAttributedString:preDescriptor];
        NSAttributedString *dateString = [[NSAttributedString alloc] initWithString:[dateFormatter stringFromDate:_vote.votedAt]
                                                                         attributes:@{ NSFontAttributeName: [UIFont subitleStrongFont] }];
        [attributedDateString appendAttributedString:dateString];
        _voteDetailView.dateLabel.attributedText = attributedDateString;
        [_voteDetailView.dateLabel setAccessibilityValue:[dateFormatter stringFromDate:_vote.votedAt]];

        _voteDetailView.resultLabel.text = [_vote.result capitalizedString];
        [_voteDetailView.resultLabel setAccessibilityValue:[_vote.result capitalizedString]];

        _voteCountTableVC.items = _vote.choices;
        [_voteCountTableVC reloadTableView];
        
        NSArray *allFollowedLegislators = [SFLegislator allObjectsToPersist];
        NSIndexSet *indexesOfLegislators = [allFollowedLegislators indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                SFLegislator *legislator = (SFLegislator *)obj;
                BOOL inChamber = [legislator.chamber isEqualToString:_vote.chamber];
                BOOL didVote = [_vote.voterDict objectForKey:legislator.bioguideId] != nil;
                return inChamber && didVote;
            }];
        _followedLegislatorVC.items = [[allFollowedLegislators objectsAtIndexes:indexesOfLegislators] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES]]];
        _followedLegislatorVC.sections = @[_followedLegislatorVC.items];

        self.title = [_vote.voteType capitalizedString];
        
        [_followedLegislatorVC reloadTableView];
        [_voteDetailView.followedVoterLabel setHidden:_followedLegislatorVC.items.count == 0];
        
        [self.view layoutSubviews];
        [_loadingView fadeOutAndRemoveFromSuperview];
    }];

}

#pragma mark - UIViewControllerRestoration

+ (UIViewController*)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [SFVoteDetailViewController new];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    NSString *rollId = _vote ? _vote.rollId : _restorationRollId;
    [coder encodeObject:rollId forKey:@"rollId"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    _restorationRollId = [coder decodeObjectForKey:@"rollId"];
}

@end
