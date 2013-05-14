//
//  SFFavoriteButton.m
//  Congress
//
//  Created by Daniel Cloud on 3/14/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFFavoriteButton.h"

@implementation SFFavoriteButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *normalIcon = [UIImage favoriteUnselectedImage];
        UIImage *selectedIcon = [UIImage favoriteSelectedImage];
        [self setImage:normalIcon forState:UIControlStateNormal];
        [self setImage:selectedIcon forState:UIControlStateSelected];
    }
    return self;
}

@end
