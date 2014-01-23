//
//  SFLegislatorTableDataSource.m
//  Congress
//
//  Created by Daniel Cloud on 11/25/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorTableDataSource.h"
#import "SFCellData.h"
#import "SFLegislator.h"

@implementation SFLegislatorTableDataSource

#pragma mark - SFCellDataSource

- (SFCellData *)cellDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    SFLegislator *legislator = (SFLegislator *)[self itemForIndexPath:indexPath];
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:SFDefaultLegislatorCellTransformerName];
    return [transformer transformedValue:legislator];
}

@end
