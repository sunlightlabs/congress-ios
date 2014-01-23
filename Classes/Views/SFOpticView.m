//
//  SFOpticView.m
//  Congress
//
//  Created by Daniel Cloud on 3/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFOpticView.h"

@implementation SFOpticView
{
    CGRect _labelFrame;
}

static CGFloat SFOpticViewContentInsetHorizontal = 15.0f;
static CGFloat SFOpticViewContentInsetTop = 12.0f;
static CGFloat SFOpticViewContentInsetBottom = 8.0f;

@synthesize textLabel = _textLabel;
@synthesize contentInsets = _contentInsets;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor secondaryBackgroundColor];
        self.opaque = YES;
        self.contentInsets = UIEdgeInsetsMake(SFOpticViewContentInsetTop, SFOpticViewContentInsetHorizontal,
                                              SFOpticViewContentInsetBottom, SFOpticViewContentInsetHorizontal);
        _labelFrame = UIEdgeInsetsInsetRect(self.frame, self.contentInsets);
        self.textLabel = [[UILabel alloc] initWithFrame:_labelFrame];
        self.textLabel.textColor = [UIColor primaryTextColor];
        self.textLabel.font = [UIFont cellImportantDetailFont];
        self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.textLabel.numberOfLines = 0;
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    self.opaque = YES;
    self.backgroundColor = [UIColor secondaryBackgroundColor];
    _labelFrame = UIEdgeInsetsInsetRect(self.bounds, _contentInsets);
    self.textLabel.frame = _labelFrame;
    self.textLabel.backgroundColor = [UIColor clearColor];
}

@end
