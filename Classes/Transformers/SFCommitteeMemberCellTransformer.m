//
//  SFCommitteeMemberCellTransformer.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/30/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteeMemberCellTransformer.h"
#import "SFCommittee.h"
#import "SFCellData.h"
#import "SFPanopticCell.h"

@implementation SFCommitteeMemberCellTransformer

- (id)transformedValue:(id)value {
    
    SFCommitteeMember *member = (SFCommitteeMember *)value;
    SFCellData *cellData = [super transformedValue:member.legislator];

    if (![member.title isEqual:[NSNull null]]) {
        [cellData setTertiaryTextLabelString:member.title];
        [cellData setTertiaryTextLabelColor:[UIColor linkTextColor]];
    }
    
    return cellData;
}

@end
