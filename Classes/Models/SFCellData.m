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
@synthesize decorativeHeaderLabelString;
@synthesize decorativeHeaderLabelFont;
@synthesize decorativeHeaderLabelColor;
@synthesize selectable;
@synthesize persist;
@synthesize extraData;
@synthesize extraHeight;

- (id)init {
    self = [super init];
    if (self) {
        self.textLabelFont = [UIFont cellTextFont];
        self.textLabelColor = [UIColor primaryTextColor];

        self.detailTextLabelFont = [UIFont cellImportantDetailFont];
        self.detailTextLabelColor = [UIColor secondaryTextColor];

        self.tertiaryTextLabelFont = [UIFont cellImportantDetailFont];
        self.tertiaryTextLabelColor = [UIColor secondaryTextColor];

        self.decorativeHeaderLabelFont = [UIFont cellSecondaryDetailFont];
        self.decorativeHeaderLabelColor = [UIColor secondaryTextColor];
        self.persist = NO;
    }
    return self;
}

- (CGFloat)heightForWidth:(CGFloat)width {
    CGFloat maxWidth = ceilf(width - (2 * SFTableCellContentInsetHorizontal));
    maxWidth -= SFTableCellContentInsetHorizontal + 2.0f; // add some fudge
    
    CGFloat maxHeight = (self.textLabelNumberOfLines > 0) ? ceilf(self.textLabelFont.lineHeight * self.textLabelNumberOfLines) : CGFLOAT_MAX;
    CGSize maxLabelSize = CGSizeMake(maxWidth, maxHeight);
    CGSize textSize = [self.textLabelString sf_sizeWithFont:self.textLabelFont constrainedToSize:maxLabelSize];
    if (self.persist) {
        if ([[UIDevice currentDevice] systemMajorVersion] < 7) {
            maxWidth -= SFTableCellContentInsetHorizontal + 2.0f; // add some fudge
            maxLabelSize = CGSizeMake(maxWidth, maxHeight);
        }
        NSUInteger textLength = self.textLabelString.length;
        NSRange stringRange = NSMakeRange(0, textLength);
        NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithString:self.textLabelString];
        [textString addAttribute:NSFontAttributeName value:self.textLabelFont range:stringRange];
        NSMutableParagraphStyle *pStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [pStyle setFirstLineHeadIndent:SFTableCellPreTextImageOffset];
        [textString addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, textLength)];
        NSInteger options = (NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine);
        CGRect boundingRect = [textString boundingRectWithSize:maxLabelSize options:options context:nil];
        textSize = boundingRect.size;
    }

    CGSize detailTextSize = CGSizeMake(0, 0);
    if (self.detailTextLabelString && !(self.cellStyle == UITableViewCellStyleValue1 || self.cellStyle == UITableViewCellStyleValue2)) {
        CGSize maxDetailLabelSize = CGSizeMake(maxWidth,
                                               (self.detailTextLabelFont.lineHeight * self.detailTextLabelNumberOfLines));
        detailTextSize = [self.detailTextLabelString sf_sizeWithFont:self.detailTextLabelFont constrainedToSize:maxDetailLabelSize];
    }
    CGFloat height = textSize.height + detailTextSize.height + (2 * SFTableCellContentInsetVertical);
    if (detailTextSize.height > 0.0f) height += SFTableCellDetailTextLabelOffset;
    if (extraHeight > 0) height += extraHeight;

    if (self.decorativeHeaderLabelString) {
        height += 22;
    }

    return ceilf(height);
}

@end
