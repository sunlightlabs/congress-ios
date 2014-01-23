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

    cellData.cellStyle = UITableViewCellStyleDefault;
    cellData.textLabelString = [committee primaryName];
    cellData.textLabelNumberOfLines = 3;

    cellData.decorativeHeaderLabelFont = [UIFont cellDecorativeDetailFont];
    cellData.decorativeHeaderLabelString = [committee prefixName] ? : @"";

    cellData.persist = [committee isFollowed];
    cellData.selectable = YES;


    cellData.accessibilityLabel = committee.isSubcommittee ? @"Subcommittee" : @"Committee";
    if ([committee isFollowed]) {
        cellData.accessibilityLabel = [@"Followed " stringByAppendingString : cellData.accessibilityLabel];
    }

    cellData.accessibilityValue = committee.name;
    cellData.accessibilityHint = @"Tap to view detailed committee information";

    return cellData;
}

@end
