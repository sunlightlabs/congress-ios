//
//  SFDataTableViewController.m
//  Congress
//
//  Created by Daniel Cloud on 2/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFDataTableViewController.h"

@interface SFDataTableViewController ()

@end

@implementation SFDataTableViewController

@synthesize items = _items;
@synthesize sections = _sections;
@synthesize sectionTitles = _sectionTitles;
@synthesize sectionSorter;
@synthesize sectionTitleGenerator;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.items = @[];
        self.sections = nil;
        self.sectionTitles = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (!_sections || [_sections count] == 0) {
        return 1;
    }
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
    if (self.sections && self.sections[section]) {
        return [self.sections[section] count];
    }
    return [self.items count];
}

#pragma mark - SFDataTableViewController

- (void)setSectionTitleGenerator:(SFDataTableSectionTitleGenerator)pSectionTitleGenerator sectionSorter:(SFDataTableSectionSorter)pSectionSorter
{
    self.sectionTitleGenerator = pSectionTitleGenerator;
    self.sectionSorter = pSectionSorter;
}

- (void)reloadTableView
{
    [self.tableView reloadData];
}

- (void)sortItemsIntoSections
{
    if (self.sectionTitleGenerator && self.sectionSorter) {
        self.sectionTitles = sectionTitleGenerator(self.items);

        NSMutableArray *mutableSections = [NSMutableArray arrayWithCapacity:[self.sectionTitles count]];
        for (int i = 0; i < [self.sectionTitles count]; i++) {
            [mutableSections addObject:[NSMutableArray array]];
        }

        for (id item in self.items) {
            NSUInteger sectionNum = self.sectionSorter(item, self.sectionTitles);
            NSMutableArray *section = [mutableSections objectAtIndex:sectionNum];
            [section addObject:item];
        }
        self.sections = [NSArray arrayWithArray:mutableSections];
    }
}

- (void)sortItemsIntoSectionsAndReload
{
    [self sortItemsIntoSections];
    [self reloadTableView];
}

@end
