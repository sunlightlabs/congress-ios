//
//  SFBillListView.m
//  Congress
//
//  Created by Daniel Cloud on 2/5/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillsSectionView.h"

@implementation SFBillsSectionView
{
    UIView *_contentViewHolder;
}

@synthesize overlayView = _overlayView;
@synthesize contentView;
@synthesize searchBar = _searchBar;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_searchBar];

        _contentViewHolder = [[UIView alloc] initWithFrame:CGRectZero];
        _contentViewHolder.autoresizingMask  = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_contentViewHolder];

        _overlayView = [[UIView alloc] initWithFrame:CGRectZero];
        _overlayView.backgroundColor = [UIColor blackColor];
        _overlayView.alpha = 0.7f;
        _overlayView.hidden = YES;
        [self addSubview:_overlayView];
    }
    return self;
}

- (void)layoutSubviews {
    CGSize size = self.bounds.size;

    [_searchBar sizeToFit];
    _searchBar.center = CGPointMake(size.width / 2, _searchBar.height / 2);

    _contentViewHolder.frame = CGRectMake(0.0f, _searchBar.bottom, size.width, (size.height - _searchBar.bottom));

    _overlayView.frame = _contentViewHolder.frame;
}

- (void)setContentView:(UITableView *)pContentView {
    for (UIView *subview in _contentViewHolder.subviews) {
        [subview removeFromSuperview];
    }
    [_contentViewHolder addSubview:pContentView];
    pContentView.frame = _contentViewHolder.bounds;
    [self bringSubviewToFront:_overlayView];
    [self layoutSubviews];
}

- (UIView *)contentView {
    return [_contentViewHolder.subviews firstObject];
}

@end
