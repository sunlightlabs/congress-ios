//
//  SFPanopticCell.m
//  Congress
//
//  Created by Daniel Cloud on 3/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFPanopticCell.h"

@implementation SFPanopticCell
{
    UIImageView *_panelDividerImage;
    UIImageView *_panelBorderImage;
    UIImageView *_cellBorderImage;
}

static CGFloat panelsOffset = 10.0f;
static CGFloat panelMarginVertical = 2.0f;
static CGFloat panelHeight = 52.0f; // Size that fits 2 lines of 13pt Helvetica text inside the SFOpticView text frame...

@synthesize panels = _panels;
@synthesize panelsView = _panelsView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.textLabel.numberOfLines = 3;

        _cellBorderImage = [[UIImageView alloc] initWithImage:[UIImage favoritedCellBorderImage]];
        [self addSubview:_cellBorderImage];
        _cellBorderImage.hidden = YES;
        _cellBorderImage.opaque = YES;

        _panels = [NSMutableArray array];
        _panelsView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_panelsView];
        _panelBorderImage = [[UIImageView alloc] initWithImage:[UIImage favoritedPanelBorderImage]];
        _panelBorderImage.hidden = YES;
        _panelBorderImage.opaque = YES;
        [_panelsView addSubview:_panelBorderImage];
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

    NSInteger panelCount = [_panels count];
    if ([_panels count] > 0) {
        pTop += panelsOffset;
    }
    UIView *prevPanel = nil;
    for (UIView *panel in _panels)
    {
        CGFloat top = prevPanel ? prevPanel.bottom + panelMarginVertical : 0.0f;
        panel.frame = CGRectMake(0.0f, top, _panelsView.width, panelHeight);
        prevPanel = panel;
        SSLineView *line = [self _dividerLine];
        line.width = self.width;
        line.top = top;
        [_panelsView addSubview:line];
    }
    if (panelCount > 0) {
        UIImageView *tabImage = [[UIImageView alloc] initWithImage:[UIImage favoritedCellTabImage]];
        tabImage.left = 11.0f;
        [_panelsView addSubview:tabImage];
    }
    CGFloat panelsWidth = self.contentView.width - 2*[self.class contentInsetHorizontal];
    if (self.accessoryView) {
        panelsWidth -= self.accessoryView.width;
    }
    _panelsView.top = pTop;
    _panelsView.left = 0;
    _panelsView.size = CGSizeMake(self.width, prevPanel.bottom);

    
    self.contentView.height = self.cellHeight;
    self.backgroundView.height = self.cellHeight;
    self.height = self.cellHeight;
    
    _panelBorderImage.height = _panelsView.height;
    [_panelsView bringSubviewToFront:_panelBorderImage];
    _cellBorderImage.height = self.cellHeight - _panelsView.height;
    
    if (self.accessoryView) {
        self.accessoryView.center = CGPointMake(self.accessoryView.center.x, (self.cellHeight-_panelsView.height)/2);
    }
}

- (void)prepareForReuse
{
    if (_panelsView) {
        for (UIView *panel in _panelsView.subviews) {
            [panel removeFromSuperview];
        }
        [_panelsView addSubview:_panelBorderImage];
        _panels = [NSMutableArray array];
        _panelsView.height = 0.0f;
        _cellBorderImage.hidden = YES;
        _panelBorderImage.hidden = YES;
    }
}

#pragma mark - SFPanopticCell

- (void)addPanelView:(UIView *)panelView
{
    [_panels addObject:panelView];
    panelView.left = 0.0f;
    [_panelsView addSubview:panelView];
}

- (SSLineView *)_dividerLine
{
    SSLineView *view = [[SSLineView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1.0f)];
    view.lineColor = [UIColor tableSeparatorColor];
    return view;
}

#pragma mark - SFTableCell

- (CGFloat)cellHeight
{
    CGSize labelSize = [self labelSize:self.textLabel];
    CGSize detailLabelSpace = CGSizeMake(0.0f, 0.0f);
    if (self.detailTextLabel)
    {
        detailLabelSpace = [self labelSize:self.detailTextLabel];
        detailLabelSpace = CGSizeMake(detailLabelSpace.width, detailLabelSpace.height + [self.class detailTextLabelOffset]);
    }

    CGFloat panelsHeight = (_panels.count * panelHeight);

    CGFloat panelsGutter = (_panels.count-1.0f) < 0 ? 0 : panelMarginVertical * (_panels.count-1);

    CGFloat height = labelSize.height + detailLabelSpace.height;
    if (panelsHeight > 0)
    {
        height += panelsOffset + panelsHeight + panelsGutter;
    }
    else
    {
        height += [self.class contentInsetVertical];
    }
    height += [self.class contentInsetVertical];


    return height;
}

- (void)setPersistStyle
{
    _cellBorderImage.hidden = NO;
    [self.preTextImageView setImage:[UIImage favoritedCellIcon]];
    _panelBorderImage.hidden = NO;
    _panelBorderImage.height = _panelsView.height;
}

@end
