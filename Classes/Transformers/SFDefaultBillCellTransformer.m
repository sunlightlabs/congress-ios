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
#import "SFPanopticCell.h"
#import "SFOpticView.h"

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

    cellData.cellIdentifier = @"SFDefaultBillCell";
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
    
    NSString *accessibilityValue = [NSString stringWithFormat:@"%@ %@", bill.displayName, cellData.textLabelString];

    if (bill.lastAction) {
        cellData.extraData = [NSMutableDictionary dictionary];
        SFOpticView *view = [[SFOpticView alloc] initWithFrame:CGRectZero];
        view.textLabel.text = bill.lastAction.text;
        [cellData.extraData setObject:@[view] forKey:@"opticViews"];
        cellData.extraHeight = SFOpticViewHeight + SFOpticViewMarginVertical;
        
        accessibilityValue = [NSString stringWithFormat:@"%@. Last action: %@", accessibilityValue, bill.lastAction.text];
    }
    
    cellData.accessibilityLabel = @"Bill";
    cellData.accessibilityValue = accessibilityValue;
    cellData.accessibilityHint = @"Tap to view detailed bill information";

    return cellData;
}

@end
