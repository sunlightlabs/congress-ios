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
#import "SFDateFormatterUtil.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "SVPullToRefreshView+Congress.h"
#import "SFCongressButton.h"
#import "SFBillSegmentedViewController.h"
#import "SFBillService.h"
#import "SFVoteCountTableDataSource.h"
#import "SFLegislatorVoteTableDataSource.h"
#import <SAMLoadingView/SAMLoadingView.h>
#import <SAMRateLimit/SAMRateLimit.h>

@interface SFVoteDetailViewController () <UITableViewDelegate>
{
    SFDataTableViewController *_voteCountTableVC;
    SFLegislatorTableViewController *_legislatorsTableVC;
    SFLegislatorVoteTableViewController *_followedLegislatorVC;
    NSString *_restorationRollId;
    SAMLoadingView *_loadingView;
}

- (void)updateFollowedLegislatorVotes;
- (void)navigateToBill;

@end

@implementation SFVoteDetailViewController

@synthesize voteDetailView = _voteDetailView;
@synthesize vote = _vote;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.screenName = @"Vote Detail Screen";
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        _restorationRollId = nil;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([_voteDetailView.dateLabel.text isEqualToString:@""]) {
        [self setVote:_vote];
    } else if (self.vote) {
        [self updateFollowedLegislatorVotes];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_restorationRollId) {
        [SFRollCallVoteService getVoteWithId:_restorationRollId completionBlock: ^(SFRollCallVote *vote) {
            if (vote) {
                [self setVote:vote];
            }
            else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        _restorationRollId = nil;
    }

    CGRect bounds = [[UIScreen mainScreen] bounds];
    [_voteDetailView setFrame:bounds];
    [_voteDetailView updateConstraints];
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = view;
}

- (void)viewDidLoad {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _voteDetailView = [[SFVoteDetailView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _voteDetailView.translatesAutoresizingMaskIntoConstraints = NO;
    _voteDetailView.autoresizesSubviews = NO;
    _voteDetailView.backgroundColor = [UIColor primaryBackgroundColor];
    [self.view addSubview:_voteDetailView];

    [self _initVoteTableVC];

    _voteDetailView.followedVoterLabel.text = @"Votes by legislators you follow";
    [self _initFollowedLegislatorVC];

    [_voteDetailView.billButton sam_setTarget:self action:@selector(navigateToBill) forControlEvents:UIControlEventTouchUpInside];

    CGSize size = self.view.frame.size;
    _loadingView = [[SAMLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    _loadingView.backgroundColor = [UIColor primaryBackgroundColor];
    _loadingView.textLabel.text = @"Loading vote info.";
    [self.view addSubview:_loadingView];

    /* layout */

    NSDictionary *viewDict = @{ @"detail": _voteDetailView,
                                @"loading": _loadingView };

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[detail]|" options:0 metrics:nil views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[detail]|" options:0 metrics:nil views:viewDict]];
}

- (void)setVote:(SFRollCallVote *)vote {
    _vote = vote;

    [self.view addSubview:_loadingView];
    [self.view bringSubviewToFront:_loadingView];


    [self _fetchVoteData:_vote.rollId];
}

#pragma mark - _voteCountTableVC Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *choiceKey = (NSString *)[_voteCountTableVC.dataProvider itemForIndexPath:indexPath];
    NSArray *voter_ids = [_vote voterIdsForChoice:choiceKey];

    if ([voter_ids count] > 0) {
        // Retrieve legislators by ids.
        __weak SFVoteDetailViewController *weakSelf = self;
        _legislatorsTableVC = [[SFLegislatorTableViewController alloc] initWithStyle:UITableViewStylePlain];
        _legislatorsTableVC.dataProvider.sortIntoSectionsBlock = byLastNameSorterBlock;
        _legislatorsTableVC.dataProvider.orderItemsInSectionsBlock = lastNameFirstOrderBlock;
        _legislatorsTableVC.dataProvider.sectionTitleGenerator = lastNameTitlesGenerator;
        __weak SFLegislatorTableViewController *weaklegislatorsTableVC = _legislatorsTableVC;
        [_legislatorsTableVC.tableView sam_scrollToTop];
        _legislatorsTableVC.dataProvider.items = @[];
        [_legislatorsTableVC.tableView reloadData];

        [_legislatorsTableVC.tableView addInfiniteScrollingWithActionHandler: ^{
            NSInteger loc = [weaklegislatorsTableVC.dataProvider.items count];
            NSInteger unretrievedCount = [voter_ids count] - [weaklegislatorsTableVC.dataProvider.items count];
            if (unretrievedCount > 0) {
                NSInteger length = unretrievedCount < 50 ? unretrievedCount : 50;
                NSRange idRange = NSMakeRange(loc, length);
                NSIndexSet *retrievalIndexes = [NSIndexSet indexSetWithIndexesInRange:idRange];
                NSArray *retrievalSet = [voter_ids objectsAtIndexes:retrievalIndexes];
                BOOL didRun = [SAMRateLimit executeBlock: ^{
                        [SFLegislatorService legislatorsWithIds:retrievalSet count:length completionBlock: ^(NSArray *resultsArray) {
                                NSArray *newItems = [resultsArray sortedArrayUsingDescriptors:
                                                     @[
                                                         [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES],
                                                         [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES],
                                                         [NSSortDescriptor sortDescriptorWithKey:@"stateName" ascending:YES]
                                                     ]];
                                weaklegislatorsTableVC.dataProvider.items = [weaklegislatorsTableVC.dataProvider.items arrayByAddingObjectsFromArray:newItems];
                                [weaklegislatorsTableVC sortItemsIntoSectionsAndReload];
                                [weaklegislatorsTableVC.tableView.infiniteScrollingView stopAnimating];
                            }];
                    } name:@"_legislatorsTableVC-InfiniteScroll" limit:1.0f];
                if (!didRun) {
                    [weaklegislatorsTableVC.tableView.infiniteScrollingView stopAnimating];
                }
            }
            else {
                [weaklegislatorsTableVC.tableView.infiniteScrollingView stopAnimating];
            }
        }];
        _legislatorsTableVC.title = [NSString stringWithFormat:@"%@: %@", [weakSelf.vote.voteType capitalizedString], choiceKey];
        [self.navigationController pushViewController:_legislatorsTableVC animated:YES];
        [_legislatorsTableVC.tableView triggerInfiniteScrolling];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *choiceKey = _vote.choices[indexPath.row];
    NSNumber *totalCount = _vote.totals[choiceKey];
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:SFBasicTextCellTransformerName];
    NSNumber *shouldBeSelectable = [NSNumber numberWithBool:([totalCount integerValue] > 0)];
    NSDictionary *dataObj = @{ @"textLabelString": choiceKey, @"detailTextLabelString": [totalCount stringValue], @"selectable": shouldBeSelectable };
    SFCellData *cellData = [transformer transformedValue:dataObj];
    CGFloat cellHeight = [cellData heightForWidth:_voteCountTableVC.tableView.width];
    return cellHeight;
}

#pragma mark - Private

- (void)_initFollowedLegislatorVC {
    _followedLegislatorVC = [[SFLegislatorVoteTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self addChildViewController:_followedLegislatorVC];
    self.voteDetailView.followedVoterTable = _followedLegislatorVC.tableView;
}

- (void)_initVoteTableVC {
    _voteCountTableVC = [[SFDataTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _voteCountTableVC.dataProvider = [SFVoteCountTableDataSource new];
    [self addChildViewController:_voteCountTableVC];
    self.voteDetailView.voteTable = _voteCountTableVC.tableView;
    _voteCountTableVC.tableView.delegate = self;
}

- (void)_fetchVoteData:(NSString *)rollId {
    __weak SFVoteDetailViewController *weakSelf = self;
    [SFRollCallVoteService getVoteWithId:rollId completionBlock: ^(SFRollCallVote *pVote) {
        __strong SFVoteDetailViewController *strongSelf = weakSelf;
        if (pVote) {
            _vote = pVote;
            _voteDetailView.titleLabel.text = _vote.question;
            [_voteDetailView.titleLabel setAccessibilityValue:_vote.question];
            NSDateFormatter *dateFormatter = [SFDateFormatterUtil mediumDateShortTimeFormatter];

            NSAttributedString *preDescriptor = [[NSAttributedString alloc] initWithString:@"Voted on "
                                                                                attributes:@{ NSFontAttributeName: [UIFont subitleFont], NSForegroundColorAttributeName: [UIColor subtitleColor] }];
            NSMutableAttributedString *attributedDateString = [[NSMutableAttributedString alloc] initWithAttributedString:preDescriptor];
            NSAttributedString *dateString = [[NSAttributedString alloc] initWithString:[dateFormatter stringFromDate:_vote.votedAt]
                                                                             attributes:@{ NSFontAttributeName: [UIFont subitleStrongFont] }];
            [attributedDateString appendAttributedString:dateString];
            _voteDetailView.dateLabel.attributedText = attributedDateString;
            [_voteDetailView.dateLabel setAccessibilityValue:[dateFormatter stringFromDate:_vote.votedAt]];

            _voteDetailView.resultLabel.text = [_vote.result capitalizedString];
            [_voteDetailView.resultLabel setAccessibilityValue:[_vote.result capitalizedString]];

            [((SFVoteCountTableDataSource *)_voteCountTableVC.dataProvider)setVote : _vote];
            [_voteCountTableVC reloadTableView];


            self.title = [_vote.voteType capitalizedString];

            [self updateFollowedLegislatorVotes];

            if (_vote.billId == nil) {
                [_voteDetailView.billButton setHidden:YES];
            }
        }
        else {
            [SFMessage showErrorMessageInViewController:strongSelf withMessage:@"Unable to fetch vote details."];
        }
        [_voteDetailView.scrollView setNeedsUpdateConstraints];
        [_voteDetailView setNeedsUpdateConstraints];
        [_loadingView sam_fadeOutAndRemoveFromSuperview];
    }];
}

- (void)updateFollowedLegislatorVotes {
    NSArray *allFollowedLegislators = [SFLegislator allObjectsToPersist];
    NSIndexSet *indexesOfLegislators = [allFollowedLegislators indexesOfObjectsPassingTest: ^BOOL (id obj, NSUInteger idx, BOOL *stop) {
        SFLegislator *legislator = (SFLegislator *)obj;
        BOOL inChamber = [legislator.chamber isEqualToString:_vote.chamber];
        BOOL didVote = [_vote.voterDict objectForKey:legislator.bioguideId] != nil;
        return inChamber && didVote;
    }];
    _followedLegislatorVC.dataProvider.items = [[allFollowedLegislators objectsAtIndexes:indexesOfLegislators] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES]]];
    _followedLegislatorVC.dataProvider.sections = @[_followedLegislatorVC.dataProvider.items];
    [((SFLegislatorVoteTableDataSource *)_followedLegislatorVC.dataProvider)setVote : _vote];

    [_followedLegislatorVC reloadTableView];
    [_voteDetailView.followedVoterLabel setHidden:_followedLegislatorVC.dataProvider.items.count == 0];
}

- (void)navigateToBill {
    if (_vote.billId) {
        if (_vote.bill == nil) {
            [SFBillService billWithId:_vote.billId completionBlock: ^(SFBill *bill) {
                SFBillSegmentedViewController *vc = [[SFBillSegmentedViewController alloc] initWithNibName:nil bundle:nil];
                [vc setBill:bill];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
        else {
            SFBillSegmentedViewController *vc = [[SFBillSegmentedViewController alloc] initWithNibName:nil bundle:nil];
            [vc setBill:_vote.bill];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - Public Methods

- (void)retrieveVoteForId:(NSString *)rollId {
    [self _fetchVoteData:rollId];
}

#pragma mark - UIViewControllerRestoration

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {
    return [SFVoteDetailViewController new];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    NSString *rollId = _vote ? _vote.rollId : _restorationRollId;
    [coder encodeObject:rollId forKey:@"rollId"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    _restorationRollId = [coder decodeObjectForKey:@"rollId"];
}

@end
