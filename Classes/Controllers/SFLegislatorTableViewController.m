//
//  SFLegislatorTableViewController.m
//  Congress
//
//  Created by Daniel Cloud on 1/29/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorTableViewController.h"
#import "SFLegislator.h"
#import "SFLegislatorDetailViewController.h"
#import "SFLegislatorCell.h"
#import "GAI.h"

@implementation SFLegislatorTableViewController

- (void)viewDidLoad
{
    self.restorationIdentifier = NSStringFromClass(self.class);
    self.tableView.delegate = self;
    [self.tableView registerClass:SFLegislatorCell.class forCellReuseIdentifier:@"SFLegislatorCell"];
    [super viewDidLoad];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Legislator List Screen"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFLegislatorCell *cell;
    if (self.cellForIndexPathHandler) {
        cell =  self.cellForIndexPathHandler(indexPath);
    }
    else
    {
        static NSString *CellIdentifier = @"SFLegislatorCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        // Configure the cell...
        if(!cell) {
            cell = [[SFLegislatorCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }

        SFLegislator *leg = (SFLegislator *)[[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.legislator = leg;
    }
    [cell setFrame:CGRectMake(0, cell.top, cell.width, cell.cellHeight)];

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
