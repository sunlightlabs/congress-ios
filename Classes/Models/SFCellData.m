//
//  SFCellData.m
//  Congress
//
//  Created by Daniel Cloud on 4/9/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCellData.h"
#import "SFTableCell.h"

@implementation SFCellData

@synthesize cellIdentifier;
@synthesize cellStyle;
@synthesize textLabelString;
@synthesize textLabelFont;
@synthesize textLabelColor;
@synthesize textLabelNumberOfLines;
@synthesize detailTextLabelString;
@synthesize detailTextLabelFont;
@synthesize detailTextLabelColor;
@synthesize detailTextLabelNumberOfLines;
@synthesize tertiaryTextLabelString;
@synthesize tertiaryTextLabelFont;
@synthesize tertiaryTextLabelColor;
@synthesize tertiaryTextLabelNumberOfLines;
@synthesize selectable;
@synthesize persist;
@synthesize extraData;
@synthesize extraHeight;

- (CGFloat)heightForWidth:(CGFloat)width
{
    CGFloat maxWidth = width - (2*SFTableCellContentInsetHorizontal);
    if (self.selectable) maxWidth -= floorf(1.5*SFTableCellAccessoryOffset);
    CGFloat maxHeight = (self.textLabelNumberOfLines > 0) ? (self.textLabelFont.lineHeight * self.textLabelNumberOfLines) : CGFLOAT_MAX;
    CGSize maxLabelSize = CGSizeMake(maxWidth, maxHeight);
    CGSize textSize = [self.textLabelString sizeWithFont:self.textLabelFont constrainedToSize:maxLabelSize];

    CGSize detailTextSize = CGSizeMake(0, 0);
    if (self.detailTextLabelString && !(self.cellStyle == UITableViewCellStyleValue1 || self.cellStyle == UITableViewCellStyleValue2)) {
        CGSize maxDetailLabelSize = CGSizeMake(maxWidth,
                                               (self.detailTextLabelFont.lineHeight * self.detailTextLabelNumberOfLines));
        detailTextSize = [self.detailTextLabelString sizeWithFont:self.detailTextLabelFont constrainedToSize:maxDetailLabelSize];
    }
    CGFloat height = textSize.height + detailTextSize.height + (2 * SFTableCellContentInsetVertical);
    if (detailTextSize.height > 0.0f) height += SFTableCellDetailTextLabelOffset;
    if (extraHeight > 0) height += extraHeight;

    return height;
}

@end
