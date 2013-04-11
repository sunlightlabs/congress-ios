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

    cellData.cellIdentifier = @"SFDefaultRollCallVoteCell";
    cellData.cellStyle = UITableViewCellStyleSubtitle;
    cellData.textLabelString = object.question;
    cellData.textLabelFont = [UIFont cellTextFont];
    cellData.textLabelColor = [UIColor primaryTextColor];
    cellData.textLabelNumberOfLines = 3;
    cellData.selectable = YES;

    return cellData;
}

@end
