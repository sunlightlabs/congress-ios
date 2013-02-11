//
//  SFLegislatorListViewController.m
//  Congress
//
//  Created by Daniel Cloud on 1/29/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorListViewController.h"
#import "SFLegislator.h"

@implementation SFLegislatorListViewController

@synthesize legislatorList = _legislatorList;
@synthesize sections = _sections;
@synthesize sectionTitles = _sectionTitles;

- (id)init
{
    self = [super init];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_sections count];
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
    [[cell detailTextLabel] setText:leg.fullDescription];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

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

#pragma mark - Methods

- (void)setUpSectionsUsingSectionTitlePredicate:(NSPredicate *)predicate
{
    NSUInteger numSections = [_sectionTitles count];
    NSMutableArray *mutableSections = [NSMutableArray arrayWithCapacity:numSections];
    for (int i = 0; i < numSections; i++) {
        NSArray *sectionLegislators = [_legislatorList filteredArrayUsingPredicate:[predicate predicateWithSubstitutionVariables:@{ @"sectionTitle": _sectionTitles[i]}]];
        [mutableSections addObject:sectionLegislators];
    }
    _sections = mutableSections;

    [self.tableView reloadData];
}

#pragma mark - Private

-(void)_initialize
{
    _sectionTitles = @[];
    self.tableView.delegate = self;
}

@end
