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
        UIImage *normalIcon = [UIImage imageNamed:@"FavoriteUnselected"];
        UIImage *selectedIcon = [UIImage imageNamed:@"FavoriteSelected"];
        [self setImage:normalIcon forState:UIControlStateNormal];
        [self setImage:selectedIcon forState:UIControlStateSelected];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize fitSize = [super sizeThatFits:size];
    fitSize.width = 44.0f;
    fitSize.height = 44.0f;
    return fitSize;
}

- (CGSize)contentSize
{
    return self.imageView.size;
}

@end
