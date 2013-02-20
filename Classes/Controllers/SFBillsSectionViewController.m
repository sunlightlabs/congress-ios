//
//  SFBillListViewController.m
//  Congress
//
//  Created by Daniel Cloud on 11/30/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFBillsSectionViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
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
   }
    return self;
}

-(void)loadView
{
    __billsSectionView.frame = [[UIScreen mainScreen] bounds];
    __billsSectionView.backgroundColor = [UIColor whiteColor];
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
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem settingsButtonWithTarget:self.viewDeckController action:@selector(toggleLeftView)];
    self.navigationItem.backBarButtonItem = [UIBarButtonItem backButton];

    self.viewDeckController.delegate = self;

    // infinite scroll with rate limit.
    __weak SFBillsTableViewController *weakSearchTableVC = __searchTableVC;
    __weak SFBillsSectionViewController *weakSelf = self;

    // set up search table vc
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
                     [weakSearchTableVC.tableView.infiniteScrollingView stopAnimating];
                 }];
            }
        } name:@"__searchTableVC-InfiniteScroll" limit:2.0f];
    }];

    // set up __newBillsTableVC
    __weak SFBillsTableViewController *weakNewBillsTableVC = __newBillsTableVC;
    [__newBillsTableVC.tableView addInfiniteScrollingWithActionHandler:^{
        [SSRateLimit executeBlock:^{
            NSUInteger pageNum = 1 + [weakSelf.billsBrowsed count]/20;
            [SFBillService recentlyIntroducedBillsWithPage:[NSNumber numberWithInt:pageNum] completionBlock:^(NSArray *resultsArray)
            {
                if (resultsArray) {
                    [weakSelf.billsBrowsed addObjectsFromArray:resultsArray];
                    weakNewBillsTableVC.items = weakSelf.billsBrowsed;
                    [weakNewBillsTableVC.tableView reloadData];
                }
                [weakNewBillsTableVC.tableView.infiniteScrollingView stopAnimating];

            }];
        } name:@"__newBillsTableVC-InfiniteScroll" limit:2.0f];
    }];

    // Default initial table should be __browseTableVC
    [self displayViewController:__segmentedVC];
    [__segmentedVC displayViewForSegment:0];
    [__newBillsTableVC.tableView triggerInfiniteScrolling];
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

- (void)setIsUpdating:(BOOL )updating
{
    self->_updating = updating;
}

- (BOOL)isUpdating
{
    return self->_updating;
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

    __newBillsTableVC = [[SFBillsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    __activeBillsTableVC = [[SFBillsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    __segmentedVC = [SFSegmentedViewController segmentedViewControllerWithChildViewControllers:@[__newBillsTableVC,__activeBillsTableVC]
                                                                                        titles:@[@"New", @"Active"]];
    
    self.billsBrowsed = [NSMutableArray arrayWithCapacity:20];
    self.billsSearched = [NSMutableArray arrayWithCapacity:20];

    [self displayViewController:__segmentedVC];
}

@end
