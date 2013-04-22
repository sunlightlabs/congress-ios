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
#import "SFPanopticCell.h"
#import "SFCellData.h"
#import "GAI.h"

@implementation SFLegislatorTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
    }
    return self;
}

- (void)viewDidLoad
{
    self.tableView.delegate = self;
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
    if (indexPath == nil) return nil;

    SFLegislator *legislator = (SFLegislator *)[self itemForIndexPath:indexPath];
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:SFDefaultLegislatorCellTransformerName];
    SFCellData *cellData = [transformer transformedValue:legislator];

    SFPanopticCell *cell;
    if (self.cellForIndexPathHandler) {
        cell =  self.cellForIndexPathHandler(indexPath);
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cell.cellIdentifier];

        // Configure the cell...
        if(!cell) {
            cell = [[SFPanopticCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell.cellIdentifier];
        }
    }
    
    [cell setCellData:cellData];
    if (cellData.persist && [cell respondsToSelector:@selector(setPersistStyle)]) {
        [cell performSelector:@selector(setPersistStyle)];
    }
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    [cell setFrame:CGRectMake(0, 0, cell.width, cellHeight)];

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
    SFLegislator *legislator = (SFLegislator *)[self itemForIndexPath:indexPath];
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:SFDefaultLegislatorCellTransformerName];
    SFCellData *cellData = [transformer transformedValue:legislator];
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return cellHeight;
}

#pragma mark - UIViewControllerRestoration

+ (UIViewController*)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[SFLegislatorTableViewController alloc] initWithNibName:nil bundle:nil];
}

@end
