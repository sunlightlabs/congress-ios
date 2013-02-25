//
//  SFInsetView.m
//  Congress
//
//  Created by Daniel Cloud on 2/25/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFInsetsView.h"

@implementation SFInsetsView

@synthesize insets = _insets;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.insets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    }
    return self;
}

- (CGFloat)leftInset
{
    return self.insets.left;
}

- (void)setLeftInset:(CGFloat)leftInset
{
    UIEdgeInsets editInsets = self.insets;
    editInsets.left = leftInset;
    _insets = editInsets;
}

- (CGFloat)rightInset
{
    return self.insets.right;
}

- (void)setRightInset:(CGFloat)rightInset
{
    UIEdgeInsets editInsets = self.insets;
    editInsets.right = rightInset;
    _insets = editInsets;
}

- (CGFloat)topInset
{
    return self.insets.top;
}

- (void)setTopInset:(CGFloat)topInset
{
    UIEdgeInsets editInsets = self.insets;
    editInsets.top = topInset;
    _insets = editInsets;
}

- (CGFloat)bottomInset
{
    return self.insets.bottom;
}

- (void)setBottomInset:(CGFloat)bottomInset
{
    UIEdgeInsets editInsets = self.insets;
    editInsets.bottom = bottomInset;
    _insets = editInsets;
}

- (CGFloat)insetsWidth
{
    return self.insetsRect.size.width;
}

- (CGRect)insetsRect
{
    return UIEdgeInsetsInsetRect(self.frame, self.insets);
}

- (CGRect)frameThatFitsInInsets:(UIView *)view
{
    return UIEdgeInsetsInsetRect(view.frame, self.insets);
}

@end
