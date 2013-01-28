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
#import "SFBillDetailViewController.h"

@interface SFBillListViewController()
{
    BOOL _updating;
}

@end

@implementation SFBillListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];

    if (self) {
        self.title = @"Bills";
        self->_updating = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.billList = [NSMutableArray arrayWithCapacity:20];

    // infinite scroll with rate limit.
    __weak SFBillListViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        BOOL executed = [SSRateLimit executeBlock:^{
            [weakSelf setIsUpdating:YES];
            NSUInteger pageNum = 1 + [self.billList count]/20;
            [SFBillService recentlyActedOnBillsWithPage:[NSNumber numberWithInt:pageNum] completionBlock:^(NSArray *resultsArray)
            {
                if (resultsArray) {
                    [weakSelf.billList addObjectsFromArray:resultsArray];
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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.billList count];
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
    SFBill *bill = (SFBill *)[self.billList objectAtIndex:row];
    BOOL shortTitleIsNull = [bill.shortTitle isEqual:[NSNull null]] || bill.shortTitle == nil;
    [[cell textLabel] setText:(!shortTitleIsNull ? bill.shortTitle : bill.officialTitle)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [[cell detailTextLabel] setText:[dateFormatter stringFromDate:bill.lastActionAt]];

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFBillDetailViewController *detailViewController = [[SFBillDetailViewController alloc] initWithNibName:nil bundle:nil];
    detailViewController.bill = [self.billList objectAtIndex:[indexPath row]];

    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
