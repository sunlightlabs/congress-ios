//
//  SFPanopticCell.m
//  Congress
//
//  Created by Daniel Cloud on 3/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFPanopticCell.h"

@implementation SFPanopticCell

static CGFloat contentInsetHorizontal = 10.0f;
static CGFloat contentInsetVertical = 6.0f;
static CGFloat panelsOffset = 10.0f;
static CGFloat detailTextLabelOffset = 6.0f;
static CGFloat panelMarginVertical = 2.0f;
static CGFloat panelHeight = 66.0f;

@synthesize panels = _panels;
@synthesize panelsView = _panelsView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.opaque = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.clipsToBounds = YES;
        self.contentView.clipsToBounds = YES;

        self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.textLabel.numberOfLines = 3;

        _panels = [NSMutableArray array];
        _panelsView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_panelsView];

        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundView.opaque = YES;
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundView.backgroundColor = [UIColor primaryBackgroundColor];
        self.textLabel.backgroundColor = self.backgroundView.backgroundColor;
        if (self.detailTextLabel) {
            self.detailTextLabel.backgroundColor = self.backgroundView.backgroundColor;
        }
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.size = [self _labelSize:self.textLabel];
    self.textLabel.top = contentInsetVertical;
    self.textLabel.left = contentInsetHorizontal;

    CGFloat pTop = self.textLabel.bottom;
    if (self.detailTextLabel) {
        self.detailTextLabel.top = self.textLabel.bottom + detailTextLabelOffset;
        pTop = self.detailTextLabel.bottom;
    }

    if ([_panels count] > 0) {
        pTop += panelsOffset;
    }
    UIView *prevPanel = nil;
    for (UIView *panel in _panels)
    {
        CGFloat top = prevPanel ? prevPanel.bottom + panelMarginVertical : 0.0f;
        panel.frame = CGRectMake(0.0f, top, _panelsView.width, panelHeight);
        prevPanel = panel;
    }
    CGFloat panelsWidth = self.contentView.width - 2*contentInsetHorizontal;
    _panelsView.top = pTop;
    _panelsView.left = contentInsetHorizontal;
    _panelsView.size = CGSizeMake(panelsWidth, prevPanel.bottom);

    
    self.contentView.height = _panelsView.bottom + contentInsetVertical;
    self.backgroundView.height = self.contentView.height;
    self.height = self.contentView.height;
}

- (void)prepareForReuse
{
    if (_panelsView) {
        for (UIView *panel in _panelsView.subviews) {
            [panel removeFromSuperview];
        }
        _panels = [NSMutableArray array];
        _panelsView.height = 0.0f;
    }
}

#pragma mark - SFSuperCell

- (void)addPanelView:(UIView *)panelView
{
    [_panels addObject:panelView];
    panelView.left = 0.0f;
    [_panelsView addSubview:panelView];
}

- (CGFloat)cellHeight
{
    CGSize labelSize = [self _labelSize:self.textLabel];
    CGSize detailLabelSpace = CGSizeMake(0.0f, 0.0f);
    if (self.detailTextLabel) {
        detailLabelSpace = [self _labelSize:self.detailTextLabel];
        detailLabelSpace = CGSizeMake(detailLabelSpace.width, detailLabelSpace.height + detailTextLabelOffset);
    }

    CGFloat panelsHeight = (_panels.count * panelHeight);

    CGFloat panelsGutter = (_panels.count-1.0f) < 0 ? 0 : panelMarginVertical * (_panels.count-1);

    CGFloat height = labelSize.height + detailLabelSpace.height;
    if (panelsHeight > 0) {
        height += panelsOffset + panelsHeight + panelsGutter;
    }
    height += 2 * contentInsetVertical;

    return height;
}

- (CGSize)_labelSize:(UILabel *)label
{
    CGFloat lineHeight = label.font.lineHeight * label.numberOfLines;
    return [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(self.contentView.width - 2*contentInsetHorizontal, lineHeight) lineBreakMode:self.textLabel.lineBreakMode];
}


@end
