 //
//  SFTableCell.m
//  Congress
//
//  Created by Daniel Cloud on 3/7/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFTableCell.h"
#import "SFCellData.h"

CGFloat const SFTableCellContentInsetHorizontal = 21.0f;
CGFloat const SFTableCellContentInsetVertical = 8.0f;
CGFloat const SFTableCellDetailTextLabelOffset = 6.0f;
CGFloat const SFTableCellPreTextImageOffset = 16.0f;
CGFloat const SFTableCellAccessoryOffset = 24.0f;


@implementation SFTableCell
{
    UIImageView *_disclosureImageView;
    UIImageView *_highlightedDisclosureView;
}

+ (instancetype)cellWithData:(SFCellData *)data
{
    SFTableCell *cell = [[SFTableCell alloc] initWithStyle:data.cellStyle reuseIdentifier:NSStringFromClass([SFTableCell class])];
    [cell setCellData:data];
    return cell;

}

@synthesize cellIdentifier = _cellIdentifier;
@synthesize cellData = _cellData;
@synthesize cellStyle = _cellStyle;
@synthesize selectable = _selectable;
@synthesize decorativeHeaderLabel = _decorativeHeaderLabel;
@synthesize tertiaryTextLabel = _tertiaryTextLabel;
@synthesize preTextImageView = _preTextImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellStyle = style;
        [self _initialize];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize accessorySize = self.accessoryView.frame.size;

    CGSize labelSize = [self labelSize:self.textLabel];
    CGSize maxLabelSize = CGSizeMake([self _maxLabelWidth], labelSize.height);
    self.textLabel.size = maxLabelSize;
    self.textLabel.top = SFTableCellContentInsetVertical;
    self.textLabel.left = SFTableCellContentInsetHorizontal;

    if (_decorativeHeaderLabel.text) {
        _decorativeHeaderLabel.top = SFTableCellContentInsetVertical + 2;
        _decorativeHeaderLabel.left = SFTableCellContentInsetHorizontal;
        [_decorativeHeaderLabel sizeToFit];
        self.textLabel.top += SFTableCellContentInsetVertical + 8;
    }

    if (self.cellData.persist) {
        [_preTextImageView sizeToFit];
        NSUInteger textLength = self.textLabel.text.length;
        NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithAttributedString:self.textLabel.attributedText];
        if (textString.length == 0) {
            textString = [[NSMutableAttributedString alloc] initWithString:self.textLabel.text];
        }
        _preTextImageView.left = self.textLabel.left;
        CGFloat offset = [[UIDevice currentDevice] systemMajorVersion] < 7 ? 1.0f : 0.5f;
        _preTextImageView.top = self.textLabel.top + offset;
        NSMutableParagraphStyle *pStyle = [(NSParagraphStyle *)[textString attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:NULL] mutableCopy];
        [pStyle setFirstLineHeadIndent:SFTableCellPreTextImageOffset];
        [textString addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, textLength)];
        self.textLabel.attributedText = textString;
        CGSize biggerLabel = [self.textLabel sizeThatFits:maxLabelSize];
        self.textLabel.size = CGSizeMake(maxLabelSize.width, biggerLabel.height);
    }

    CGFloat rightOffset = ceilf(self.contentView.width - SFTableCellContentInsetHorizontal/3.0f);
    if (self.detailTextLabel) {
        if (self.cellStyle == UITableViewCellStyleValue1 || self.cellStyle == UITableViewCellStyleValue2) {
            self.detailTextLabel.center = self.textLabel.center;
            self.detailTextLabel.right = rightOffset;
        }
        else
        {
            self.detailTextLabel.top = self.textLabel.bottom + SFTableCellDetailTextLabelOffset;
            self.detailTextLabel.left = SFTableCellContentInsetHorizontal;
        }
    }

    self.tertiaryTextLabel.size = [self labelSize:self.tertiaryTextLabel];
    self.tertiaryTextLabel.top = self.textLabel.bottom + SFTableCellDetailTextLabelOffset;
    if (([self.tertiaryTextLabel.text length] > 0) && !(self.cellStyle == UITableViewCellStyleValue1 || self.cellStyle == UITableViewCellStyleValue2))
    {
        self.tertiaryTextLabel.right = rightOffset;
    }

    if (self.height < self.cellHeight) self.height = ceilf(self.cellHeight);
    self.contentView.height = ceilf(self.cellHeight);
    self.contentView.width = floorf(self.accessoryView.left);
    self.accessoryView.top =  (self.contentView.height-accessorySize.height)/2;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [_highlightedDisclosureView setHidden:!highlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [_highlightedDisclosureView setHidden:!selected];
}

#pragma mark - SFTableCell

