//
//  SFEditFavoritesTableViewController.m
//  Congress
//
//  Created by Daniel Cloud on 3/12/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFEditFavoritesTableViewController.h"
#import "SFPanopticCell.h"
#import "SFSynchronizedObject.h"

@implementation SFEditFavoritesTableViewController

- (void)viewDidLoad
{
    self.restorationIdentifier = NSStringFromClass(self.class);
    [super viewDidLoad];
    self.tableView.delegate = self;
    [self.tableView setEditing:YES];
}

 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:SFPanopticCell.class]) {
        return ((SFPanopticCell *)cell).cellHeight;
    }
    return 44;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id item = [self.items objectAtIndex:indexPath.row];
        if ([item isKindOfClass:SFSynchronizedObject.class]) {
            ((SFSynchronizedObject *)item).persist = NO;
        }
        NSMutableArray *itemsEdit = [NSMutableArray arrayWithArray:self.items];
        [itemsEdit removeObjectAtIndex:indexPath.row];
        self.items = [NSArray arrayWithArray:itemsEdit];
        self.sections = @[self.items];
        
        NSArray *indexPathArray = [NSArray arrayWithObject:indexPath];
        [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Application state

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {

    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {

    [super decodeRestorableStateWithCoder:coder];
}

@end
