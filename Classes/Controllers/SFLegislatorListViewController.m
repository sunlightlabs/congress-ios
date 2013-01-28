//
//  SFLegislatorListViewController.m
//  Congress
//
//  Created by Daniel Cloud on 12/5/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorListViewController.h"
#import "UIScrollView+SVPullToRefresh.h"
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
    [self.tableView addPullToRefreshWithActionHandler:^{
        [SFLegislatorService getAllLegislatorsInOfficeWithCompletionBlock:^(NSArray *resultsArray) {
            if (resultsArray) {
                weakSelf.legislatorList = [NSMutableArray arrayWithArray:resultsArray];

                NSSet *currentTitles = [[NSSet setWithArray:[weakSelf.legislatorList valueForKeyPath:@"stateName"]] objectsPassingTest:^BOOL(id obj, BOOL *stop) {
                    if (obj == nil) {
                        *stop = YES;
                        return false;
                    }
                    return true;
                }];
                weakSelf.sectionTitles = [[currentTitles allObjects] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
                NSUInteger sectionTitleCount = [currentTitles count];

                NSMutableArray *mutableSections = [NSMutableArray arrayWithCapacity:sectionTitleCount];
                for (int i = 0; i < sectionTitleCount; i++) {
                    [mutableSections addObject:[NSMutableArray array]];
                }

                for (SFLegislator *object in weakSelf.legislatorList) {
                    NSUInteger index = [weakSelf.sectionTitles indexOfObject:[object valueForKeyPath:@"stateName"]];
                    [[mutableSections objectAtIndex:index] addObject:object];
                }
                
                weakSelf.sections = mutableSections;
                [weakSelf.tableView reloadData];
            }
            [weakSelf.tableView.pullToRefreshView stopAnimating];
        }];

    }];

    [self.tableView triggerPullToRefresh];
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
    [[cell textLabel] setText:leg.titledByLastName];
    NSString *detailText = @"";
    if (leg.party && ![leg.party isEqualToString:@""]) {
        detailText = [detailText stringByAppendingFormat:@"(%@) ", leg.party];
    }
    detailText = [detailText stringByAppendingString:leg.stateName];
    if (leg.district) {
        detailText = [detailText stringByAppendingFormat:@" - District %@", leg.district];
    }
    [[cell detailTextLabel] setText:detailText];

    return cell;
}


-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableOrderedSet *indices = [NSMutableOrderedSet orderedSet];

    for (NSString *sectionTitle in self->_sectionTitles) {
        [indices addObject:[sectionTitle substringToIndex:1]];
    }

    return [indices array];
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSPredicate *alphaPredicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@", [title substringToIndex:1]];
    NSArray *filteredTitles = [self.sectionTitles filteredArrayUsingPredicate:alphaPredicate];
    NSInteger position = (NSInteger)[self.sectionTitles indexOfObject:[filteredTitles firstObject]];
    return position;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFLegislatorDetailViewController *detailViewController = [[SFLegislatorDetailViewController alloc] initWithNibName:nil bundle:nil];
    detailViewController.legislator = (SFLegislator *)[[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
