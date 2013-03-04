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
static CGFloat panelMarginHorizontal = 2.0f;

@synthesize panels = _panels;
@synthesize panelsView = _panelsView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.opaque = YES;
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
        CGFloat top = prevPanel ? prevPanel.bottom + panelMarginHorizontal : 0.0f;
        panel.frame = CGRectMake(0.0f, top, _panelsView.width, panel.height);
        prevPanel = panel;
    }
    CGFloat panelsWidth = self.contentView.width - 2*contentInsetHorizontal;
    _panelsView.top = pTop;
    _panelsView.left = contentInsetHorizontal;
    _panelsView.size = CGSizeMake(panelsWidth, prevPanel.bottom);

    
    self.contentView.height = _panelsView.bottom + contentInsetVertical;
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

    CGFloat panelsHeight = (_panels.count * 80.0f);

    CGFloat panelsGutter = (_panels.count-1.0f) <= 0 ? 0 : 2.0f * (_panels.count-1);

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
