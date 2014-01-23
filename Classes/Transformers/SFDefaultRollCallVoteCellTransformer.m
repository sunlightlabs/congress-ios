//
//  SFDefaultRollCallVoteCellTransformer.m
//  Congress
//
//  Created by Daniel Cloud on 4/10/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFDefaultRollCallVoteCellTransformer.h"
#import "SFCellData.h"
#import "SFRollCallVote.h"

@implementation SFDefaultRollCallVoteCellTransformer

+ (Class)transformedValueClass {
    return [SFCellData class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    if (![value isKindOfClass:[SFRollCallVote class]]) return nil;

    SFRollCallVote *object = (SFRollCallVote *)value;
    SFCellData *cellData = [SFCellData new];

    cellData.cellStyle = UITableViewCellStyleSubtitle;
    cellData.textLabelString = object.question;
    cellData.textLabelNumberOfLines = 3;
    cellData.detailTextLabelString = [object.result capitalizedString];
    cellData.selectable = YES;

    [cellData setAccessibilityLabel:@"Roll call"];
    [cellData setAccessibilityValue:object.question];
    [cellData setAccessibilityHint:@"Tap to view the results of the roll call"];

    return cellData;
}

@end
