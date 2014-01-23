//
//  SFBillSearchTableDataSource.m
//  Congress
//
//  Created by Daniel Cloud on 11/25/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillSearchTableDataSource.h"
#import "SFBill.h"

@implementation SFBillSearchTableDataSource

#pragma mark - SFCellDataSource

- (SFCellData *)cellDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    id bill  = [self itemForIndexPath:indexPath];
    if (!bill) return nil;
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFBillSearchCellTransformerName];
    return [valueTransformer transformedValue:bill];
}

@end
