//
//  SFBillsSectionViewController.m
//  Congress
//
//  Created by Daniel Cloud on 11/30/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFBillsSectionViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "SVPullToRefreshView+Congress.h"
#import "IIViewDeckController.h"
#import "SFSegmentedViewController.h"
#import "SFBillService.h"
#import "SFBill.h"
#import "SFBillsSectionView.h"
#import "SFBillsTableViewController.h"

@interface SFBillsSectionViewController() <IIViewDeckControllerDelegate, UIGestureRecognizerDelegate>
{
    BOOL _updating;
    NSTimer *_searchTimer;
    SFBillsSectionView *__billsSectionView;
    SFBillsTableViewController *__searchTableVC;
    SFSegmentedViewController *__segmentedVC;
    SFBillsTableViewController *__newBillsTableVC;
    SFBillsTableViewController *__activeBillsTableVC;
}

@end

@implementation SFBillsSectionViewController

@synthesize searchBar;
@synthesize currentVC = _currentVC;

- (id)init
{
    self = [super init];

    if (self) {
        [self _initialize];
        self.trackedViewName = @"Bill Section Screen";
   }
    return self;
}

-(void)loadView
{
    __billsSectionView.frame = [[UIScreen mainScreen] bounds];
	self.view = __billsSectionView;
    self.view.userInteractionEnabled = YES;
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    gestureRecognizer.minimumNumberOfTouches = 1;
    gestureRecognizer.maximumNumberOfTouches = 1;
    gestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    self.searchBar = __billsSectionView.searchBar;
    self.searchBar.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // This needs the same buttons as SFMainDeckTableViewController
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem menuButtonWithTarget:self.viewDeckController action:@selector(toggleLeftView)];

    self.viewDeckController.delegate = self;

    // infinite scroll with rate limit.
    __weak SFBillsTableViewController *weakSearchTableVC = __searchTableVC;
    __weak SFBillsSectionViewController *weakSelf = self;

    // set up __searchTableVC infinitescroll
    [__searchTableVC.tableView addInfiniteScrollingWithActionHandler:^{
        NSUInteger pageNum = 1 + [weakSelf.billsSearched count]/20;
        NSNumber *perPage = @20;
        if (pageNum <= 1) {
            [weakSearchTableVC.tableView.infiniteScrollingView stopAnimating];
        }
        [SSRateLimit executeBlock:^{
            if (pageNum > 1) {
                [SFBillService searchBillText:weakSelf.searchBar.text count:perPage page:[NSNumber numberWithInt:pageNum] completionBlock:^(NSArray *resultsArray)
                 {
                     if (resultsArray) {
                         [weakSelf.billsSearched addObjectsFromArray:resultsArray];
                         weakSearchTableVC.items = weakSelf.billsSearched;
                         [weakSearchTableVC.tableView reloadData];
                     }
                     if (([resultsArray count] == 0) || ([resultsArray count] < [perPage integerValue]))
                     {
                         weakSearchTableVC.tableView.infiniteScrollingView.enabled = NO;
                     }
                     [weakSearchTableVC.tableView.pullToRefreshView setLastUpdatedNow];
                     [weakSearchTableVC.tableView.infiniteScrollingView stopAnimating];
                 }];
            }
        } name:@"__searchTableVC-InfiniteScroll" limit:2.0f];
    }];

    // set up __activeBillsTableVC pulltorefresh and infininite scroll
    __weak SFBillsTableViewController *weakActiveBillsTableVC = __activeBillsTableVC;
    [__activeBillsTableVC.tableView addPullToRefreshWithActionHandler:^{
        BOOL didRun = [SSRateLimit executeBlock:^{
            [weakActiveBillsTableVC.tableView.infiniteScrollingView stopAnimating];
            [SFBillService recentlyActedOnBillsWithCompletionBlock:^(NSArray *resultsArray)
             {
                 if (resultsArray) {
                     weakSelf.activeBills = [NSMutableArray arrayWithArray:resultsArray];
                     weakActiveBillsTableVC.items = weakSelf.activeBills;                     
                     [weakActiveBillsTableVC sortItemsIntoSectionsAndReload];
                 }
                 [weakActiveBillsTableVC.tableView.pullToRefreshView stopAnimatingAndSetLastUpdatedNow];

             } excludeNewBills:YES];
        } name:@"__activeBillsTableVC-PullToRefresh" limit:5.0f];
        if (!didRun) {
            [weakActiveBillsTableVC.tableView.pullToRefreshView stopAnimating];
        }
    }];
    [__activeBillsTableVC.tableView addInfiniteScrollingWithActionHandler:^{
        BOOL didRun = [SSRateLimit executeBlock:^{
            NSUInteger pageNum = 1 + [weakSelf.activeBills count]/20;
            [SFBillService recentlyActedOnBillsWithPage:[NSNumber numberWithInt:pageNum] completionBlock:^(NSArray *resultsArray) {
                if (resultsArray) {
                    [weakSelf.activeBills addObjectsFromArray:resultsArray];
                    weakActiveBillsTableVC.items = weakSelf.activeBills;
                    [weakActiveBillsTableVC sortItemsIntoSectionsAndReload];
                }
                [weakActiveBillsTableVC.tableView.infiniteScrollingView stopAnimating];
                [weakActiveBillsTableVC.tableView.pullToRefreshView setLastUpdatedNow];
            } excludeNewBills:YES];
        } name:@"__activeBillsTableVC-InfiniteScroll" limit:2.0f];
        if (!didRun) {
            [weakActiveBillsTableVC.tableView.infiniteScrollingView stopAnimating];
        }
    }];

    // set up __newBillsTableVC pulltorefresh and infininite scroll
    __weak SFBillsTableViewController *weakNewBillsTableVC = __newBillsTableVC;
    [__newBillsTableVC.tableView addPullToRefreshWithActionHandler:^{
        [weakNewBillsTableVC.tableView.infiniteScrollingView stopAnimating];
        BOOL didRun = [SSRateLimit executeBlock:^{
            [SFBillService recentlyIntroducedBillsWithCompletionBlock:^(NSArray *resultsArray)
             {
                 if (resultsArray) {
                     weakSelf.introducedBills = [NSMutableArray arrayWithArray:resultsArray];
                     weakNewBillsTableVC.items = weakSelf.introducedBills;
                     [weakNewBillsTableVC sortItemsIntoSectionsAndReload];
                 }
                 [weakNewBillsTableVC.tableView.pullToRefreshView stopAnimatingAndSetLastUpdatedNow];

             }];
        } name:@"__newBillsTableVC-PullToRefresh" limit:5.0f];
        if (!didRun) {
            [weakNewBillsTableVC.tableView.pullToRefreshView stopAnimating];
        }
    }];
    [__newBillsTableVC.tableView addInfiniteScrollingWithActionHandler:^{
        BOOL didRun = [SSRateLimit executeBlock:^{
            NSUInteger pageNum = 1 + [weakSelf.introducedBills count]/20;
            [SFBillService recentlyIntroducedBillsWithPage:[NSNumber numberWithInt:pageNum] completionBlock:^(NSArray *resultsArray)
             {
                 if (resultsArray) {
                     [weakSelf.introducedBills addObjectsFromArray:resultsArray];
                     weakNewBillsTableVC.items = weakSelf.introducedBills;
                     [weakNewBillsTableVC sortItemsIntoSectionsAndReload];
                 }
                 [weakNewBillsTableVC.tableView.infiniteScrollingView stopAnimating];
                 [weakNewBillsTableVC.tableView.pullToRefreshView setLastUpdatedNow];
             }];
        } name:@"__newBillsTableVC-InfiniteScroll" limit:2.0f];
        if (!didRun) {
            [weakNewBillsTableVC.tableView.infiniteScrollingView stopAnimating];
        }
    }];


    // Default initial table should be __newBillsTableVC
    [self displayViewController:__segmentedVC];
    [__segmentedVC displayViewForSegment:0];
    [__newBillsTableVC.tableView triggerPullToRefresh];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.searchBar resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayViewController:(id)viewController
{
    if (_currentVC) {
        [_currentVC willMoveToParentViewController:nil];
        [_currentVC removeFromParentViewController];
    }
    _currentVC = viewController;
    [self addChildViewController:_currentVC];
    if ([_currentVC isKindOfClass:[SFBillsTableViewController class]]) {
        __billsSectionView.contentView = ((SFBillsTableViewController *)_currentVC).tableView;
    }
    else
    {
        __billsSectionView.contentView = _currentVC.view;
    }
    [_currentVC didMoveToParentViewController:self];
}


