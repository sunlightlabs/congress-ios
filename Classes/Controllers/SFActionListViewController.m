//
//  SFActionListViewController.m
//  Congress
//
//  Created by Daniel Cloud on 1/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFActionListViewController.h"
#import "SFBillAction.h"

@interface SFActionListViewController ()

@end

@implementation SFActionListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    
    SFBillAction *object = (SFBillAction *)[[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = object.text;
    NSDateFormatter *dateFormatter = [NSDateFormatter mediumDateShortTimeFormatter];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:object.actedAt];

    return cell;
}

#pragma mark - Accessor methods

-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self sortDataIntoSections];
    [self.tableView reloadData];
}


#pragma mark - Private

-(void)_initialize
{
    _sectionTitles = @[];
    _sections = @[];
    self.tableView.delegate = self;
}

-(void)sortDataIntoSections
{
    _sections = @[_dataArray];
}

@end
