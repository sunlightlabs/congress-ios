//
//  SFDefaultBillActionCellTransformer.m
//  Congress
//
//  Created by Daniel Cloud on 4/10/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFDefaultBillActionCellTransformer.h"
#import "SFCellData.h"
#import "SFBillAction.h"

@implementation SFDefaultBillActionCellTransformer

+ (Class)transformedValueClass {
    return [SFCellData class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    if (![value isKindOfClass:[SFBillAction class]]) return nil;

    SFBillAction *object = (SFBillAction *)value;
    SFCellData *cellData = [SFCellData new];

    id rollId = [object valueForKeyPath:@"rollId"];

    cellData.cellStyle = UITableViewCellStyleSubtitle;
    cellData.textLabelString = object.text;
    cellData.textLabelNumberOfLines = 0;
    cellData.selectable = (BOOL)rollId;

    [cellData setAccessibilityLabel:@"Activity"];
    [cellData setAccessibilityValue:object.text];

    return cellData;
}

@end