- (void)setCellData:(SFCellData *)data
{
    _cellData = data;
    self.cellIdentifier = _cellData.cellIdentifier;
    self.textLabel.font = _cellData.textLabelFont ?: self.textLabel.font;
    self.textLabel.textColor = _cellData.textLabelColor ?: self.textLabel.textColor;
    self.textLabel.numberOfLines = _cellData.textLabelNumberOfLines;
    self.textLabel.text = _cellData.textLabelString ?: @"";
    self.detailTextLabel.font = _cellData.detailTextLabelFont ?: self.detailTextLabel.font;
    self.detailTextLabel.textColor = _cellData.detailTextLabelColor ?: self.detailTextLabel.textColor;
    self.detailTextLabel.numberOfLines = _cellData.detailTextLabelNumberOfLines ?: 1;
    self.detailTextLabel.text = _cellData.detailTextLabelString ?: @"";
    self.tertiaryTextLabel.font = _cellData.tertiaryTextLabelFont ?: self.tertiaryTextLabel.font;
    self.tertiaryTextLabel.textColor = _cellData.tertiaryTextLabelColor ?: self.tertiaryTextLabel.textColor;
    self.tertiaryTextLabel.numberOfLines = _cellData.tertiaryTextLabelNumberOfLines ?: 1;
    self.tertiaryTextLabel.text = _cellData.tertiaryTextLabelString ?: @"";
    
    self.decorativeHeaderLabel.font = _cellData.decorativeHeaderLabelFont ?: self.decorativeHeaderLabel.font;
    self.decorativeHeaderLabel.textColor = _cellData.decorativeHeaderLabelColor ?: self.decorativeHeaderLabel.textColor;
    self.decorativeHeaderLabel.text = _cellData.decorativeHeaderLabelString ?: nil;
    self.decorativeHeaderLabel.numberOfLines = 1;
    
    if (_cellData.accessibilityLabel)
        [self setAccessibilityLabel:_cellData.accessibilityLabel];
    
    if (_cellData.accessibilityValue)
        [self setAccessibilityValue:_cellData.accessibilityValue];
    
    if (_cellData.accessibilityHint)
        [self setAccessibilityHint:_cellData.accessibilityHint];

    self.selectable = _cellData.selectable;
}

- (CGFloat)cellHeight
{
    return [_cellData heightForWidth:self.width];
}

- (CGSize)labelSize:(UILabel *)label
{
    CGFloat lineHeight = ceilf(label.font.lineHeight * label.numberOfLines);
    CGSize labelArea = CGSizeMake([self _maxLabelWidth], lineHeight);
    return [label sizeThatFits:labelArea];
}

- (void)setSelectable:(BOOL)pSelectable
{
    _selectable = pSelectable;
    if (_selectable)
    {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.selectedBackgroundView.opaque = YES;
        self.selectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.selectedBackgroundView.backgroundColor = [UIColor selectedCellBackgroundColor];
    }
    else
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.selectedBackgroundView = nil;
        self.accessoryView.hidden = YES;
    }
}

#pragma mark - Private

- (void)_initialize {
    _cellIdentifier = NSStringFromClass([self class]);
    self.opaque = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor primaryBackgroundColor];
    self.contentView.clipsToBounds = YES;

    self.textLabel.font = [UIFont cellTextFont];
    self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.textLabel.textColor = [UIColor primaryTextColor];
    self.textLabel.highlightedTextColor = [UIColor primaryTextColor];

    self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundView.opaque = YES;
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundView.backgroundColor = [UIColor primaryBackgroundColor];

    self.textLabel.backgroundColor = [UIColor clearColor];
    if (self.detailTextLabel) {
        self.detailTextLabel.font = [UIFont cellDetailTextFont];
        self.detailTextLabel.textColor = [UIColor secondaryTextColor];
        self.detailTextLabel.highlightedTextColor = [UIColor secondaryTextColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
    }

    _decorativeHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _decorativeHeaderLabel.font = [UIFont cellDecorativeTextFont];
    _decorativeHeaderLabel.textColor = [UIColor secondaryTextColor];
    _decorativeHeaderLabel.highlightedTextColor = [UIColor primaryTextColor];
    _decorativeHeaderLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_decorativeHeaderLabel];

    _tertiaryTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _tertiaryTextLabel.font = [UIFont cellDetailTextFont];
    _tertiaryTextLabel.textColor = [UIColor secondaryTextColor];
    _tertiaryTextLabel.highlightedTextColor = [UIColor primaryTextColor];
    _tertiaryTextLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_tertiaryTextLabel];

    _preTextImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_preTextImageView];

    self.selectable = YES;

    _disclosureImageView = [[UIImageView alloc] initWithImage:[UIImage cellAccessoryDisclosureImage]];
    _highlightedDisclosureView = [[UIImageView alloc] initWithImage:[UIImage cellAccessoryDisclosureHighlightedImage]];
    UIView *aView = [UIView new];
    [aView addSubview:_disclosureImageView];
    [aView addSubview:_highlightedDisclosureView];
    aView.size = _disclosureImageView.size;
    self.accessoryView = aView;
}

- (CGFloat)_maxLabelWidth
{
    CGFloat margins = self.accessoryView.hidden ? SFTableCellContentInsetHorizontal : 2*SFTableCellContentInsetHorizontal;
    return floorf(self.contentView.width - margins);
}

@end
