//
//  SFLegislatorListViewController.m
//  Congress
//
//  Created by Daniel Cloud on 12/5/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorListViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "SFLegislatorService.h"
#import "SFLegislator.h"
#import "SFLegislatorDetailViewController.h"

@interface SFLegislatorListViewController ()
{
    BOOL _updating;
}

@end

@implementation SFLegislatorListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Legislators";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.legislatorList = [NSMutableArray arrayWithCapacity:20];

//    Test thing.
    __weak SFLegislatorListViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        BOOL executed = [SSRateLimit executeBlock:^{
            [weakSelf setIsUpdating:YES];
            NSUInteger pageNum = 1 + [self.legislatorList count]/20;

            [SFLegislatorService getLegislatorsWithParameters:@{@"page":[NSNumber numberWithInt:pageNum]} success:^(AFJSONRequestOperation *operation, id responseObject) {
                NSMutableArray *legislatorsSet = (NSMutableArray *)responseObject;
                NSUInteger offset = [self.legislatorList count];
                [weakSelf.legislatorList addObjectsFromArray:legislatorsSet];
                NSMutableArray *indexPaths = [NSMutableArray new];
                for (NSUInteger i = offset; i < [weakSelf.legislatorList count]; i++) {
                    [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                [weakSelf.tableView beginUpdates];
                [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                [weakSelf.tableView endUpdates];
                [weakSelf.tableView.infiniteScrollingView stopAnimating];
                [weakSelf setIsUpdating:NO];

            } failure:^(AFJSONRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@", error.localizedDescription);
                [weakSelf.tableView.infiniteScrollingView stopAnimating];
                [weakSelf setIsUpdating:NO];
            }];
        } name:@"SFlegislatorListViewController-InfiniteScroll" limit:2.0f];

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

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.legislatorList count];
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
    SFLegislator *leg = (SFLegislator *)[self.legislatorList objectAtIndex:row];
    [[cell textLabel] setText:leg.name];
    [[cell detailTextLabel] setText:leg.state_name];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFLegislatorDetailViewController *detailViewController = [[SFLegislatorDetailViewController alloc] initWithNibName:nil bundle:nil];
    detailViewController.legislator = [self.legislatorList objectAtIndex:[indexPath row]];

    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
