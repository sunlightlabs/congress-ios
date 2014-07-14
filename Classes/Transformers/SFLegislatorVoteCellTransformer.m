//
//  SFLegislatorVoteCellTransformer.m
//  Congress
//
//  Created by Daniel Cloud on 4/10/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorVoteCellTransformer.h"
#import "SFCellData.h"
#import "SFLegislator.h"
#import "SFRollCallVote.h"

@implementation SFLegislatorVoteCellTransformer

- (id)transformedValue:(id)value {
    NSDictionary *dict = (NSDictionary *)value;

    SFLegislator *legislator = [dict objectForKey:@"legislator"];
    SFRollCallVote *rollCall = [dict objectForKey:@"rollCall"];

    SFCellData *cellData = [super transformedValue:legislator];
    cellData.accessibilityLabel = @"Followed Legislator";

    cellData.detailTextLabelFont = [UIFont cellImportantDetailFont]; // restore default detail font.
    cellData.decorativeHeaderLabelString = legislator.fullDescription;

    if (rollCall) {
        NSString *voteCast = (NSString *)[rollCall.voterDict sam_safeObjectForKey:legislator.bioguideId];
        if (voteCast) {
            if ([voteCast isEqualToString:@"Not Voting"]) {
                cellData.detailTextLabelString = @"Did not vote";
            }
            else {
                cellData.detailTextLabelString = [NSString stringWithFormat:@"Voted %@", voteCast];
            }
            cellData.accessibilityValue = [NSString stringWithFormat:@"%@ voted %@", legislator.titledName, voteCast];
        }
        else {
            cellData.detailTextLabelString = [NSString stringWithFormat:@"No vote recorded"];
            cellData.accessibilityValue = [NSString stringWithFormat:@"%@ had no recorded vote", legislator.titledName];
        }
    }

    cellData.persist = NO;

    return cellData;
}

@end
