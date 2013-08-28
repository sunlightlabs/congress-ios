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
@synthesize decorativeHeaderLabelString;
@synthesize decorativeHeaderLabelFont;
@synthesize decorativeHeaderLabelColor;
@synthesize selectable;
@synthesize persist;
@synthesize extraData;
@synthesize extraHeight;

- (id)init
{
    self = [super init];
    if (self) {
        self.textLabelFont = [UIFont cellTextFont];
        self.detailTextLabelFont = [UIFont cellDetailTextFont];
        self.tertiaryTextLabelFont = [UIFont cellDetailTextFont];
        self.decorativeHeaderLabelFont = [UIFont cellDecorativeTextFont];
    }
    return self;
}

- (CGFloat)heightForWidth:(CGFloat)width
{
    CGFloat maxWidth = floorf(width - (2*SFTableCellContentInsetHorizontal));
    if (self.selectable) maxWidth -= SFTableCellAccessoryOffset;
    CGFloat maxHeight = (self.textLabelNumberOfLines > 0) ? (self.textLabelFont.lineHeight * self.textLabelNumberOfLines) : CGFLOAT_MAX;
    CGSize maxLabelSize = CGSizeMake(maxWidth, maxHeight);
    CGSize textSize = [self _sizeForTextLabelStringWithMaxSize:maxLabelSize];
    if (self.persist) {
        NSUInteger textLength = self.textLabelString.length;
        NSRange stringRange = NSMakeRange(0, textLength);
        NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithString:self.textLabelString];
        [textString addAttribute:NSFontAttributeName value:self.textLabelFont range:stringRange];
        NSMutableParagraphStyle *pStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [pStyle setFirstLineHeadIndent:SFTableCellPreTextImageOffset];
        [textString addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, textLength)];
        CGRect boundingRect = [textString boundingRectWithSize:maxLabelSize options:(NSStringDrawingUsesDeviceMetrics | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine) context:nil];
        textSize = boundingRect.size;
    }

    CGSize detailTextSize = CGSizeMake(0, 0);
    if (self.detailTextLabelString && !(self.cellStyle == UITableViewCellStyleValue1 || self.cellStyle == UITableViewCellStyleValue2)) {
        CGSize maxDetailLabelSize = CGSizeMake(maxWidth,
                                               (self.detailTextLabelFont.lineHeight * self.detailTextLabelNumberOfLines));
        detailTextSize = [self.detailTextLabelString sizeWithFont:self.detailTextLabelFont constrainedToSize:maxDetailLabelSize];
    }
    CGFloat height = textSize.height + detailTextSize.height + (2 * SFTableCellContentInsetVertical);
    if (detailTextSize.height > 0.0f) height += SFTableCellDetailTextLabelOffset;
    if (extraHeight > 0) height += extraHeight;
    
    if (self.decorativeHeaderLabelString) {
        height += 18;
    }

    return ceilf(height);
}

#pragma mark - iOS 7 bifurcation
- (CGSize)_sizeForTextLabelStringWithMaxSize:(CGSize)maxSize {
    CGSize textLabelSize;
    if ([[UIDevice currentDevice] systemMajorVersion] < 7) {
        textLabelSize = [self.textLabelString sizeWithFont:self.textLabelFont constrainedToSize:maxSize];
    }
    else {
        CGRect bRect = [self.textLabelString boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName: self.textLabelFont} context:nil];
        textLabelSize = bRect.size;
    }
    return textLabelSize;
}

@end
