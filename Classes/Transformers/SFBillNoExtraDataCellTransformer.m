//
//  SFBillNoExtraDataCellTransformer.m
//  Congress
//
//  Created by Daniel Cloud on 4/22/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillNoExtraDataCellTransformer.h"
#import "SFCellData.h"

@implementation SFBillNoExtraDataCellTransformer

-(id)transformedValue:(id)value
{
    SFCellData *cellData = [super transformedValue:value];
    cellData.extraData = [NSMutableDictionary dictionary];
    cellData.extraHeight = 0;
    
    cellData.detailTextLabelString = nil;
    cellData.detailTextLabelNumberOfLines = 0;

    return cellData;
}

@end
