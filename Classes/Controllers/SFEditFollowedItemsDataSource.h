//
//  SFEditFollowedItemsDataSource.h
//  Congress
//
//  Created by Daniel Cloud on 11/27/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFDataTableDataSource.h"

@interface SFEditFollowedItemsDataSource : SFDataTableDataSource <SFCellDataSource>

- (void)tableView:(UITableView *)tableView unfollowObjectsAtIndexPaths:(NSArray *)indexPaths completion:(void (^) (BOOL isComplete))completionBlock;

@end
