//
//  SFLegislatorVoteCellTransformer.m
//  Congress
//
//  Created by Daniel Cloud on 4/10/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorVoteCellTransformer.h"
#import "SFCellData.h"
#import "SFPanopticCell.h"

@implementation SFLegislatorVoteCellTransformer

- (id)transformedValue:(id)value {
    SFCellData *cellData = [super transformedValue:value];
    cellData.extraHeight = SFOpticViewHeight + SFOpticViewMarginVertical;
    return cellData;
}

@end
