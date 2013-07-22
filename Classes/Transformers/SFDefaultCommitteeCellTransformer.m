//
//  SFDefaultCommitteeCellTransformer.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/20/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFDefaultCommitteeCellTransformer.h"
#import "SFCommittee.h"
#import "SFCellData.h"

@implementation SFDefaultCommitteeCellTransformer

+ (Class)transformedValueClass {
    return [SFCellData class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    
    if (value == nil) return nil;
    if (![value isKindOfClass:[SFCommittee class]]) return nil;
    
    SFCommittee *committee = (SFCommittee *)value;
    SFCellData *cellData = [SFCellData new];
    
    cellData.cellIdentifier = @"SFDefaultCommitteeCell";
    cellData.cellStyle = UITableViewCellStyleSubtitle;
    cellData.textLabelString = committee.name;
    cellData.textLabelFont = [UIFont cellTextFont];
    cellData.textLabelColor = [UIColor primaryTextColor];
    cellData.textLabelNumberOfLines = 3;
    cellData.detailTextLabelString = @"";
    cellData.detailTextLabelFont = [UIFont cellDetailTextFont];
    cellData.detailTextLabelColor = [UIColor secondaryTextColor];
    cellData.detailTextLabelNumberOfLines = 1;
    cellData.persist = committee.persist;
    cellData.selectable = YES;
    
    cellData.accessibilityLabel = @"Committee";
    cellData.accessibilityValue = committee.name;
    cellData.accessibilityHint = @"Tap to view detailed committee information";
    
    return cellData;
}

@end
