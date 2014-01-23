//
//  SFTableHeaderView.m
//  Congress
//
//  Created by Daniel Cloud on 4/12/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFTableHeaderView.h"

CGFloat const SFTableHeaderViewHeight = 16.0f;

@implementation SFTableHeaderView
{
    UIEdgeInsets _textLabelInsets;
}

@synthesize textLabel = _textLabel;
@synthesize backgroundView = _backgroundView;
@synthesize reuseIdentifier = _reuseIdentifier;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textLabelInsets = UIEdgeInsetsMake(2.0f, 8.0f, 2.0f, 8.0f);
        _reuseIdentifier = NSStringFromClass([self class]);
        CGRect rect = self.bounds;
        _backgroundView = [[UIView alloc] initWithFrame:rect];
        _backgroundView.backgroundColor = [UIColor tableHeaderBackgroundColor];
        [self addSubview:_backgroundView];
        CGRect textRect = CGRectInset(rect, _textLabelInsets.left, _textLabelInsets.top);
        _textLabel = [[UILabel alloc] initWithFrame:textRect];
        _textLabel.textColor = [UIColor tableHeaderTextColor];
        _textLabel.backgroundColor = [UIColor tableHeaderBackgroundColor];
        _textLabel.font = [UIFont tableSectionHeaderFont];
        _textLabel.numberOfLines = 1;
        _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.bounds;
    _backgroundView.frame = rect;
    _textLabel.frame = CGRectInset(rect, _textLabelInsets.left, _textLabelInsets.top);
}

@end
