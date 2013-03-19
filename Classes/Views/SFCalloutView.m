//
//  SFCalloutView.m
//  Congress
//
//  Created by Daniel Cloud on 3/19/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCalloutView.h"

@implementation SFCalloutView
{
    UIImage *_bgImage;
}

@synthesize backgroundView = _backgroundView;
@synthesize contentView = _contentView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bgImage = [UIImage calloutBoxBackgroundImage];
        _backgroundView = [[UIImageView alloc] initWithImage:_bgImage];
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_backgroundView];
        [self addSubview:_contentView];
        self.insets = UIEdgeInsetsMake(9.0f, 16.0f, 14.0f, 10.0f);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_contentView layoutSubviews];
    _contentView.frame = self.insetsRect;
    CGFloat bottom = 0;
    for (UIView *view in _contentView.subviews) {
        bottom = MAX(bottom, view.bottom);
    }
    _contentView.height = bottom;
    self.height = _contentView.height + self.topInset + self.bottomInset;
    self.width = _contentView.width + self.leftInset + self.rightInset;
    _backgroundView.frame = self.bounds;
}

- (void)addSubview:(UIView *)view
{
    if (![view isEqual:_contentView] && ![view isEqual:_backgroundView]) {
        [_contentView addSubview:view];
    }
    else{
        [super addSubview:view];
    }
}

@end
