//
//  SFBasicTextCellTransformer.m
//  Congress
//
//  Created by Daniel Cloud on 4/11/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBasicTextCellTransformer.h"
#import "SFCellData.h"

@implementation SFBasicTextCellTransformer

+ (Class)transformedValueClass {
    return [SFCellData class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    if (![value isKindOfClass:[NSDictionary class]]) return nil;

    NSDictionary *object = (NSDictionary *)value;
    SFCellData *cellData = [SFCellData new];

    cellData.cellStyle = (NSInteger)[object valueForKey : @"cellStyle"] ? : UITableViewCellStyleValue1;
    cellData.textLabelString = [object valueForKey:@"textLabelString"] ? : @"";
    cellData.textLabelNumberOfLines = 1;
    cellData.detailTextLabelString = [object valueForKey:@"detailTextLabelString"] ? : @"";
    cellData.detailTextLabelNumberOfLines = 1;
    cellData.selectable = [[object valueForKey:@"selectable"] boolValue];

    return cellData;
}

@end
