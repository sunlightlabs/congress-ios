//
//  SFLegislatorBillsTableDataSource.m
//  Congress
//
//  Created by Daniel Cloud on 11/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorBillsTableDataSource.h"
#import "SFBill.h"
#import "SFLegislator.h"

@implementation SFLegislatorBillsTableDataSource

#pragma mark - SFCellDataSource

- (SFCellData *)cellDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    SFBill *bill  = (SFBill *)[self itemForIndexPath:indexPath];
    if (!bill) return nil;
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFBillSponsorCellTransformerName];
    return [valueTransformer transformedValue:@{ @"bill": bill }];
}

@end
