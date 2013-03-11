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
    if (self.cellForIndexPathHandler) {
        return self.cellForIndexPathHandler(indexPath);
    }
    static NSString *CellIdentifier = @"SFLegislatorCell";
    SFLegislatorCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    // Configure the cell...
    if(!cell) {
        cell = [[SFLegislatorCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    else
    {
        [cell prepareForReuse];
    }

    SFLegislator *leg = (SFLegislator *)[[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.legislator = leg;


    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFLegislatorDetailViewController *detailViewController = [[SFLegislatorDetailViewController alloc] initWithNibName:nil bundle:nil];
    detailViewController.legislator = (SFLegislator *)[[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return ((SFLegislatorCell *)cell).cellHeight;
}

@end
