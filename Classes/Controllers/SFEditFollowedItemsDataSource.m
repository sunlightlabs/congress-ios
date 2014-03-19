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
        transformerName = SFBillNoExtraDataCellTransformerName;
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
    NSMutableDictionary *sectionsWithDeletedItems = [[NSMutableDictionary alloc] init];
    
    // Create a dictionary of section titles to section IDs so we can later
    // figure out which ones need to be manually deleted.
    for (NSIndexPath *indexPath in indexPaths) {
        [sectionsWithDeletedItems setValue:[NSNumber numberWithInteger:indexPath.section] forKey:self.sectionTitles[indexPath.section]];
        SFSynchronizedObject *item = [self itemForIndexPath:indexPath];
        [item setFollowed:NO];
        if (!itemClass) {
            itemClass = [item class];
        }
    }
    
    // ???: This doesn't handle a mixed table of things, cause we'd need a better items setter.
    self.items = [itemClass allObjectsToPersist];
    [self sortItemsIntoSections];
    
    // Now that items have been updated, figure out which sections no longer exist.
    NSMutableIndexSet *sectionsToDelete = [NSMutableIndexSet indexSet];
    for (NSString *key in sectionsWithDeletedItems.allKeys) {
        if (![self.sectionTitles containsObject:key]) {
            NSInteger *sectionId = [(NSNumber *)[sectionsWithDeletedItems objectForKey:key] integerValue];
            [sectionsToDelete addIndex:sectionId];
        }
    }
    
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [tableView deleteSections:sectionsToDelete withRowAnimation:UITableViewRowAnimationFade];
    if (self.items == nil || [self.items count] == 0) {
        // -numberOfSectionsInTableView returns 1 if items is empty.
        // We need to insert an empty section to handle that case.
        [tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
    [tableView endUpdates];
    
    if (completionBlock) {
        completionBlock(YES);
    }
}

@end
