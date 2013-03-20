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

@synthesize backgroundImageView = _backgroundImageView;
@synthesize contentView = _contentView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bgImage = [UIImage calloutBoxBackgroundImage];
        _backgroundImageView = [[UIImageView alloc] initWithImage:_bgImage];
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_backgroundImageView];
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
    self.height = _contentView.height + self.topInset + self.bottomInset + _backgroundImageView.image.capInsets.bottom;
    self.width = _contentView.width + self.leftInset + self.rightInset;
    _backgroundImageView.frame = self.bounds;
}

- (void)addSubview:(UIView *)view
{
    if (![view isEqual:_contentView] && ![view isEqual:_backgroundImageView]) {
        [_contentView addSubview:view];
    }
    else{
        [super addSubview:view];
    }
}

- (CGSize)contentSize
{
    return self.contentView.size;
}

@end
