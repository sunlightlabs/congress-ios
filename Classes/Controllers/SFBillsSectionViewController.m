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
#import "SFSearchBillsTableViewController.h"
#import "SFDateFormatterUtil.h"

@interface SFBillsSectionViewController() <IIViewDeckControllerDelegate, UIGestureRecognizerDelegate, UIViewControllerRestoration>
{
    BOOL _updating;
    NSTimer *_searchTimer;
    SFBillsSectionView *_billsSectionView;
    SFBillsTableViewController *__searchTableVC;
    SFSegmentedViewController *__segmentedVC;
    SFBillsTableViewController *__newBillsTableVC;
    SFBillsTableViewController *__activeBillsTableVC;
}

@end

@implementation SFBillsSectionViewController

static NSString * const NewBillsTableVC = @"NewBillsTableVC";
static NSString * const ActiveBillsTableVC = @"ActiveBillsTableVC";
static NSString * const SearchBillsTableVC = @"SearchBillsTableVC";

@synthesize searchBar;
@synthesize currentVC = _currentVC;

- (id)init
{
    self = [super init];

    if (self) {
        [self _initialize];
        self.trackedViewName = @"Bill Section Screen";
        self.restorationIdentifier = NSStringFromClass(self.class);
   }
    return self;
}

-(void)loadView
{
    _billsSectionView.frame = [[UIScreen mainScreen] bounds];
	self.view = _billsSectionView;
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleOverlayTouch:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    tapRecognizer.delegate = self;
    [_billsSectionView.overlayView addGestureRecognizer:tapRecognizer];
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleOverlayTouch:)];
    panRecognizer.maximumNumberOfTouches = 1;
    panRecognizer.minimumNumberOfTouches = 1;
    panRecognizer.delegate = self;
    [_billsSectionView.overlayView addGestureRecognizer:panRecognizer];

    self.searchBar = _billsSectionView.searchBar;
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
    [__newBillsTableVC.tableView.pullToRefreshView setSubtitle:@"New Bills" forState:SVPullToRefreshStateAll];
    [__activeBillsTableVC.tableView.pullToRefreshView setSubtitle:@"Active Bills" forState:SVPullToRefreshStateAll];

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
        _billsSectionView.contentView = ((SFBillsTableViewController *)_currentVC).tableView;
    }
    else
    {
        _billsSectionView.contentView = _currentVC.view;
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
    if (![__searchTableVC isBeingDismissed] && [__searchTableVC.parentViewController isEqual:self]) {
        [self searchAndDisplayResults:searchBar.text];
    }
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
        [self setOverlayVisible:!([__searchTableVC.items count] > 0) animated:YES];
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
        [self setOverlayVisible:YES animated:YES];
        [__searchTableVC reloadTableView];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)pSearchBar
{
//    [pSearchBar setShowsCancelButton:YES animated:YES];
    [self displayViewController:__searchTableVC];
    if ([pSearchBar.text isEqualToString:@""]) {
        __searchTableVC.items = @[];
        [__searchTableVC reloadTableView];
        [self setOverlayVisible:YES animated:YES];
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
//        [pSearchBar setShowsCancelButton:NO animated:YES];
    }
}

#pragma mark - Gesture handlers

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)handleOverlayTouch:(UIPanGestureRecognizer *)recognizer
{
    if ([self.searchBar isFirstResponder]) {
        [self dismissSearchKeyboard];
        if ([self.searchBar.text isEqualToString:@""])
        {
            [self resetSearchResults];
        }
        else{
            self.searchBar.text = @"";
        }
        [self displayViewController:__segmentedVC];
        [self setOverlayVisible:NO animated:YES];
    }
}

#pragma mark - SegmentedViewController notification handler

-(void)handleSegmentedViewChange:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"SegmentedViewDidChange"]) {
        // Ensure __activeBillsTableVC gets loaded.
        if ([self.activeBills count] == 0 &&[__segmentedVC.currentViewController isEqual:__activeBillsTableVC]) {
            [__activeBillsTableVC.tableView triggerPullToRefresh];
        }
    }
}

#pragma mark - SFBillSectionViewController


- (void)setOverlayVisible:(BOOL)visible animated:(BOOL)animated
{
    CGFloat visibleAlpha = 0.7f;
    if (visible)
    {
        if (animated && (_billsSectionView.overlayView.alpha != visibleAlpha) ) {
            _billsSectionView.overlayView.alpha = 0.0f;
            _billsSectionView.overlayView.hidden = NO;
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                _billsSectionView.overlayView.alpha = visibleAlpha;
            } completion:^(BOOL finished) {}];
        }
        else
        {
            _billsSectionView.overlayView.hidden = NO;
        }

    }
    else
    {
        if (animated) {
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                _billsSectionView.overlayView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                _billsSectionView.overlayView.hidden = YES;
            }];
        }
        else
        {
            _billsSectionView.overlayView.hidden = YES;
        }
    }
}