#pragma mark - IIViewDeckController delegate

- (void)viewDeckController:(IIViewDeckController *)viewDeckController willOpenViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated {
    [self.searchBar resignFirstResponder];
    if ([self.searchBar.text isEqualToString:@""]) {
        [self resetSearchResults];
        [self displayViewController:__segmentedVC];
    }
}

#pragma mark - Search

- (void)searchAfterDelay
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(handleSearchDelayExpiry:) userInfo:nil repeats:YES];
    _searchTimer = timer;
}

-(void)handleSearchDelayExpiry:(NSTimer*)timer
{
    [self searchAndDisplayResults:searchBar.text];
    [timer invalidate];
    _searchTimer = nil;
}

-(void)searchAndDisplayResults:(NSString *)searchText
{
    [self resetSearchResults];
    [SFBillService searchBillText:searchText completionBlock:^(NSArray *resultsArray) {
        [self.billsSearched addObjectsFromArray:resultsArray];
        __searchTableVC.items = self.billsSearched;
        [__searchTableVC reloadTableView];
        [self.view layoutSubviews];
    }];
}

- (void)dismissSearchKeyboard
{
    [self.searchBar resignFirstResponder];
}

- (void)resetSearchResults
{
    __searchTableVC.items = @[];
    [__searchTableVC.tableView.infiniteScrollingView stopAnimating];
    self.billsSearched = [NSMutableArray arrayWithCapacity:20];
    __searchTableVC.tableView.infiniteScrollingView.enabled = YES;
}

