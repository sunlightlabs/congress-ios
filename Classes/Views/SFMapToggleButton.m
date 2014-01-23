//
//  SFMapToggleButton.m
//  Congress
//
//  Created by Daniel Cloud on 4/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFMapToggleButton.h"

@implementation SFMapToggleButton
{
    UIImage *_expandButton;
    UIImage *_expandSelectedButton;
    UIImage *_collapseButton;
    UIImage *_collapseSelectedButton;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _expandButton = [UIImage mapExpandButton];
        _expandSelectedButton = [UIImage mapExpandSelectedButton];
        _collapseButton = [UIImage mapCollapseButton];
        _collapseSelectedButton = [UIImage mapCollapseSelectedButton];
        [self setImage:_expandButton forState:UIControlStateNormal];
        [self setImage:_expandSelectedButton forState:UIControlStateHighlighted];
        [self setImage:_collapseButton forState:UIControlStateSelected];
        [self setImage:_collapseSelectedButton forState:UIControlStateSelected | UIControlStateHighlighted];
    }
    return self;
}

@end
