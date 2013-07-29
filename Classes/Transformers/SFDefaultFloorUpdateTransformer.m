//
//  SFDefaultFloorUpdateTransformer.m
//  Congress
//
//  Created by Daniel Cloud on 7/29/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFDefaultFloorUpdateTransformer.h"
#import "SFCellData.h"
#import "SFFloorUpdate.h"
#import "SFDateFormatterUtil.h"

@implementation SFDefaultFloorUpdateTransformer

+ (Class)transformedValueClass {
    return [SFCellData class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    if (![value isKindOfClass:[SFFloorUpdate class]]) return nil;

    SFFloorUpdate *object = (SFFloorUpdate *)value;
    SFCellData *cellData = [SFCellData new];

    cellData.cellIdentifier = @"SFDefaultFloorUpdateCell";
    cellData.cellStyle = UITableViewCellStyleSubtitle;
    cellData.textLabelString = [object update];
    cellData.textLabelFont = [UIFont cellTextFont];
    cellData.textLabelColor = [UIColor primaryTextColor];
    cellData.textLabelNumberOfLines = 0;
    NSString *timeInWords = [[[object timestamp] timeInWords] stringWithFirstLetterCapitalized];
    BOOL isInPast = [[object timestamp] timeIntervalSinceNow] < 0;
    NSString *legDayText = [NSString stringWithFormat:@"%@ %@", timeInWords, (isInPast ? @"ago." : @"")];
    cellData.detailTextLabelString = legDayText;
    cellData.detailTextLabelFont = [UIFont cellDetailTextFont];
    cellData.detailTextLabelColor = [UIColor secondaryTextColor];
    cellData.detailTextLabelNumberOfLines = 1;

    NSString *accessibilityValue = cellData.textLabelString;

    cellData.accessibilityLabel = @"Floor update";
    cellData.accessibilityValue = accessibilityValue;
//    cellData.accessibilityHint = @"Tap to view detailed bill information";

    return cellData;
}

@end
