//
//  SFCalloutView.m
//  Congress
//
//  Created by Daniel Cloud on 3/19/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCalloutBackgroundView.h"

@implementation SFCalloutBackgroundView
{
    UIImage *_bgImage;
}

@synthesize backgroundImageView = _backgroundImageView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)updateContentConstraints {
    NSDictionary *views = @{ @"image":_backgroundImageView };
    NSDictionary *metrics = @{ @"left":@(self.contentInset.left), @"top":@(self.contentInset.top) };
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(top)-[image]-(top)-|" options:0 metrics:metrics views:views]];
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(left)-[image]-(left)-|" options:0 metrics:metrics views:views]];
    [self.backgroundImageView invalidateIntrinsicContentSize];
}

#pragma mark - Private

- (void)_initialize {
    self.contentInset = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
    self.translatesAutoresizingMaskIntoConstraints = NO;
    _bgImage = [UIImage calloutBoxBackgroundImage];
    _backgroundImageView = [[UIImageView alloc] initWithImage:_bgImage];
    _backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_backgroundImageView];
}

@end
