//
//  SFBillListViewController.m
//  Congress
//
//  Created by Daniel Cloud on 11/30/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFBillListViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "SFBillService.h"
#import "SFBill.h"
#import "SFBillListView.h"
#import "SFBillSegmentedViewController.h"

@interface SFBillListViewController()
{
    BOOL _updating;
}

@end

@implementation SFBillListViewController

@synthesize searchBar;

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
    _billListView.frame = [[UIScreen mainScreen] bounds];
    _billListView.backgroundColor = [UIColor whiteColor];
	self.view = _billListView;
    
    self.tableView = _billListView.tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.searchBar = _billListView.searchBar;
    self.searchBar.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // infinite scroll with rate limit.
    __weak SFBillListViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        BOOL executed = [SSRateLimit executeBlock:^{
            [weakSelf setIsUpdating:YES];
            NSUInteger pageNum = 1 + [weakSelf.billList count]/20;
            [SFBillService recentlyActedOnBillsWithPage:[NSNumber numberWithInt:pageNum] completionBlock:^(NSArray *resultsArray)
            {
                if (resultsArray) {
                    [weakSelf.billList addObjectsFromArray:resultsArray];
                    weakSelf.dataArray = weakSelf.billList;
                    [weakSelf.tableView reloadData];
                }
                [weakSelf.tableView.infiniteScrollingView stopAnimating];
                [weakSelf setIsUpdating:NO];

            }];
        } name:@"SFBillListViewController-InfiniteScroll" limit:2.0f];

        if (!executed & ![weakSelf isUpdating]) {
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        }

    }];

    [self.tableView triggerInfiniteScrolling];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setIsUpdating:(BOOL )updating
{
    self->_updating = updating;
}

-(BOOL)isUpdating
{
    return self->_updating;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    NSUInteger row = [indexPath row];
    SFBill *bill = (SFBill *)[self.dataArray objectAtIndex:row];
    BOOL shortTitleIsNull = [bill.shortTitle isEqual:[NSNull null]] || bill.shortTitle == nil;
    [[cell textLabel] setText:(!shortTitleIsNull ? bill.shortTitle : bill.officialTitle)];
    NSDateFormatter *dateFormatter = [NSDateFormatter mediumDateShortTimeFormatter];
    [[cell detailTextLabel] setText:[dateFormatter stringFromDate:bill.lastActionAt]];

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFBillSegmentedViewController *detailViewController = [[SFBillSegmentedViewController alloc] initWithNibName:nil bundle:nil];
    detailViewController.bill = [self.dataArray objectAtIndex:[indexPath row]];

    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - SearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)pSearchBar
{
    [self searchAndDisplayResults:pSearchBar.text];
    [self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] > 2) {
        [self searchAndDisplayResults:searchText];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)pSearchBar
{
    if ([pSearchBar.text isEqualToString:@""]) {
        self.dataArray = @[];
        self.tableView.infiniteScrollingView.enabled = NO;
        [self.tableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)pSearchBar
{
    self.dataArray = self.billList;
    [self.tableView reloadData];
    [pSearchBar resignFirstResponder];
    pSearchBar.text = @"";
    self.tableView.infiniteScrollingView.enabled = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)pSearchBar
{
    if ([pSearchBar.text isEqualToString:@""]) {
        [pSearchBar resignFirstResponder];
    }
}

-(void)searchAndDisplayResults:(NSString *)searchText
{
    [SFBillService searchBillText:searchText completionBlock:^(NSArray *resultsArray) {
        NSArray *searchResults = resultsArray;
        self.dataArray = searchResults;
        self.tableView.infiniteScrollingView.enabled = NO;
        [self.tableView reloadData];
    }];
}

#pragma mark - Private

-(void)_initialize
{
    self.title = @"Bills";
    self->_updating = NO;
    if (!_billListView) {
        _billListView = [[SFBillListView alloc] initWithFrame:CGRectZero];
        _billListView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    self.dataArray = @[];
    self.billList = [NSMutableArray arrayWithCapacity:20];
}

@end
