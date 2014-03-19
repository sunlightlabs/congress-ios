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
#import <TTTOrdinalNumberFormatter.h>

@implementation SFBillSearchCellTransformer

static TTTOrdinalNumberFormatter *ordinalNumberFormatter;

- (id)transformedValue:(id)value {
    SFBill *bill = (SFBill *)value;
    SFCellData *cellData = [super transformedValue:value];

    if (!ordinalNumberFormatter) {
        ordinalNumberFormatter = [[TTTOrdinalNumberFormatter alloc] init];
        [ordinalNumberFormatter setLocale:[NSLocale currentLocale]];
        [ordinalNumberFormatter setGrammaticalGender:TTTOrdinalNumberFormatterMaleGender];
    }

    NSInteger introYear = [bill.introducedOn dateComponents].year;
    NSString *humanSession = [NSString stringWithFormat:@"%@ Congress", [ordinalNumberFormatter stringFromNumber:bill.congress]];
    cellData.detailTextLabelString = humanSession;
    cellData.tertiaryTextLabelString = [NSString stringWithFormat:@"%ld", (long)introYear];

    return cellData;
}

@end
