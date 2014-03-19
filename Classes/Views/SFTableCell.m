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
CGFloat const SFTableCellContentInsetVertical = 14.0f;
CGFloat const SFTableCellDetailTextLabelOffset = 8.0f;
CGFloat const SFTableCellPreTextImageOffset = 16.0f;
CGFloat const SFTableCellAccessoryOffset = 24.0f;

@implementation SFTableCell
{
    UIImageView *_disclosureImageView;
    UIImageView *_highlightedDisclosureView;
    UIImageView *_cellHighlightImage;
}

static NSString *__defaultCellIdentifer;

+ (void)load {
    __defaultCellIdentifer = NSStringFromClass([self class]);
}

+ (NSString *)defaultCellIdentifer {
    return __defaultCellIdentifer;
}

+ (NSInteger)defaultCellStyle {
    return UITableViewCellStyleSubtitle;
}

@synthesize cellIdentifier = _cellIdentifier;
@synthesize cellData = _cellData;
@synthesize cellStyle = _cellStyle;
@synthesize selectable = _selectable;
@synthesize prominent = _prominent;
@synthesize decorativeHeaderLabel = _decorativeHeaderLabel;
@synthesize tertiaryTextLabel = _tertiaryTextLabel;
@synthesize preTextImageView = _preTextImageView;

#pragma mark - SFTableCell initializers

+ (instancetype)cellWithReuseIdentifier:(NSString *)reuseIdentifier {
    return [[SFTableCell alloc] initWithReuseIdentifier:reuseIdentifier];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    return [self initWithStyle:[[self class] defaultCellStyle] reuseIdentifier:reuseIdentifier];
}

+ (instancetype)cellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [[SFTableCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier];
}

