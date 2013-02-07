//
//  SFFavoritesListViewController.m
//  Congress
//
//  Created by Daniel Cloud on 2/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFFavoritesListViewController.h"
#import "SFBill.h"
#import "SFLegislator.h"
#import "SFBillSegmentedViewController.h"
#import "SFLegislatorDetailViewController.h"

@implementation SFFavoritesListViewController

@synthesize dataArray = _dataArray;
@synthesize sections = _sections;

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
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self _updateData];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_sections) {
        return 0;
    }
    return [_sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_sections) {
        return [_dataArray count];
    }
    return [[_sections objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    id object = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormatter = [NSDateFormatter mediumDateShortTimeFormatter];

    if ([object isKindOfClass:[SFBill class]]) {
        SFBill *bill = object;
        BOOL shortTitleIsNull = [bill.shortTitle isEqual:[NSNull null]] || bill.shortTitle == nil;
        [[cell textLabel] setText:(!shortTitleIsNull ? bill.shortTitle : bill.officialTitle)];
        cell.detailTextLabel.text = [dateFormatter stringFromDate:bill.lastActionAt];
    }
    else if ([object isKindOfClass:[SFLegislator class]]) {
        SFLegislator *legislator = object;
        cell.textLabel.text = legislator.titledName;
        cell.detailTextLabel.text = legislator.fullDescription;
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id selectedObject = [self.dataArray objectAtIndex:[indexPath row]];
    if ([selectedObject isKindOfClass:[SFBill class]])
    {
        SFBillSegmentedViewController *detailViewController = [[SFBillSegmentedViewController alloc] initWithNibName:nil bundle:nil];
        detailViewController.bill = (SFBill *)selectedObject;

        [self.navigationController pushViewController:detailViewController animated:YES];

    }
    else if ([selectedObject isKindOfClass:[SFLegislator class]])
    {
        SFLegislatorDetailViewController *detailViewController = [[SFLegislatorDetailViewController alloc] initWithNibName:nil bundle:nil];
        detailViewController.legislator = (SFLegislator *)selectedObject;

        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

#pragma mark - Private

- (void)_initialize
{
    self.title = @"Following";

    _dataArray = nil;
    _sections = nil;

}

- (void)_updateData
{
    _dataArray = [[SFBill allObjectsToPersist] arrayByAddingObjectsFromArray:[SFLegislator allObjectsToPersist]];
    _sections = @[_dataArray];
}

@end
