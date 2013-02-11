//
//  SFBillListViewController.m
//  Congress
//
//  Created by Daniel Cloud on 11/30/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFBillListViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "IIViewDeckController.h"
#import "SFBillService.h"
#import "SFBill.h"
#import "SFBillListView.h"
#import "SFBillSegmentedViewController.h"

@interface SFBillListViewController() <IIViewDeckControllerDelegate>
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

    // This needs the same buttons as SFMainDeckTableViewController
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem settingsButtonWithTarget:self.viewDeckController action:@selector(toggleLeftView)];
    self.navigationItem.backBarButtonItem = [UIBarButtonItem backButton];

    self.viewDeckController.delegate = self;

    // infinite scroll with rate limit.
    __weak SFBillListViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        BOOL executed = [SSRateLimit executeBlock:^{
            [weakSelf setIsUpdating:YES];
            NSUInteger pageNum = 1 + [weakSelf.billList count]/20;
            [SFBillService recentlyIntroducedBillsWithPage:[NSNumber numberWithInt:pageNum] completionBlock:^(NSArray *resultsArray)
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Manually deselect row. Something is interrupting default deselection.
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:NO];
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

-(void)setIsUpdating:(BOOL )updating
{
    self->_updating = updating;
}

-(BOOL)isUpdating
{
    return self->_updating;
}

#pragma mark - IIViewDeckController delegate

- (void)viewDeckController:(IIViewDeckController *)viewDeckController willOpenViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated {
    [self.searchBar resignFirstResponder];
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
    NSDateFormatter *dateFormatter = nil;
    NSString *dateDescription = @"";
    if (bill.lastActionAt) {
        dateFormatter = [NSDateFormatter mediumDateShortTimeFormatter];
        dateDescription = [NSString stringWithFormat:@"Last Action At: %@", [dateFormatter stringFromDate:bill.lastActionAt] ];
    }
    else if (bill.introducedOn)
    {
        dateFormatter = [NSDateFormatter ISO8601DateOnlyFormatter];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateDescription = [NSString stringWithFormat:@"Introduced on: %@", [dateFormatter stringFromDate:bill.introducedOn] ];
    }
    [[cell detailTextLabel] setText:dateDescription];

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
    else
    {
        self.dataArray = @[];
       [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)pSearchBar
{
    if ([pSearchBar.text isEqualToString:@""]) {
        self.dataArray = @[];
        self.tableView.infiniteScrollingView.enabled = NO;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)pSearchBar
{
    self.dataArray = self.billList;
    [pSearchBar resignFirstResponder];
    pSearchBar.text = @"";
    self.tableView.infiniteScrollingView.enabled = YES;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
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
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
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