+ (instancetype)cellWithData:(SFCellData *)data {
    SFTableCell *cell = [SFTableCell cellWithReuseIdentifier:[self defaultCellIdentifer]];
    [cell setCellData:data];
    return cell;
}

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:[[self class] defaultCellStyle] reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellStyle = [[self class] defaultCellStyle];
        [self _initialize];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.opaque = YES;
    CGSize accessorySize = self.accessoryView.frame.size;

    CGFloat maxHeight = (self.textLabel.numberOfLines > 0) ? (self.textLabel.numberOfLines * self.textLabel.font.lineHeight) : CGFLOAT_MAX;
    CGSize maxLabelSize = CGSizeMake([self _maxLabelWidth], maxHeight);
    CGSize labelSize = [self.textLabel.text sf_sizeWithFont:self.textLabel.font constrainedToSize:maxLabelSize];
    self.textLabel.size = CGSizeMake([self _maxLabelWidth], labelSize.height);
    self.textLabel.top = SFTableCellContentInsetVertical;
    self.textLabel.left = SFTableCellContentInsetHorizontal;

    if (_decorativeHeaderLabel.text) {
        _decorativeHeaderLabel.top = SFTableCellContentInsetVertical + 2;
        _decorativeHeaderLabel.left = SFTableCellContentInsetHorizontal;
        [_decorativeHeaderLabel sizeToFit];
        _decorativeHeaderLabel.width = [self _maxLabelWidth];
        self.textLabel.top += SFTableCellContentInsetVertical + 6;
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

    CGFloat rightOffset = ceilf(self.contentView.width - SFTableCellContentInsetHorizontal / 3.0f);
    if (self.detailTextLabel) {
        if (self.cellStyle == UITableViewCellStyleValue1 || self.cellStyle == UITableViewCellStyleValue2) {
            self.detailTextLabel.center = self.textLabel.center;
            self.detailTextLabel.right = rightOffset;
        }
        else {
            self.detailTextLabel.top = self.textLabel.bottom + SFTableCellDetailTextLabelOffset;
            self.detailTextLabel.left = SFTableCellContentInsetHorizontal;
        }
    }

    CGSize maxTerLabelSize = CGSizeMake([self _maxLabelWidth], (self.tertiaryTextLabel.numberOfLines * self.tertiaryTextLabel.font.lineHeight));
    CGSize terLabelSize = [self.tertiaryTextLabel.text sf_sizeWithFont:self.tertiaryTextLabel.font constrainedToSize:maxTerLabelSize];
    self.tertiaryTextLabel.size = terLabelSize;
    self.tertiaryTextLabel.top = self.textLabel.bottom + SFTableCellDetailTextLabelOffset;
    if (([self.tertiaryTextLabel.text length] > 0) && !(self.cellStyle == UITableViewCellStyleValue1 || self.cellStyle == UITableViewCellStyleValue2)) {
        self.tertiaryTextLabel.right = rightOffset;
    }

    if (self.height < self.cellHeight) self.height = ceilf(self.cellHeight);
    self.contentView.height = ceilf(self.cellHeight);

    CGFloat pTop = floorf(self.textLabel.bottom);
    if (self.detailTextLabel) {
        pTop = floorf(self.detailTextLabel.bottom);
    }

    _cellHighlightImage.top = 0;
    _cellHighlightImage.height = self.height - 1;

    if (self.accessoryView) {
        self.accessoryView.top =  (self.contentView.height - accessorySize.height) / 2;
        self.accessoryView.center = CGPointMake(self.accessoryView.center.x, (self.height) / 2);
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    if (self.backgroundView) {
        self.backgroundView.backgroundColor = [UIColor primaryBackgroundColor];
    }
    self.textLabel.opaque = YES;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.opaque = YES;
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    [self setProminent:NO];
    self.cellData = nil;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    _highlightedDisclosureView.hidden = !highlighted;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _highlightedDisclosureView.hidden = !selected;

    if (!selected) {
        for (UIView *subview in[self.contentView subviews]) {
            [subview setNeedsDisplay];
        }
    }

    // Hack to (attempt to) find the UITableViewCellEditControl via its superview, then making sure it is properly selected/deselected
    UIView *cellScrollView = [self.subviews firstObject];
    UIControl *cellEditControlView = nil;
    UIView *cellContentView = nil;

    for (id subview in cellScrollView.subviews) {
        NSString *className = NSStringFromClass([subview class]);
        if (!cellEditControlView && [className isEqualToString:@"UITableViewCellEditControl"]) {
            cellEditControlView = (UIControl *)subview;
        } else if (!cellContentView &&  [className isEqualToString:@"UITableViewCellContentView"]) {
            cellContentView = subview;
        }
    }

    if (cellEditControlView) {
        [cellEditControlView setSelected:selected];
    }

    if (selected && cellContentView && self.selectedBackgroundView.superview == nil) {
        [cellScrollView insertSubview:self.selectedBackgroundView belowSubview:cellContentView];
    }

}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (_prominent) {
        [_cellHighlightImage setHidden:editing];
    }
}

#pragma mark - SFTableCell

- (void)setCellData:(SFCellData *)data {
    _cellData = data;
    self.textLabel.font = _cellData.textLabelFont ? : self.textLabel.font;
    self.textLabel.textColor = _cellData.textLabelColor ? : self.textLabel.textColor;
    self.textLabel.numberOfLines = _cellData.textLabelNumberOfLines;
    self.textLabel.text = _cellData.textLabelString ? : @"";
    self.detailTextLabel.font = _cellData.detailTextLabelFont ? : self.detailTextLabel.font;
    self.detailTextLabel.textColor = _cellData.detailTextLabelColor ? : self.detailTextLabel.textColor;
    self.detailTextLabel.numberOfLines = _cellData.detailTextLabelNumberOfLines ? : 1;
    self.detailTextLabel.text = _cellData.detailTextLabelString ? : @"";
    self.tertiaryTextLabel.font = _cellData.tertiaryTextLabelFont ? : self.tertiaryTextLabel.font;
    self.tertiaryTextLabel.textColor = _cellData.tertiaryTextLabelColor ? : self.tertiaryTextLabel.textColor;
    self.tertiaryTextLabel.numberOfLines = _cellData.tertiaryTextLabelNumberOfLines ? : 1;
    self.tertiaryTextLabel.text = _cellData.tertiaryTextLabelString ? : @"";

    self.decorativeHeaderLabel.font = _cellData.decorativeHeaderLabelFont ? : self.decorativeHeaderLabel.font;
    self.decorativeHeaderLabel.textColor = _cellData.decorativeHeaderLabelColor ? : self.decorativeHeaderLabel.textColor;
    self.decorativeHeaderLabel.text = _cellData.decorativeHeaderLabelString ? : nil;
    self.decorativeHeaderLabel.numberOfLines = 1;

    if (_cellData.accessibilityLabel)
        [self setAccessibilityLabel:_cellData.accessibilityLabel];

    if (_cellData.accessibilityValue)
        [self setAccessibilityValue:_cellData.accessibilityValue];

    if (_cellData.accessibilityHint)
        [self setAccessibilityHint:_cellData.accessibilityHint];

    self.selectable = _cellData.selectable;
    [self setProminent:_cellData.persist];
}

