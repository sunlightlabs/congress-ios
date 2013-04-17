//
//  SFBillSearchCellTransformer.m
//  Congress
//
//  Created by Daniel Cloud on 4/15/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillSearchCellTransformer.h"
#import "SFCellData.h"
#import "SFBill.h"

@implementation SFBillSearchCellTransformer

- (id)transformedValue:(id)value
{
    SFBill *bill = (SFBill *)value;
    SFCellData *cellData = [super transformedValue:value];
    cellData.cellIdentifier = @"SFBillSearchCell";
    cellData.extraData = [NSMutableDictionary dictionary];
    cellData.extraHeight = 0;

    cellData.detailTextLabelString = bill.displayName;

    NSDateFormatter *dateFormatter = [NSDateFormatter shortHumanDateFormatter];
    cellData.tertiaryTextLabelString = [dateFormatter stringFromDate:bill.introducedOn];

    return cellData;
}

@end
