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

    cellData.cellIdentifier = @"SFDefaultLegislatorCell";
    cellData.cellStyle = UITableViewCellStyleSubtitle;
    cellData.textLabelString = legislator.titledByLastName;
    cellData.textLabelFont = [UIFont cellTextFont];
    cellData.textLabelColor = [UIColor primaryTextColor];
    cellData.textLabelNumberOfLines = 3;
    cellData.detailTextLabelString = legislator.fullDescription;
    cellData.detailTextLabelFont = [UIFont cellDetailTextFont];
    cellData.detailTextLabelColor = [UIColor primaryTextColor];
    cellData.detailTextLabelNumberOfLines = 1;
    cellData.persist = legislator.persist;
    cellData.selectable = YES;
    
    return cellData;
}

@end