- (CGFloat)cellHeight {
    return [_cellData heightForWidth:self.width];
}

- (void)setSelectable:(BOOL)pSelectable {
    _selectable = pSelectable;
    if (_selectable) {
        if (self.selectedBackgroundView) {
            [self.selectedBackgroundView setBackgroundColor:[UIColor selectedCellBackgroundColor]];
        }
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryView.hidden = NO;
    }
    else {
        if (self.selectedBackgroundView) {
            [self.selectedBackgroundView setBackgroundColor:[UIColor primaryBackgroundColor]];
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryView.hidden = YES;
    }
}

- (void)setProminent:(BOOL)prominent {
    _prominent = prominent;
    BOOL hideProminence = !_prominent;
    [_cellHighlightImage setHidden:hideProminence];
    [self.preTextImageView setHidden:hideProminence];
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
    self.textLabel.numberOfLines = 3;
    self.textLabel.textColor = [UIColor primaryTextColor];
    self.textLabel.highlightedTextColor = [UIColor primaryTextColor];

    self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundView.opaque = YES;
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundView.backgroundColor = [UIColor primaryBackgroundColor];

    self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.selectedBackgroundView.opaque = YES;
    self.selectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.selectedBackgroundView.backgroundColor = [UIColor selectedCellBackgroundColor];

    self.textLabel.backgroundColor = [UIColor clearColor];
    if (self.detailTextLabel) {
        self.detailTextLabel.font = [UIFont cellImportantDetailFont];
        self.detailTextLabel.textColor = [UIColor secondaryTextColor];
        self.detailTextLabel.highlightedTextColor = [UIColor secondaryTextColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
    }

    _decorativeHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _decorativeHeaderLabel.font = [UIFont cellSecondaryDetailFont];
    _decorativeHeaderLabel.textColor = [UIColor secondaryTextColor];
    _decorativeHeaderLabel.highlightedTextColor = [UIColor primaryTextColor];
    _decorativeHeaderLabel.backgroundColor = [UIColor clearColor];
    _decorativeHeaderLabel.numberOfLines = 1;
    _decorativeHeaderLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_decorativeHeaderLabel];

    _tertiaryTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _tertiaryTextLabel.font = [UIFont cellImportantDetailFont];
    _tertiaryTextLabel.textColor = [UIColor secondaryTextColor];
    _tertiaryTextLabel.highlightedTextColor = [UIColor primaryTextColor];
    _tertiaryTextLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_tertiaryTextLabel];

    _cellHighlightImage = [[UIImageView alloc] initWithImage:[UIImage followedCellBorderImage]];
    _cellHighlightImage.hidden = YES;
    [self.contentView addSubview:_cellHighlightImage];

    _preTextImageView = [[UIImageView alloc] initWithImage:[UIImage followedCellIcon]];
    [_preTextImageView setHidden:YES];
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

- (CGFloat)_maxLabelWidth {
    CGFloat margins = [self.accessoryView isHidden] ? SFTableCellContentInsetHorizontal : 2 * SFTableCellContentInsetHorizontal;
    return floorf(self.contentView.width - margins);
}

@end
