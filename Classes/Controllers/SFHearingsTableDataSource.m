//
//  SFHearingsTableDataSource.m
//  Congress
//
//  Created by Daniel Cloud on 11/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFHearingsTableDataSource.h"
#import "SFHearing.h"

@implementation SFHearingsTableDataSource

#pragma mark - SFCellDataSource

- (SFCellData *)cellDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    SFHearing *hearing  = (SFHearing *)[self itemForIndexPath:indexPath];
    if (!hearing) return nil;

    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultHearingCellTransformerName];
    return [valueTransformer transformedValue:hearing];
}

@end
