//
//  SFLegislatorListViewController.m
//  Congress
//
//  Created by Daniel Cloud on 1/29/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorListViewController.h"
#import "SFLegislator.h"
#import "SFLegislatorDetailViewController.h"
#import "SFLegislatorCell.h"

@implementation SFLegislatorListViewController

- (void)viewDidLoad
{
    self.tableView.delegate = self;
    [self.tableView registerClass:SFLegislatorCell.class forCellReuseIdentifier:@"SFLegislatorCell"];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SFLegislatorCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    // Configure the cell...
    if(!cell) {
        cell = [[SFLegislatorCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    SFLegislator *leg = (SFLegislator *)[[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.legislator = leg;


    return cell;
}


-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableOrderedSet *indices = [NSMutableOrderedSet orderedSet];

    for (NSString *sectionTitle in self.sectionTitles) {
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


#pragma mark - Methods

- (void)setUpSectionsUsingSectionTitlePredicate:(NSPredicate *)predicate
{
    NSUInteger numSections = [self.sectionTitles count];
    NSMutableArray *mutableSections = [NSMutableArray arrayWithCapacity:numSections];
    for (int i = 0; i < numSections; i++) {
        NSArray *sectionLegislators = [self.items filteredArrayUsingPredicate:[predicate predicateWithSubstitutionVariables:@{ @"sectionTitle": self.sectionTitles[i]}]];
        NSArray *sortedSectionLegislators = [sectionLegislators sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]]];
        [mutableSections addObject:sortedSectionLegislators];
    }
    self.sections = mutableSections;

    [self.tableView reloadData];
}

@end
