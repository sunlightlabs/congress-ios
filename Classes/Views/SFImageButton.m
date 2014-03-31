//
//  SFImageButton.m
//  Congress
//
//  Created by Daniel Cloud on 4/1/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFImageButton.h"

@implementation SFImageButton

static CGFloat const minimumDimension = 44.0f;

+ (instancetype)button {
    return [[self alloc] initWithFrame:CGRectMake(0.0f, 0.0f, minimumDimension, minimumDimension)];
}

+ (instancetype)buttonWithDefaultImage:(UIImage *)image {
    SFImageButton *instance = [[self alloc] initWithFrame:CGRectMake(0.0f, 0.0f, minimumDimension, minimumDimension)];
    [instance setImage:image forState:UIControlStateNormal];

    return instance;
}

- (CGSize)intrinsicContentSize {
    CGSize intrinsicSize = [super intrinsicContentSize];
    intrinsicSize.width = fmaxf(minimumDimension, intrinsicSize.width);
    intrinsicSize.height = fmaxf(minimumDimension, intrinsicSize.height);
    return intrinsicSize;
}

- (CGSize)contentSize {
    if (self.imageView) {
        return self.imageView.size;
    }
    return CGSizeMake(minimumDimension, minimumDimension);
}

- (CGFloat)horizontalPadding {
    return (self.width - self.contentSize.width) / 2;
}

- (CGFloat)verticalPadding {
    return (self.height - self.contentSize.height) / 2;
}

@end
