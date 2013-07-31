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
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *detail = [dateFormatter stringFromDate:hearing.occursAt];
    if (hearing.room) {
        detail = [NSString stringWithFormat:@"%@ - Room %@", detail, hearing.room];
    }
    
    cellData.cellIdentifier = @"SFDefaultHearingCell";
    cellData.cellStyle = UITableViewCellStyleSubtitle;
    cellData.textLabelString = hearing.description;
    cellData.textLabelFont = [UIFont cellTextFont];
    cellData.textLabelColor = [UIColor primaryTextColor];
    cellData.textLabelNumberOfLines = 5;
    cellData.detailTextLabelString = detail;
    cellData.detailTextLabelFont = [UIFont cellDetailTextFont];
    cellData.detailTextLabelColor = [UIColor secondaryTextColor];
    cellData.detailTextLabelNumberOfLines = 1;
    cellData.selectable = NO;
    
    [cellData setAccessibilityLabel:@"Hearing"];
    [cellData setAccessibilityValue:hearing.description];
//    [cellData setAccessibilityHint:@"Tap to view legislator details"];
    
    return cellData;
}

@end
