//
//  SFCommitteeMembersTableDataSource.m
//  Congress
//
//  Created by Daniel Cloud on 11/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteeMembersTableDataSource.h"
#import "SFCommittee.h"

@implementation SFCommitteeMembersTableDataSource

#pragma mark - SFCellDataSource

- (SFCellData *)cellDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    SFCommitteeMember *member = (SFCommitteeMember *)[self itemForIndexPath:indexPath];
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:SFCommitteeMemberCellTransformerName];
    return [transformer transformedValue:member];
}

@end
