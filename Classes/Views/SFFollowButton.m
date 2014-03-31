//
//  SFFollowButton.m
//  Congress
//
//  Created by Daniel Cloud on 3/14/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFFollowButton.h"

@interface SFFollowButton () {
    CGSize _instrinsicSize;
}

- (void)initialize;

@end

@implementation SFFollowButton

+ (instancetype)button {
    SFFollowButton *instance = [[self alloc] init];
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (CGSize)intrinsicContentSize {
    return _instrinsicSize;
}

#pragma mark - Private

- (void)initialize {
    UIImage *normalIcon = [UIImage followUnselectedImage];
    UIImage *selectedIcon = [UIImage followIsSelectedImage];
    _instrinsicSize = CGSizeMake(44.0f, 44.0f);
    self.size = _instrinsicSize;
    [self setImage:normalIcon forState:UIControlStateNormal];
    [self setImage:selectedIcon forState:UIControlStateSelected];
    [self setAccessibilityLabel:@"Following"];
    [self setAccessibilityHint:@"Tap to add to or remove from followed items"];
}

@end
