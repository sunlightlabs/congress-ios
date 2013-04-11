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
CGFloat const SFTableCellAccessoryOffset = 20.0f;


@implementation SFTableCell

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
@synthesize preTextImageView = _preTextImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.opaque = YES;
        _cellIdentifier = NSStringFromClass([self class]);
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
    self.textLabel.top = SFTableCellContentInsetVertical;
    self.textLabel.left = SFTableCellContentInsetHorizontal;

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
        [pStyle setFirstLineHeadIndent:SFTableCellPreTextImageOffset];
        [textString addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, textLength)];
        self.textLabel.attributedText = textString;
        self.textLabel.width += SFTableCellPreTextImageOffset;
    }

    if (self.detailTextLabel) {
        self.detailTextLabel.textColor = [UIColor primaryTextColor];
        if (self.cellStyle == UITableViewCellStyleValue1 || self.cellStyle == UITableViewCellStyleValue2) {
            self.detailTextLabel.center = self.textLabel.center;
            self.detailTextLabel.right = self.contentView.right - SFTableCellContentInsetHorizontal;
        }
        else
        {
            self.detailTextLabel.top = self.textLabel.bottom + SFTableCellDetailTextLabelOffset;
            self.detailTextLabel.left = SFTableCellContentInsetHorizontal;
        }
    }
    if (self.height < self.cellHeight) self.height = self.cellHeight;
    self.contentView.height = self.cellHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - SFTableCell

- (void)setCellData:(SFCellData *)data
{
    _cellData = data;
    self.cellIdentifier = _cellData.cellIdentifier;
    self.textLabel.font = _cellData.textLabelFont;
    self.textLabel.textColor = _cellData.textLabelColor;
    self.textLabel.numberOfLines = _cellData.textLabelNumberOfLines;
    self.textLabel.text = _cellData.textLabelString;
    self.detailTextLabel.font = _cellData.detailTextLabelFont;
    self.detailTextLabel.textColor = _cellData.detailTextLabelColor;
    self.detailTextLabel.numberOfLines = _cellData.detailTextLabelNumberOfLines;
    self.detailTextLabel.text = _cellData.detailTextLabelString;
    self.selectable = _cellData.selectable;
}

- (CGFloat)cellHeight
{
    return [_cellData heightForWidth:self.width];
}

- (CGSize)labelSize:(UILabel *)label
{
    CGFloat lineHeight = label.font.lineHeight * label.numberOfLines;
    CGSize labelArea = CGSizeMake(self.contentView.width - 2*SFTableCellContentInsetHorizontal, lineHeight);
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
