//
//  SFPanopticCell.m
//  Congress
//
//  Created by Daniel Cloud on 3/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFPanopticCell.h"

@implementation SFPanopticCell

static CGFloat panelsOffset = 10.0f;
static CGFloat panelMarginVertical = 2.0f;
static CGFloat panelHeight = 66.0f;

@synthesize panels = _panels;
@synthesize panelsView = _panelsView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.textLabel.numberOfLines = 3;


        _panels = [NSMutableArray array];
        _panelsView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_panelsView];
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat pTop = self.textLabel.bottom;
    if (self.detailTextLabel) {
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
    CGFloat panelsWidth = self.contentView.width - 2*[self.class contentInsetHorizontal];
    if (self.accessoryView) {
        panelsWidth -= self.accessoryView.width;
    }
    _panelsView.top = pTop;
    _panelsView.left = [self.class contentInsetHorizontal];
    _panelsView.size = CGSizeMake(panelsWidth, prevPanel.bottom);

    
    self.contentView.height = self.cellHeight;
    self.backgroundView.height = self.cellHeight;
    self.height = self.cellHeight;
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

#pragma mark - SFPanopticCell

- (void)addPanelView:(UIView *)panelView
{
    [_panels addObject:panelView];
    panelView.left = 0.0f;
    [_panelsView addSubview:panelView];
}

#pragma mark - SFTableCell

- (CGFloat)cellHeight
{
    CGSize labelSize = [self labelSize:self.textLabel];
    CGSize detailLabelSpace = CGSizeMake(0.0f, 0.0f);
    if (self.detailTextLabel) {
        detailLabelSpace = [self labelSize:self.detailTextLabel];
        detailLabelSpace = CGSizeMake(detailLabelSpace.width, detailLabelSpace.height + [self.class detailTextLabelOffset]);
    }

    CGFloat panelsHeight = (_panels.count * panelHeight);

    CGFloat panelsGutter = (_panels.count-1.0f) < 0 ? 0 : panelMarginVertical * (_panels.count-1);

    CGFloat height = labelSize.height + detailLabelSpace.height;
    if (panelsHeight > 0) {
        height += panelsOffset + panelsHeight + panelsGutter;
    }
    height += 2 * [self.class contentInsetVertical];

    return height;
}

@end
