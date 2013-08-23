//
//  SFPanopticCell.m
//  Congress
//
//  Created by Daniel Cloud on 3/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFPanopticCell.h"
#import "SFOpticView.h"
#import "SFCellData.h"

CGFloat const SFOpticViewHeight = 52.0f; // Size that fits 2 lines of 13pt Helvetica text inside the SFOpticView text frame...
CGFloat const SFOpticViewsOffset = 10.0f;
CGFloat const SFOpticViewMarginVertical = 2.0f;

@implementation SFPanopticCell
{
    UIImageView *_panelBorderImage;
    UIImageView *_cellBorderImage;
    UIImageView *_tabSelectedImage;
    UIImageView *_tabUnselectedImage;
    SSLineView *_tabLine;
}


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

        _panels = [NSMutableArray array];
        _panelsView = [[UIView alloc] initWithFrame:CGRectZero];
        _panelsView.opaque = YES;
        [self.contentView addSubview:_panelsView];
        _panelBorderImage = [[UIImageView alloc] initWithImage:[UIImage favoritedPanelBorderImage]];
        _panelBorderImage.hidden = YES;
        [_panelsView addSubview:_panelBorderImage];

        _tabUnselectedImage = [[UIImageView alloc] initWithImage:[UIImage favoritedCellTabImage]];
        [self.contentView addSubview:_tabUnselectedImage];
        _tabSelectedImage = [[UIImageView alloc] initWithImage:[UIImage favoritedCellSelectedTabImage]];
        [self.contentView addSubview:_tabSelectedImage];
        _tabLine = [SSLineView new];
        _tabLine.lineColor = [UIColor tableSeparatorColor];
        _tabLine.height = 1.0f;
        [self.contentView addSubview:_tabLine];
    }

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (!selected)
    {
        [self setPersistStyle:self.cellData.persist];
        for (UIView *subview in [self.contentView subviews])
        {
            [subview setNeedsDisplay];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.opaque = YES;

    CGFloat pTop = self.textLabel.bottom;
    if (self.detailTextLabel) {
        pTop = self.detailTextLabel.bottom;
    }

    _panelsView.width = self.width;
    NSUInteger panelsCount = [_panels count];
    if (panelsCount > 0) {
        pTop += SFOpticViewsOffset;
    }
    SFOpticView *prevPanel = nil;
    NSInteger panelNum = 0;
    for (SFOpticView *panel in _panels)
    {
        CGFloat top = prevPanel ? prevPanel.bottom : 0.0f;
        panel.frame = CGRectMake(0.0f, top, _panelsView.width, SFOpticViewHeight);
        panel.backgroundColor = [UIColor secondaryBackgroundColor];

        prevPanel = panel;
        if (panelNum > 0) {
            SSLineView *line = [self _dividerLine];
            line.width = self.width;
            line.top = top;
            [_panelsView addSubview:line];
        }
        panelNum++;
    }

    _panelsView.top = pTop;
    _panelsView.left = 0;
    _panelsView.height = prevPanel.bottom;
    [self.contentView bringSubviewToFront:_panelsView];

    _panelBorderImage.height = _panelsView.height;
    [_panelsView bringSubviewToFront:_panelBorderImage];
    _cellBorderImage.height = self.cellHeight - _panelsView.height;
    if (self.highlighted || self.selected) {
        [self.contentView bringSubviewToFront:_tabSelectedImage];
        [self.contentView sendSubviewToBack:_tabUnselectedImage];
    }
    else
    {
        [self.contentView bringSubviewToFront:_tabUnselectedImage];
        [self.contentView sendSubviewToBack:_tabSelectedImage];
    }

    _tabSelectedImage.top = _panelsView.top;
    _tabSelectedImage.left = 11.0f;
    _tabSelectedImage.hidden = (panelsCount > 0) ? NO : YES;
    _tabUnselectedImage.top = _tabSelectedImage.top;
    _tabUnselectedImage.left = _tabSelectedImage.left;
    _tabUnselectedImage.hidden = _tabSelectedImage.hidden;
    _tabLine.top = _tabSelectedImage.top;
    _tabLine.left = 0.0f;
    _tabLine.width = self.width;
    _tabLine.hidden = _tabUnselectedImage.hidden;
    [self.contentView insertSubview:_tabLine belowSubview:_tabUnselectedImage];

    if (self.accessoryView) {
        self.accessoryView.center = CGPointMake(self.accessoryView.center.x, (self.height-_panelsView.height)/2);
    }
}

- (void)prepareForReuse
{
    if (_panelsView) {
        for (SFOpticView *panel in _panelsView.subviews) {
            [panel removeFromSuperview];
        }
        [_panelsView addSubview:_panelBorderImage];
        _panels = [NSMutableArray array];
        _panelsView.height = 0.0f;
        _cellBorderImage.hidden = YES;
        _panelBorderImage.hidden = YES;
    }
    self.textLabel.textColor = [UIColor primaryTextColor];
    self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.backgroundView.backgroundColor = [UIColor primaryBackgroundColor];
    self.textLabel.opaque = YES;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.opaque = YES;
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    [self.imageView setImage:nil];
    [self.preTextImageView setImage:nil];
}

#pragma mark - SFPanopticCell

- (void)addPanelView:(SFOpticView *)panelView
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

- (void)setCellData:(SFCellData *)data
{
    [super setCellData:data];

    if (data.extraData && [data.extraData valueForKey:@"opticViews"]) {
        NSArray *opticViews = [data.extraData valueForKey:@"opticViews"];
        for (SFOpticView *view in opticViews) {
            [self addPanelView:view];
        }
    }
    [self setPersistStyle:data.persist];
}

- (void)setPersistStyle:(BOOL)persist
{
    if (persist)
    {
        _cellBorderImage.hidden = NO;
        [self.preTextImageView setImage:[UIImage favoritedCellIcon]];
        _panelBorderImage.hidden = NO;
        _panelBorderImage.height = _panelsView.height;
    }
    else
    {
        _cellBorderImage.hidden = YES;
        [self.preTextImageView setImage:nil];
        _panelBorderImage.hidden = YES;
        _panelBorderImage.height = _panelsView.height;
    }
}

@end
