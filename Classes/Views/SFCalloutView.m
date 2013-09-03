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
        _contentView.clipsToBounds = NO;
        [self addSubview:_backgroundImageView];
        [self addSubview:_contentView];
        self.insets = UIEdgeInsetsMake(9.0f, 16.0f, 14.0f, 10.0f);
    }
    return self;
}

- (void)layoutSubviews
{
    NSLog(@"----> [SFCalloutView] layoutSubviews:");
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

- (void)updateConstraints {
    NSLog(@"----> [SFCalloutView] updateConstraints:");
    [super updateConstraints];
}

- (CGSize)contentSize
{
    NSLog(@"----> [SFCalloutView] contentSize:");
    return self.contentView.size;
}

//- (CGSize)sizeThatFits:(CGSize)size
//{
//    CGRect frame = self.insetsRect;
//    CGFloat bottom = 0;
//    for (UIView *view in _contentView.subviews) {
//        bottom = MAX(bottom, view.bottom);
//    }
//    CGFloat height = bottom + self.topInset + self.bottomInset + _backgroundImageView.image.capInsets.bottom;
//    CGFloat width = frame.size.width + self.leftInset + self.rightInset;
//    return CGSizeMake(MIN(width, size.width), MIN(height, size.height));
//}

//- (CGSize)intrinsicContentSize
//{
//    return [self contentSize];
//}

//- (CGSize)intrinsicContentSize
//{
//    return [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
//}

//- (CGSize)intrinsicContentSize
//{
//    [super layoutSubviews];
//    CGFloat bottom = 0;
//    for (UIView *view in _contentView.subviews) {
//        bottom = MAX(bottom, view.bottom);
//    }
//    return CGSizeMake(320.0, bottom);
//}

@end