#pragma mark - SearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)pSearchBar
{
    [self searchAndDisplayResults:pSearchBar.text];
    [self dismissSearchKeyboard];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] > 2) {
        if (!_searchTimer || ![_searchTimer isValid]) {
            [self searchAfterDelay];
        }
    }
    else if ([searchText length] == 0)
    {
        [self resetSearchResults];
        [__searchTableVC reloadTableView];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)pSearchBar
{
    [self displayViewController:__searchTableVC];
    if ([pSearchBar.text isEqualToString:@""]) {
        __searchTableVC.items = @[];
        [__searchTableVC reloadTableView];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)pSearchBar
{
    [self dismissSearchKeyboard];
    pSearchBar.text = @"";
    [self resetSearchResults];
    [self displayViewController:__segmentedVC];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)pSearchBar
{
    if ([pSearchBar.text isEqualToString:@""]) {
        [self dismissSearchKeyboard];
    }
}

#pragma mark - Gesture handlers

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    if ([self.searchBar isFirstResponder]) {
        [self dismissSearchKeyboard];
        if ([self.searchBar.text isEqualToString:@""]) {
            [self resetSearchResults];
            [self displayViewController:__segmentedVC];
        }
    }
}

#pragma mark - SegmentedViewController notification handler

-(void)handleSegmentedViewChange:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"SegmentedViewDidChange"]) {
        // Ensure __activeBillsTableVC gets loaded.
        if ([self.activeBills count] == 0 &&[__segmentedVC.currentViewController isEqual:__activeBillsTableVC]) {
            [__activeBillsTableVC.tableView triggerInfiniteScrolling];
        }
    }
}

#pragma mark - Private

-(void)_initialize
{
    self.title = @"Bills";
    self->_updating = NO;
    _searchTimer = nil;
    if (!__billsSectionView) {
        __billsSectionView = [[SFBillsSectionView alloc] initWithFrame:CGRectZero];
        __billsSectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    __searchTableVC = [[SFBillsTableViewController alloc] initWithStyle:UITableViewStylePlain];

    SFDataTableSectionTitleGenerator lastActionAtTitleBlock = ^NSArray*(NSArray *items) {
        NSArray *possibleSectionTitles = [items valueForKeyPath:@"lastActionAt"];
        possibleSectionTitles = [possibleSectionTitles sortedArrayUsingDescriptors:
                                 @[[NSSortDescriptor sortDescriptorWithKey:@"timeIntervalSince1970" ascending:NO]]];
        possibleSectionTitles = [possibleSectionTitles valueForKeyPath:@"stringWithMediumDateOnly"];
        NSOrderedSet *sectionTitlesSet = [NSOrderedSet orderedSetWithArray:possibleSectionTitles];
        return [sectionTitlesSet array];
    };
    SFDataTableSortIntoSectionsBlock lastActionAtSorterBlock = ^NSUInteger(id item, NSArray *sectionTitles) {
        NSString *lastActionAtString = [((SFBill *)item).lastActionAt stringWithMediumDateOnly];
        NSUInteger index = [sectionTitles indexOfObject:lastActionAtString];
        if (index != NSNotFound) {
            return index;
        }
        return 0;
    };
    __newBillsTableVC = [[SFBillsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    // Set up blocks to generate section titles and sort items into sections
    [__newBillsTableVC setSectionTitleGenerator:lastActionAtTitleBlock sortIntoSections:lastActionAtSorterBlock
                           orderItemsInSections:nil cellForIndexPathHandler:nil];
    __activeBillsTableVC = [[SFBillsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    // Set up blocks to generate section titles and sort items into sections
    [__activeBillsTableVC setSectionTitleGenerator:lastActionAtTitleBlock sortIntoSections:lastActionAtSorterBlock
                              orderItemsInSections:nil cellForIndexPathHandler:nil];
    __segmentedVC = [SFSegmentedViewController segmentedViewControllerWithChildViewControllers:@[__newBillsTableVC,__activeBillsTableVC]
                                                                                        titles:@[@"New", @"Active"]];
    
    self.introducedBills = [NSMutableArray arrayWithCapacity:20];
    self.activeBills = [NSMutableArray arrayWithCapacity:20];
    self.billsSearched = [NSMutableArray arrayWithCapacity:20];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSegmentedViewChange:) name:@"SegmentedViewDidChange" object:__segmentedVC];

    [self displayViewController:__segmentedVC];
}

@end
