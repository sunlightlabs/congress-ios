//
//  SFDefaultHearingCellTransformer.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/30/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFDefaultHearingCellTransformer.h"
#import "SFHearing.h"
#import "SFCellData.h"

@implementation SFDefaultHearingCellTransformer

+ (Class)transformedValueClass {
    return [SFCellData class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    if (![value isKindOfClass:[SFHearing class]]) return nil;

    SFHearing *hearing = (SFHearing *)value;
    SFCellData *cellData = [SFCellData new];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];

    cellData.cellStyle = UITableViewCellStyleSubtitle;
    cellData.textLabelString = hearing.summary;
    cellData.textLabelNumberOfLines = 4;
    cellData.detailTextLabelFont = [UIFont cellSecondaryDetailFont];
    cellData.detailTextLabelString = [dateFormatter stringFromDate:hearing.occursAt];
    cellData.detailTextLabelNumberOfLines = 1;

    if (hearing.committee) {
        cellData.decorativeHeaderLabelString = [NSString stringWithFormat:@"%@ %@", hearing.committee.prefixName, hearing.committee.primaryName];
        cellData.decorativeHeaderLabelFont = [UIFont cellDecorativeDetailFont];
    }

    cellData.selectable = YES;

    [cellData setAccessibilityLabel:@"Hearing"];
    [cellData setAccessibilityValue:[NSString stringWithFormat:@"%@. %@", hearing.summary, [dateFormatter stringFromDate:hearing.occursAt]]];
    [cellData setAccessibilityHint:@"Tap to view hearing details"];

    return cellData;
}

@end
