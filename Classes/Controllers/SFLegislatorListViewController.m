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
        _sectionTitles = @[];
        _perPage = @50;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.legislatorList = [NSMutableArray arrayWithCapacity:[_perPage integerValue]];

    __weak SFLegislatorListViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        BOOL executed = [SSRateLimit executeBlock:^{
            [weakSelf setIsUpdating:YES];
            NSUInteger pageNum = 1 + [self.legislatorList count]/[weakSelf.perPage intValue];

            [SFLegislatorService getLegislatorsWithParameters:@{@"page":[NSNumber numberWithInt:pageNum], @"order":@"state__asc,last_name__asc", @"per_page":weakSelf.perPage} success:^(AFJSONRequestOperation *operation, id responseObject) {
                NSMutableArray *newLegislators = (NSMutableArray *)responseObject;
                [weakSelf.legislatorList addObjectsFromArray:newLegislators];

                NSSet *currentTitles = [NSSet setWithArray:[weakSelf.legislatorList valueForKeyPath:@"state_abbr"]];
                weakSelf.sectionTitles = [[currentTitles allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
                NSUInteger sectionTitleCount = [currentTitles count];

                NSMutableArray *mutableSections = [NSMutableArray arrayWithCapacity:sectionTitleCount];
                for (int i = 0; i < sectionTitleCount; i++) {
                    [mutableSections addObject:[NSMutableArray array]];
                }

                for (SFLegislator *object in weakSelf.legislatorList) {
                    NSUInteger index = [weakSelf.sectionTitles indexOfObject:object.state_abbr];
                    [[mutableSections objectAtIndex:index] addObject:object];
                }

                weakSelf.sections = mutableSections;

                [weakSelf.tableView reloadData];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_sectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([_sectionTitles count]) {
        return [_sectionTitles objectAtIndex:section];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.sections objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    // Configure the cell...
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    SFLegislator *leg = (SFLegislator *)[[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [[cell textLabel] setText:leg.titled_name];
    NSString *detailText = @"";
    if (leg.party && ![leg.party isEqualToString:@""]) {
        detailText = [detailText stringByAppendingFormat:@"(%@) ", leg.party];
    }
    detailText = [detailText stringByAppendingString:leg.state_name];
    [[cell detailTextLabel] setText:detailText];

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
