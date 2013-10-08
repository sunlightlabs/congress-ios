//
//  SFCommitteeHearingCellTransformer.m
//  Congress
//
//  Created by Jeremy Carbaugh on 10/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteeHearingCellTransformer.h"
#import "SFHearing.h"
#import "SFCellData.h"

@implementation SFCommitteeHearingCellTransformer

- (id)transformedValue:(id)value {
    SFCellData *cellData = [super transformedValue:value];
    if (cellData) {
        cellData.decorativeHeaderLabelString = nil;
    }
    return cellData;
}

@end
