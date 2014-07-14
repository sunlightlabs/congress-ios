//
//  SFLineView.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/14/14.
//  Copyright (c) 2014 Sunlight Foundation. All rights reserved.
//

#import "SFLineView.h"

@interface SFLineView ()

@property(nonatomic, assign) BOOL horizontal;

@end

@implementation SFLineView

@synthesize lineColor = _lineColor;
@synthesize horizontal = _horizontal;

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self _initialize];
    }
    return self;
}

- (void)_initialize {
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.lineColor = [UIColor grayColor];
    self.horizontal = self.frame.size.width >= self.frame.size.height;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToRect(context, rect);
    CGContextSetLineWidth(context, 2.0f);
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    CGContextMoveToPoint(context, 0.0f, 0.0f);
    if (_horizontal) {
        CGContextAddLineToPoint(context, rect.size.width, 0.0f);
    } else {
        CGContextAddLineToPoint(context, 0.0f, rect.size.height);
    }
    CGContextStrokePath(context);
}

@end
