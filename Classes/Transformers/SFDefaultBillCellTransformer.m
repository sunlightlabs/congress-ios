//
//  SFDefaultBillCellTransformer.m
//  Congress
//
//  Created by Daniel Cloud on 4/9/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFDefaultBillCellTransformer.h"
#import "SFCellData.h"
#import "SFBill.h"
#import "SFBillAction.h"

@implementation SFDefaultBillCellTransformer

+ (Class)transformedValueClass {
    return [SFCellData class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    if (![value isKindOfClass:[SFBill class]]) return nil;

    SFBill *bill = (SFBill *)value;
    SFCellData *cellData = [SFCellData new];

    cellData.cellStyle = UITableViewCellStyleSubtitle;
    BOOL shortTitleIsNull = [bill.shortTitle isEqual:[NSNull null]] || bill.shortTitle == nil;
    cellData.textLabelString = (!shortTitleIsNull ? bill.shortTitle : bill.officialTitle);
    cellData.textLabelNumberOfLines = 3;

    cellData.decorativeHeaderLabelString = bill.displayName;

    cellData.persist = [bill isFollowed];
    cellData.selectable = YES;

    NSString *accessibilityValue = [NSString stringWithFormat:@"%@ %@", bill.displayName, cellData.textLabelString];

    if (bill.lastAction) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];

        NSString *lastAction = [NSString stringWithFormat:@"%@ on %@",
                                bill.lastAction.typeDescription,
                                [dateFormatter stringFromDate:bill.lastActionAt]];

        lastAction = bill.lastAction.text;

        cellData.detailTextLabelString = lastAction;
        cellData.detailTextLabelNumberOfLines = 3;
        accessibilityValue = [NSString stringWithFormat:@"%@. Last action: %@", accessibilityValue, bill.lastAction.text];
    }

    cellData.accessibilityLabel = @"Bill";
    if ([bill isFollowed]) {
        cellData.accessibilityLabel = [@"Followed " stringByAppendingString : cellData.accessibilityLabel];
    }

    cellData.accessibilityValue = accessibilityValue;
    cellData.accessibilityHint = @"Tap to view detailed bill information";

    return cellData;
}

@end
