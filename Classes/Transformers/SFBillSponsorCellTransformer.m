//
//  SFBillSponsorCellTransformer.m
//  Congress
//
//  Created by Daniel Cloud on 6/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillSponsorCellTransformer.h"
#import "SFCellData.h"
#import "SFBill.h"
#import "SFLegislator.h"
#import "SFPanopticCell.h"
#import "SFOpticView.h"

@implementation SFBillSponsorCellTransformer

+ (Class)transformedValueClass {
    return [SFCellData class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    if (![value isKindOfClass:[NSDictionary class]]) return nil;
    NSDictionary *valueDict = (NSDictionary *)value;

    SFBill *bill = (SFBill *)[valueDict valueForKey:@"bill"];
    SFLegislator *legislator = (SFLegislator *)[valueDict valueForKey:@"legislator"];
    SFCellData *cellData = [SFCellData new];

    cellData.cellIdentifier = @"SFBillSponsorCell";
    cellData.cellStyle = UITableViewCellStyleSubtitle;
    BOOL shortTitleIsNull = [bill.shortTitle isEqual:[NSNull null]] || bill.shortTitle == nil;
    cellData.textLabelString = (!shortTitleIsNull ? bill.shortTitle : bill.officialTitle);
    cellData.textLabelFont = [UIFont cellTextFont];
    cellData.textLabelColor = [UIColor primaryTextColor];
    cellData.textLabelNumberOfLines = 3;
    cellData.detailTextLabelString = bill.displayName;
    cellData.detailTextLabelFont = [UIFont cellDetailTextFont];
    cellData.detailTextLabelColor = [UIColor secondaryTextColor];
    cellData.detailTextLabelNumberOfLines = 1;
    cellData.persist = bill.persist;
    cellData.selectable = YES;

    cellData.accessibilityLabel = [NSString stringWithFormat:@"%@ %@", bill.displayName, cellData.textLabelString];
    cellData.accessibilityHint = [NSString stringWithFormat:@"%@ sponsored this bill", bill.sponsor.fullName];

    return cellData;
}

@end
