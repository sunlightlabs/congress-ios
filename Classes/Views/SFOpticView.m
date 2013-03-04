//
//  SFOpticView.m
//  Congress
//
//  Created by Daniel Cloud on 3/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFOpticView.h"

@implementation SFOpticView

static CGFloat panelHeight = 80.0f;
static CGFloat contentInset = 8.0f;

@synthesize textLabel = _textLabel;

- (id)initWithFrame:(CGRect)frame
{
    CGRect panelFrame = CGRectSetHeight(frame, panelHeight);
    self = [super initWithFrame:panelFrame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.815 alpha:1.000];
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(contentInset, contentInset, contentInset, contentInset);
        CGRect labelFrame = UIEdgeInsetsInsetRect(panelFrame, contentInsets);
        self.textLabel = [[UILabel alloc] initWithFrame:labelFrame];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont systemFontOfSize:16.0];
        self.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.textLabel.numberOfLines = 0;
//        self.textLabel.al
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