#pragma mark - Private

-(void)_initialize
{
    self.title = @"Bills";
    self->_updating = NO;
    _searchTimer = nil;
    if (!_billsSectionView) {
        _billsSectionView = [[SFBillsSectionView alloc] initWithFrame:CGRectZero];
        _billsSectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    __searchTableVC = [[self class] newSearchBillsTableViewController];
    
    SFDataTableSectionTitleGenerator lastActionAtTitleBlock = ^NSArray*(NSArray *items) {
        NSArray *possibleSectionTitleValues = [items valueForKeyPath:@"lastActionAt"];
        possibleSectionTitleValues = [possibleSectionTitleValues sortedArrayUsingDescriptors:
                                 @[[NSSortDescriptor sortDescriptorWithKey:@"timeIntervalSince1970" ascending:NO]]];
        NSMutableArray *sectionTitleStrings = [NSMutableArray array];
        NSDateFormatter *dateFormatter = [SFDateFormatterUtil mediumDateNoTimeFormatter];
        for (NSDate *date in possibleSectionTitleValues) {
            [sectionTitleStrings addObject:[dateFormatter stringFromDate:date]];
        }
        NSOrderedSet *sectionTitlesSet = [NSOrderedSet orderedSetWithArray:sectionTitleStrings];
        return [sectionTitlesSet array];
    };
    SFDataTableSortIntoSectionsBlock lastActionAtSorterBlock = ^NSUInteger(id item, NSArray *sectionTitles) {
        NSDateFormatter *dateFormatter = [SFDateFormatterUtil mediumDateNoTimeFormatter];
        NSString *lastActionAtString = [dateFormatter stringFromDate:((SFBill *)item).lastActionAt];
        NSUInteger index = [sectionTitles indexOfObject:lastActionAtString];
        if (index != NSNotFound) {
            return index;
        }
        return 0;
    };
    __newBillsTableVC = [[self class] newNewBillsTableViewController];
    // Set up blocks to generate section titles and sort items into sections
    [__newBillsTableVC setSectionTitleGenerator:lastActionAtTitleBlock sortIntoSections:lastActionAtSorterBlock
                           orderItemsInSections:nil cellForIndexPathHandler:nil];
    __activeBillsTableVC = [[self class] newActiveBillsTableViewController];
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


+ (SFBillsTableViewController *)_newBillsTableVC
{
    SFBillsTableViewController *vc = [[SFBillsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.restorationClass = [self class];
    return vc;
}

+ (SFBillsTableViewController *)newNewBillsTableViewController
{
    SFBillsTableViewController *vc = [[self class] _newBillsTableVC];
    vc.restorationIdentifier = NewBillsTableVC;
    return vc;
}

+ (SFBillsTableViewController *)newActiveBillsTableViewController
{
    SFBillsTableViewController *vc = [[self class] _newBillsTableVC];
    vc.restorationIdentifier = ActiveBillsTableVC;
    return vc;
}

+ (SFSearchBillsTableViewController *)newSearchBillsTableViewController
{
    SFSearchBillsTableViewController *vc = [[SFSearchBillsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.restorationIdentifier = SearchBillsTableVC;
    return vc;
}


#pragma mark - Application state

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    if (__newBillsTableVC.restorationIdentifier) {
        [coder encodeObject:__newBillsTableVC forKey:__newBillsTableVC.restorationIdentifier];
    }
    if (__activeBillsTableVC.restorationIdentifier) {
        [coder encodeObject:__activeBillsTableVC forKey:__activeBillsTableVC.restorationIdentifier];
    }
    if (__searchTableVC.restorationIdentifier) {
        [coder encodeObject:__searchTableVC forKey:__searchTableVC.restorationIdentifier];
    }
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {

    [super decodeRestorableStateWithCoder:coder];
}

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    NSString *lastObjectName = [identifierComponents lastObject];
    
    if ([lastObjectName isEqualToString:NewBillsTableVC]) {
        return [[self class] newNewBillsTableViewController];
    }
    if ([lastObjectName isEqualToString:ActiveBillsTableVC]) {
        return [[self class] newActiveBillsTableViewController];
    }
    if ([lastObjectName isEqualToString:SearchBillsTableVC]) {
        return [[self class] newSearchBillsTableViewController];
    }

    return nil;
}

@end
