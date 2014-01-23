//
//  UIView+ViewGeometryAdditions.m
//  Congress
//
//  Created by Daniel Cloud on 2/25/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "UIView+ViewGeometryAdditions.h"

@implementation UIView (ViewGeometryAdditions)

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect editFrame = self.frame;
    editFrame.origin = origin;
    self.frame = editFrame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect editFrame = self.frame;
    editFrame.size = size;
    self.frame = editFrame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect editFrame = self.frame;
    editFrame.size.height = height;
    self.frame = editFrame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect editFrame = self.frame;
    editFrame.size.width = width;
    self.frame = editFrame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
    CGRect editFrame = self.frame;
    editFrame.origin.y = top;
    self.frame = editFrame;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
    CGRect editFrame = self.frame;
    editFrame.origin.x = left;
    self.frame = editFrame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect editFrame = self.frame;
    editFrame.origin.y = bottom - self.frame.size.height;
    self.frame = editFrame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGFloat rightOffset = right - (self.origin.x + self.frame.size.width);
    CGRect editFrame = self.frame;
    editFrame.origin.x += rightOffset;
    self.frame = editFrame;
}

@end
