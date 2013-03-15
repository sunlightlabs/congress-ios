//
//  SFTableCell.m
//  Congress
//
//  Created by Daniel Cloud on 3/7/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFTableCell.h"

@implementation SFTableCell

static CGFloat SFTableCellContentInsetHorizontal = 10.0f;
static CGFloat SFTableCellContentInsetVertical = 6.0f;
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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.opaque = YES;
        _cellStyle = style;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.size = [self labelSize:self.textLabel];
    self.textLabel.top = [self.class contentInsetVertical];
    self.textLabel.left = [self.class contentInsetHorizontal];

    CGFloat bottom = self.textLabel.bottom;
    if (self.detailTextLabel) {
        self.detailTextLabel.textColor = [UIColor primaryTextColor];
        self.detailTextLabel.backgroundColor = self.backgroundView.backgroundColor;
        if (self.cellStyle == UITableViewCellStyleValue1 || self.cellStyle == UITableViewCellStyleValue2) {
            self.detailTextLabel.center = self.textLabel.center;
            self.detailTextLabel.right = self.contentView.right - [self.class contentInsetHorizontal];
        }
        else
        {
            self.detailTextLabel.top = self.textLabel.bottom + [self.class detailTextLabelOffset];
        }
        bottom = self.detailTextLabel.bottom;
    }
    
    self.contentView.height = bottom + [self.class contentInsetVertical];
    self.backgroundView.height = self.contentView.height;
    self.height = self.contentView.height;

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
    CGSize detailLabelSpace = CGSizeMake(0.0f, 0.0f);
    if (self.detailTextLabel && !(self.cellStyle == UITableViewCellStyleValue1 || self.cellStyle == UITableViewCellStyleValue2)) {
        detailLabelSpace = [self labelSize:self.detailTextLabel];
        detailLabelSpace = CGSizeMake(detailLabelSpace.width, detailLabelSpace.height + [self.class detailTextLabelOffset]);
    }
    CGFloat height = labelSize.height + detailLabelSpace.height + (2 * [self.class contentInsetVertical]);

    return height;
}

- (CGSize)labelSize:(UILabel *)label
{
    CGFloat lineHeight = label.font.lineHeight * label.numberOfLines;
    return [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(self.contentView.width - 2*[self.class contentInsetHorizontal], lineHeight) lineBreakMode:self.textLabel.lineBreakMode];
}

@end
