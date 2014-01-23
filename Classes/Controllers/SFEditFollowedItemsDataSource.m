//
//  SFEditFollowedItemsDataSource.m
//  Congress
//
//  Created by Daniel Cloud on 11/27/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFEditFollowedItemsDataSource.h"
#import "SFSynchronizedObject.h"

@implementation SFEditFollowedItemsDataSource
// TODO: items proxy for editing table, then committing edits later?
// TODO: figure out updating (see [SFFollowingSectionViewController _updateData])

#pragma mark - SFCellDataSource

- (SFCellData *)cellDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    SFSynchronizedObject *item = (SFSynchronizedObject *)[self itemForIndexPath:indexPath];

    NSString *transformerName = SFBasicTextCellTransformerName;
    id value = item;
    NSString *className = NSStringFromClass([item class]);
    if ([className isEqualToString:@"SFLegislator"]) {
        transformerName = SFDefaultLegislatorCellTransformerName;
    }
    else if ([className isEqualToString:@"SFBill"]) {
        transformerName = SFDefaultBillCellTransformerName;
    }
    else if ([className isEqualToString:@"SFCommittee"]) {
        transformerName = SFDefaultCommitteeCellTransformerName;
    }

    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:transformerName];
    return [transformer transformedValue:value];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self tableView:tableView unfollowObjectsAtIndexPaths:@[indexPath] completion:nil];
    }
}

#pragma mark - SFEditFollowedItemsDataSource
- (void)tableView:(UITableView *)tableView unfollowObjectsAtIndexPaths:(NSArray *)indexPaths completion:(void (^)(BOOL isComplete))completionBlock {
    Class itemClass;
    for (NSIndexPath *indexPath in indexPaths) {
        SFSynchronizedObject *item = [self itemForIndexPath:indexPath];
        [item setFollowed:NO];
        if (!itemClass) {
            itemClass = [item class];
        }
    }
    // ???: This doesn't handle a mixed table of things, cause we'd need a better items setter.
    self.items = [itemClass allObjectsToPersist];
    [self sortItemsIntoSections];
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
    if (completionBlock) {
        completionBlock(YES);
    }
}

@end
