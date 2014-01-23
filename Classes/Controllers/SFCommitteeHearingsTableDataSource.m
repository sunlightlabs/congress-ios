//
//  SFCommitteeHearingsTableDataSource.m
//  Congress
//
//  Created by Daniel Cloud on 11/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteeHearingsTableDataSource.h"
#import "SFHearing.h"

@implementation SFCommitteeHearingsTableDataSource

#pragma mark - SFCellDataSource

- (SFCellData *)cellDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    SFHearing *hearing  = (SFHearing *)[self itemForIndexPath:indexPath];

    if (!hearing) return nil;

    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFCommitteeHearingCellTransformerName];
    return [valueTransformer transformedValue:hearing];
}

@end
