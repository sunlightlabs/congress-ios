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
CGFloat const SFOpticViewsOffset = 8.0f;
CGFloat const SFOpticViewMarginVertical = 2.0f;

@implementation SFPanopticCell
{
    UIImageView *_panelHighlightImage;
    UIImageView *_cellHighlightImage;
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

        _cellHighlightImage = [[UIImageView alloc] initWithImage:[UIImage followedCellBorderImage]];
        _cellHighlightImage.hidden = YES;
        _panelHighlightImage = [[UIImageView alloc] initWithImage:[UIImage followedPanelBorderImage]];
        _panelHighlightImage.hidden = YES;

        _panels = [NSMutableArray array];
        _panelsView = [[UIView alloc] initWithFrame:CGRectZero];
        _panelsView.opaque = YES;
        [self.contentView addSubview:_panelsView];
        [self.contentView addSubview:_panelHighlightImage];
        [self.contentView addSubview:_cellHighlightImage];

        _tabUnselectedImage = [[UIImageView alloc] initWithImage:[UIImage followedCellTabImage]];
        [self.contentView addSubview:_tabUnselectedImage];
        _tabSelectedImage = [[UIImageView alloc] initWithImage:[UIImage followedCellSelectedTabImage]];
        [self.contentView addSubview:_tabSelectedImage];
        _tabSelectedImage.hidden = YES;
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
    _tabSelectedImage.hidden = !selected;
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

    CGFloat pTop = floorf(self.textLabel.bottom);
    if (self.detailTextLabel) {
        pTop = floorf(self.detailTextLabel.bottom);
    }

    _panelsView.width = self.width;
    _panelsView.left = 0;
    if ([[UIDevice currentDevice] systemMajorVersion] > 6) {
        _panelsView.width -= self.separatorInset.left;
        _panelsView.left += self.separatorInset.left;
    }
    NSUInteger panelsCount = [_panels count];
    if (panelsCount > 0) {
        pTop += SFOpticViewsOffset;
        if ([[UIDevice currentDevice] systemMajorVersion] < 7) {
            pTop += 1.0f;
        }
    }
    SFOpticView *prevPanel = nil;
    NSInteger panelNum = 0;
    for (SFOpticView *panel in _panels)
    {
        CGFloat top = prevPanel ? prevPanel.bottom : 0.0f;
        CGRect aRect = [self convertRect:self.textLabel.frame toView:_panelsView];
        panel.contentInsets = UIEdgeInsetsMake(panel.contentInsets.top, aRect.origin.x, panel.contentInsets.bottom, (self.width-self.textLabel.right));
        panel.frame = CGRectMake(0.0f, top, _panelsView.width, SFOpticViewHeight);
        panel.backgroundColor = [UIColor secondaryBackgroundColor];

        prevPanel = panel;
        if (panelNum > 0) {
            SSLineView *line = [self _dividerLine];
            line.width = _panelsView.width;
            line.left = self.width - _panelsView.width;
            line.top = top;
            [_panelsView addSubview:line];
        }
        panelNum++;
    }

    _panelsView.top = pTop;
    _panelsView.height = prevPanel != nil ? prevPanel.bottom : 0.0f;

    _panelHighlightImage.top = _panelsView.top;
    _panelHighlightImage.height = _panelsView.height;
    _cellHighlightImage.top = 0;
    CGFloat highlightReduce = _panelsView.height > 0 ? _panelsView.height : 1.0f;
    _cellHighlightImage.height = self.height - highlightReduce;

    if (panelsCount > 0) {
        [self.contentView insertSubview:_tabSelectedImage aboveSubview:_panelsView];
        [self.contentView insertSubview:_tabUnselectedImage aboveSubview:_panelsView];
        _tabSelectedImage.top = _panelsView.top;
        CGFloat tabCenterX =_panelsView.left+self.textLabel.left+1;
        _tabSelectedImage.center = CGPointMake(tabCenterX, _tabSelectedImage.center.y);
        _tabSelectedImage.hidden = !(self.selected || self.highlighted);
        _tabUnselectedImage.top = _tabSelectedImage.top;
        _tabUnselectedImage.left = _tabSelectedImage.left;
        _tabUnselectedImage.hidden = !_tabSelectedImage.hidden;
        _tabLine.top = _tabSelectedImage.top;
        _tabLine.left = self.width - _panelsView.width;
        _tabLine.width = _panelsView.width;
        [self.contentView insertSubview:_tabLine belowSubview:_tabUnselectedImage];
    }
    else {
        [_tabSelectedImage removeFromSuperview];
        [_tabUnselectedImage removeFromSuperview];
        [_tabLine removeFromSuperview];
    }

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
        [_panelsView addSubview:_panelHighlightImage];
        _panels = [NSMutableArray array];
        _panelsView.height = 0.0f;
        _cellHighlightImage.hidden = YES;
        _panelHighlightImage.hidden = YES;
    }
    self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.backgroundView.backgroundColor = [UIColor primaryBackgroundColor];
    self.textLabel.opaque = YES;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.opaque = YES;
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    [self.imageView setImage:nil];
    [self.preTextImageView setImage:nil];
    self.cellData = nil;
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
        _cellHighlightImage.hidden = NO;
        [self.preTextImageView setImage:[UIImage followedCellIcon]];
        _panelHighlightImage.hidden = NO;
        _panelHighlightImage.height = _panelsView.height;
    }
    else
    {
        _cellHighlightImage.hidden = YES;
        [self.preTextImageView setImage:nil];
        _panelHighlightImage.hidden = YES;
        _panelHighlightImage.height = _panelsView.height;
    }
}

@end
