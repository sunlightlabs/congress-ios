//
//  SFTableCell.m
//  Congress
//
//  Created by Daniel Cloud on 3/7/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFTableCell.h"

@implementation SFTableCell

static CGFloat SFTableCellContentInsetHorizontal = 21.0f;
static CGFloat SFTableCellContentInsetVertical = 8.0f;
static CGFloat SFTableCellDetailTextLabelOffset = 6.0f;

+ (CGFloat)contentInsetHorizontal
{
    return SFTableCellContentInsetHorizontal;
}

+ (CGFloat)contentInsetVertical
{
    return SFTableCellContentInsetVertical;
}

+ (CGFloat)detailTextLabelOffset
{
    return SFTableCellDetailTextLabelOffset;
}

@synthesize cellStyle = _cellStyle;
@synthesize selectable = _selectable;
@synthesize preTextImageView = _preTextImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.opaque = YES;
        _cellStyle = style;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.clipsToBounds = YES;
        self.contentView.clipsToBounds = YES;

        self.textLabel.font = [UIFont cellTextFont];
        self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.textLabel.textColor = [UIColor primaryTextColor];
        
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundView.opaque = YES;
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundView.backgroundColor = [UIColor primaryBackgroundColor];

        self.textLabel.backgroundColor = self.backgroundView.backgroundColor;
        if (self.detailTextLabel) {
            self.detailTextLabel.font = [UIFont cellDetailTextFont];
            self.detailTextLabel.textColor = [UIColor primaryTextColor];
            self.detailTextLabel.backgroundColor = self.backgroundView.backgroundColor;
        }

        _preTextImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_preTextImageView];

        self.selectable = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.size = [self labelSize:self.textLabel];
    self.textLabel.top = [self.class contentInsetVertical];
    self.textLabel.left = [self.class contentInsetHorizontal];

    if (_preTextImageView.image) {
        [_preTextImageView sizeToFit];
        NSUInteger textLength = self.textLabel.text.length;
        NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithAttributedString:self.textLabel.attributedText];
        if (textString.length == 0) {
            textString = [[NSMutableAttributedString alloc] initWithString:self.textLabel.text];
        }
        _preTextImageView.left = self.textLabel.left;
        _preTextImageView.top = self.textLabel.top + 2.0f;
        NSMutableParagraphStyle *pStyle = [textString attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:NULL];
        CGFloat indentW = _preTextImageView.width + 2.0f;
        [pStyle setFirstLineHeadIndent:indentW];
        [textString addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, textLength)];
        self.textLabel.attributedText = textString;
        self.textLabel.width += indentW;
    }

    if (self.detailTextLabel) {
        self.detailTextLabel.textColor = [UIColor primaryTextColor];
        if (self.cellStyle == UITableViewCellStyleValue1 || self.cellStyle == UITableViewCellStyleValue2) {
            self.detailTextLabel.center = self.textLabel.center;
            self.detailTextLabel.right = self.contentView.right - [self.class contentInsetHorizontal];
        }
        else
        {
            self.detailTextLabel.top = self.textLabel.bottom + [self.class detailTextLabelOffset];
            self.detailTextLabel.left = [self.class contentInsetHorizontal];
        }
    }
    
    self.contentView.height = self.cellHeight;
    self.backgroundView.height = self.cellHeight;
    if (self.selectedBackgroundView) {
        self.selectedBackgroundView.height = self.cellHeight;
    }
    self.height = self.cellHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - SFTableCell

- (CGFloat)cellHeight
{
    CGSize labelSize = [self labelSize:self.textLabel];
    CGSize detailLabelSize = CGSizeMake(0.0f, 0.0f);
    if (self.detailTextLabel && !(self.cellStyle == UITableViewCellStyleValue1 || self.cellStyle == UITableViewCellStyleValue2)) {
        detailLabelSize = [self labelSize:self.detailTextLabel];
    }
    CGFloat height = labelSize.height + detailLabelSize.height + (2 * [self.class contentInsetVertical]);
    if (detailLabelSize.height > 0.0f) {
        height += [self.class detailTextLabelOffset];
    }

    return height;
}

- (CGSize)labelSize:(UILabel *)label
{
    CGFloat lineHeight = label.font.lineHeight * label.numberOfLines;
    CGSize labelArea = CGSizeMake(self.contentView.width - 2*[self.class contentInsetHorizontal], lineHeight);
    if (self.accessoryView) {
        labelArea = CGSizeMake(labelArea.width - self.accessoryView.width, lineHeight);
    }
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
        self.selectedBackgroundView.backgroundColor = [UIColor selectedBackgroundColor];
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage cellAccessoryDisclosureImage]];
    }
    else
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.selectedBackgroundView = nil;
        self.accessoryView = nil;
    }
}

@end
