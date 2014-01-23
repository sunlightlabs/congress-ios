//
//  SFMixedDataSource.m
//  Congress
//
//  Created by Daniel Cloud on 11/25/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFMixedTableDataSource.h"
#import "SFBill.h"
#import "SFLegislator.h"

@implementation SFMixedTableDataSource

- (SFCellData *)cellDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self itemForIndexPath:indexPath];

    Class objectClass = [object class];
    NSValueTransformer *valueTransformer;
    if (objectClass == [SFBill class]) {
        valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultBillCellTransformerName];
    }
    else if (objectClass == [SFLegislator class]) {
        valueTransformer = [NSValueTransformer valueTransformerForName:SFDefaultLegislatorCellTransformerName];
    }
    return [valueTransformer transformedValue:object];
}

@end
