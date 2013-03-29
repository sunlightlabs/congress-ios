//
//  SFOpticView.m
//  Congress
//
//  Created by Daniel Cloud on 3/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFOpticView.h"

@implementation SFOpticView

static CGFloat contentInset = 8.0f;

@synthesize textLabel = _textLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor secondaryBackgroundColor];
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(contentInset, contentInset, contentInset, contentInset);
        CGRect labelFrame = UIEdgeInsetsInsetRect(self.frame, contentInsets);
        self.textLabel = [[UILabel alloc] initWithFrame:labelFrame];
        self.textLabel.textColor = [UIColor primaryTextColor];
        self.textLabel.font = [UIFont cellDetailTextFont];
        self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.textLabel.numberOfLines = 0;
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(contentInset, contentInset, contentInset, contentInset);
    CGRect labelFrame = UIEdgeInsetsInsetRect(self.frame, contentInsets);
    CGSize textSize = [self.textLabel.text sizeWithFont:self.textLabel.font constrainedToSize:labelFrame.size lineBreakMode:self.textLabel.lineBreakMode];

    self.textLabel.frame = labelFrame;
    self.textLabel.height = textSize.height;
    self.textLabel.backgroundColor = self.backgroundColor;
}

@end
