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
    SFCellData *cellData = [SFCellData new];

    cellData.cellStyle = UITableViewCellStyleSubtitle;
    BOOL shortTitleIsNull = [bill.shortTitle isEqual:[NSNull null]] || bill.shortTitle == nil;
    cellData.textLabelString = (!shortTitleIsNull ? bill.shortTitle : bill.officialTitle);
    cellData.textLabelNumberOfLines = 3;
    cellData.decorativeHeaderLabelString = bill.displayName;
    cellData.persist = [bill isFollowed];
    cellData.selectable = YES;

    cellData.accessibilityLabel = [NSString stringWithFormat:@"%@ %@", bill.displayName, cellData.textLabelString];
    cellData.accessibilityHint = [NSString stringWithFormat:@"%@ sponsored this bill", bill.sponsor.fullName];

    return cellData;
}

@end
