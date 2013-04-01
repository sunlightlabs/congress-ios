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
    UIEdgeInsets _contentInsets;
    CGRect _labelFrame;
}

static CGFloat SFOpticViewContentInsetHorizontal = 21.0f;
static CGFloat SFOpticViewContentInsetTop = 12.0f;
static CGFloat SFOpticViewContentInsetBottom = 8.0f;

@synthesize textLabel = _textLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor secondaryBackgroundColor];
        _contentInsets = UIEdgeInsetsMake(SFOpticViewContentInsetTop, SFOpticViewContentInsetHorizontal,
                                                      SFOpticViewContentInsetBottom, SFOpticViewContentInsetHorizontal);
        _labelFrame = UIEdgeInsetsInsetRect(self.frame, _contentInsets);
        self.textLabel = [[UILabel alloc] initWithFrame:_labelFrame];
        self.textLabel.textColor = [UIColor primaryTextColor];
        self.textLabel.font = [UIFont cellPanelTextFont];
        self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.textLabel.numberOfLines = 0;
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    _labelFrame = UIEdgeInsetsInsetRect(self.frame, _contentInsets);
    CGSize textSize = [self.textLabel.text sizeWithFont:self.textLabel.font
                                      constrainedToSize:_labelFrame.size lineBreakMode:self.textLabel.lineBreakMode];
    self.textLabel.frame = _labelFrame;
    self.textLabel.height = textSize.height;
    self.textLabel.backgroundColor = self.backgroundColor;
}

@end
