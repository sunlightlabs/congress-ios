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
    UIImageView *_panelDividerImage;
    UIImageView *_panelBorderImage;
    UIImageView *_cellBorderImage;
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    if (!selected) {
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

    CGFloat pTop = self.textLabel.bottom;
    if (self.detailTextLabel) {
        pTop = self.detailTextLabel.bottom;
    }

    NSInteger panelCount = [_panels count];
    if ([_panels count] > 0) {
        pTop += SFOpticViewsOffset;
    }
    SFOpticView *prevPanel = nil;
    for (SFOpticView *panel in _panels)
    {
        CGFloat top = prevPanel ? prevPanel.bottom : 0.0f;
        panel.frame = CGRectMake(0.0f, top, _panelsView.width, SFOpticViewHeight);
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
    CGFloat panelsWidth = self.contentView.width - 2*SFTableCellContentInsetHorizontal;
    if (self.accessoryView) {
        panelsWidth -= self.accessoryView.width;
    }
    _panelsView.top = pTop;
    _panelsView.left = 0;
    _panelsView.size = CGSizeMake(self.width, prevPanel.bottom);

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
    self.textLabel.backgroundColor = self.backgroundView.backgroundColor;
    self.detailTextLabel.opaque = YES;
    self.detailTextLabel.backgroundColor = self.backgroundView.backgroundColor;
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
