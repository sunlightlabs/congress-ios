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
    SFBillsTableViewController *__browseTableVC;
}

@end

@implementation SFBillsSectionViewController

@synthesize searchBar;
@synthesize currentTableVC = _currentTableVC;

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
    __weak SFBillsTableViewController *weakBrowseTableVC = __browseTableVC;
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
                         weakSearchTableVC.dataArray = weakSelf.billsSearched;
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
    // set up browse table vc
    [__browseTableVC.tableView addInfiniteScrollingWithActionHandler:^{
        [SSRateLimit executeBlock:^{
            NSUInteger pageNum = 1 + [weakSelf.billsBrowsed count]/20;
            [SFBillService recentlyIntroducedBillsWithPage:[NSNumber numberWithInt:pageNum] completionBlock:^(NSArray *resultsArray)
            {
                if (resultsArray) {
                    [weakSelf.billsBrowsed addObjectsFromArray:resultsArray];
                    weakBrowseTableVC.dataArray = weakSelf.billsBrowsed;
                    [weakBrowseTableVC.tableView reloadData];
                }
                [weakBrowseTableVC.tableView.infiniteScrollingView stopAnimating];

            }];
        } name:@"__browseTableVC-InfiniteScroll" limit:2.0f];
    }];

    // Default initial table should be __browseTableVC
    [self displayTableForViewController:__browseTableVC];
    [_currentTableVC.tableView triggerInfiniteScrolling];
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

- (void)displayTableForViewController:(id)viewController
{
    if (_currentTableVC) {
        [_currentTableVC willMoveToParentViewController:nil];
        [_currentTableVC removeFromParentViewController];
    }
    _currentTableVC = viewController;
    [self addChildViewController:_currentTableVC];
    __billsSectionView.tableView = _currentTableVC.tableView;
    [_currentTableVC didMoveToParentViewController:self];
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
        __searchTableVC.dataArray = self.billsSearched;
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
    __searchTableVC.dataArray = @[];
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
        [_currentTableVC reloadTableView];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)pSearchBar
{
    [self displayTableForViewController:__searchTableVC];
    if ([pSearchBar.text isEqualToString:@""]) {
        _currentTableVC.dataArray = @[];
        [_currentTableVC reloadTableView];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)pSearchBar
{
    [self dismissSearchKeyboard];
    pSearchBar.text = @"";
    [self resetSearchResults];
    [self displayTableForViewController:__browseTableVC];
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
    if (!__browseTableVC) {
        __browseTableVC = [[SFBillsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    if (!__searchTableVC) {
        __searchTableVC = [[SFBillsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    self.currentTableVC = __browseTableVC;
    self.billsBrowsed = [NSMutableArray arrayWithCapacity:20];
    self.billsSearched = [NSMutableArray arrayWithCapacity:20];
}

@end
