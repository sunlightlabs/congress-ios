//
//  SFContentView.m
//  Congress
//
//  Created by Jeremy Carbaugh on 10/18/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFContentView.h"

@implementation SFContentView

static CGFloat const DefaultContentInsetDistance = 16.0f;

@synthesize constraints = _constraints;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor primaryBackgroundColor];
        self.opaque = YES;
        self.contentInset = UIEdgeInsetsMake(DefaultContentInsetDistance, DefaultContentInsetDistance, DefaultContentInsetDistance, DefaultContentInsetDistance);
        self.constraints = [NSMutableArray array];
    }
    return self;
}

#pragma mark - contentInset

- (void)setInsetForAllEdges:(CGFloat)insetValue
{
    self.contentInset = UIEdgeInsetsMake(insetValue, insetValue, insetValue, insetValue);
}

- (CGRect)insetRectForRect:(CGRect)rect
{
    return UIEdgeInsetsInsetRect(rect, self.contentInset);
}

- (CGFloat)insetWidthForRect:(CGRect)rect
{
    CGRect r = [self insetRectForRect:rect];
    return r.size.width;
}

- (CGFloat)insetHeightForRect:(CGRect)rect;
{
    CGRect r = [self insetRectForRect:rect];
    return r.size.height;
}

#pragma mark - Constraints

- (void)updateConstraints
{
    [self removeConstraints:_constraints];
    [_constraints removeAllObjects];
    
    [self updateContentConstraints];
    
    [self addConstraints:_constraints];
    [super updateConstraints];
}

- (void)updateContentConstraints
{
    // something, something, something
}

@end
