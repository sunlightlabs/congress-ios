//
//  SFFavoriteButton.m
//  Congress
//
//  Created by Daniel Cloud on 3/14/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFFavoriteButton.h"

@implementation SFFavoriteButton {
    CGSize _instrinsicSize;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *normalIcon = [UIImage favoriteUnselectedImage];
        UIImage *selectedIcon = [UIImage favoriteSelectedImage];
        _instrinsicSize = CGSizeMake(44.0f, 44.0f);
        [self setImage:normalIcon forState:UIControlStateNormal];
        [self setImage:selectedIcon forState:UIControlStateSelected];
        [self setAccessibilityLabel:@"Following"];
        [self setAccessibilityHint:@"Tap to add to or remove from followed items"];
    }
    return self;
}

- (CGSize)intrinsicContentSize
{
    return _instrinsicSize;
}

@end
