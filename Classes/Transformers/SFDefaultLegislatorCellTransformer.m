//
//  SFDefaultLegislatorCellTransformer.m
//  Congress
//
//  Created by Daniel Cloud on 4/10/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFDefaultLegislatorCellTransformer.h"
#import "SFCellData.h"
#import "SFLegislator.h"

@implementation SFDefaultLegislatorCellTransformer

+ (Class)transformedValueClass {
    return [SFCellData class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    if (![value isKindOfClass:[SFLegislator class]]) return nil;

    SFLegislator *legislator = (SFLegislator *)value;
    SFCellData *cellData = [SFCellData new];

    cellData.cellStyle = UITableViewCellStyleSubtitle;
    cellData.textLabelString = legislator.titledByLastName;
    cellData.textLabelNumberOfLines = 3;
    cellData.detailTextLabelFont = cellData.decorativeHeaderLabelFont;
    cellData.tertiaryTextLabelFont = [UIFont cellDecorativeDetailFont];
    cellData.tertiaryTextLabelColor = cellData.detailTextLabelColor;
    cellData.detailTextLabelString = legislator.fullDescription;
    cellData.detailTextLabelNumberOfLines = 1;
    cellData.persist = [legislator isFollowed];
    cellData.selectable = YES;

    [cellData setAccessibilityLabel:@"Legislator"];
    if ([legislator isFollowed]) {
        cellData.accessibilityLabel = [@"Followed " stringByAppendingString : cellData.accessibilityLabel];
    }

    [cellData setAccessibilityHint:@"Tap to view legislator details"];
    NSString *titleFullNameAndParty = [NSString stringWithFormat:@"%@ %@, %@", legislator.fullTitle, legislator.fullName, legislator.partyName];
    if ([legislator.title isEqualToString:@"Sen"]) {
        [cellData setAccessibilityValue:[NSString stringWithFormat:@"%@ from %@", titleFullNameAndParty, legislator.stateName]];
    }
    else if ([legislator.district isEqualToNumber:[NSNumber numberWithInt:0]]) {
        [cellData setAccessibilityValue:[NSString stringWithFormat:@"%@ from %@, at-large", titleFullNameAndParty, legislator.stateName]];
    }
    else {
        [cellData setAccessibilityValue:[NSString stringWithFormat:@"%@ from %@ district %@", titleFullNameAndParty, legislator.stateName, legislator.district]];
    }

    return cellData;
}

@end
