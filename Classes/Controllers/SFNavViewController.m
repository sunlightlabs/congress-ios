//
//  SFNavViewController.m
//  Congress
//
//  Created by Daniel Cloud on 11/29/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//
// TODO: replace navList identifiers with real ones.

#import "SFNavViewController.h"
#import "IIViewDeckController.h"
#import "SFActivityListViewController.h"
#import "SFLegislatorListViewController.h"
#import "SFNavTableCell.h"

@implementation SFNavViewController

- (id)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    self.navList = @[@"All Activity", @"Legislators", @"Bills", @"Settings"];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.view.backgroundColor = [UIColor colorWithRed:0.156 green:0.202 blue:0.270 alpha:1.000];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.navList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SFNavTableCell";
    SFNavTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if(!cell) {
        cell = [[SFNavTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    NSUInteger row = [indexPath row];
    [[cell textLabel] setText:[self.navList objectAtIndex:row]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Nav selected");
    [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller) {
        NSString *navOptionName = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        NSLog(@"Cell selected: %@", navOptionName);
        NSLog(@"Cell section: %i", indexPath.section);
        NSLog(@"Cell row: %i", indexPath.row);
        NSLog(@"Cell selected: %i", [indexPath indexAtPosition:0]);
        UIViewController *presentableViewController = nil;
        switch (indexPath.row) {
            case 0:
                presentableViewController = [[SFActivityListViewController alloc] init];
                break;

            case 1:
                presentableViewController = [[SFLegislatorListViewController alloc] init];
                break;

            default:
                break;
        }
        self.viewDeckController.centerController = [[UINavigationController alloc] initWithRootViewController:presentableViewController];

    }];
}

@end
