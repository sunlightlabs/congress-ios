//
//  SFCommitteesTableDataSource.m
//  Congress
//
//  Created by Daniel Cloud on 11/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteesTableDataSource.h"
#import "SFCommittee.h"

@implementation SFCommitteesTableDataSource

#pragma mark - SFCellDataSource

- (SFCellData *)cellDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    SFCommittee *committee  = (SFCommittee *)[self itemForIndexPath:indexPath];

    if (!committee) return nil;

    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultCommitteeCellTransformerName];
    return [valueTransformer transformedValue:committee];
}

@end
