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
#import "SFDateFormatterUtil.h"

@implementation SFBillSearchCellTransformer

- (id)transformedValue:(id)value
{
    SFBill *bill = (SFBill *)value;
    SFCellData *cellData = [super transformedValue:value];
    cellData.cellIdentifier = @"SFBillSearchCell";


    NSDateFormatter *dateFormatter = [SFDateFormatterUtil longDateNoTimeFormatter];
    NSString *humanSession = [NSString stringWithFormat:@"%@ Congress", bill.congress ];
    cellData.detailTextLabelString = [NSString stringWithFormat:@"Introduced %@", [dateFormatter stringFromDate:bill.introducedOn]];

    return cellData;
}

@end
