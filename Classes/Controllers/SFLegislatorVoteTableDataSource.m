//
//  SFLegislatorVoteTableDataSource.m
//  Congress
//
//  Created by Daniel Cloud on 11/25/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorVoteTableDataSource.h"
#import "SFLegislator.h"

@implementation SFLegislatorVoteTableDataSource

@synthesize vote;

#pragma mark - SFCellDataSource

- (SFCellData *)cellDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    SFLegislator *legislator = (SFLegislator *)[self itemForIndexPath:indexPath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:legislator forKey:@"legislator"];
    if (self.vote) {
        [dict setObject:self.vote forKey:@"rollCall"];
    }

    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:SFLegislatorVoteCellTransformerName];
    return [transformer transformedValue:dict];
}

@end
