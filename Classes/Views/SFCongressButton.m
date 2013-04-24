//
//  SFCongressButton.m
//  Congress
//
//  Created by Daniel Cloud on 3/11/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCongressButton.h"

@implementation SFCongressButton

@synthesize detailLabel = _detailLabel;

static NSInteger const horizontalOffset = 10.0f;
static NSInteger const minimumSize = 44.0f;

+ (instancetype)button
{
    return [[self alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, minimumSize)];
}

+ (instancetype)buttonWithTitle:(NSString *)title
{
    SFCongressButton *button = [[self alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, minimumSize)];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[UIImage buttonDefaultBackgroundImage] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage buttonSelectedBackgroundImage] forState:UIControlStateHighlighted];
        self.adjustsImageWhenHighlighted = NO;
        [self setTitleColor:[UIColor linkTextColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont linkFont];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;

        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLabel.font = self.titleLabel.font;
        _detailLabel.textColor = [self titleColorForState:UIControlStateNormal];
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.backgroundColor = nil;
        _detailLabel.opaque = NO;
        [self addSubview:_detailLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    self.titleLabel.width = self.width - 2*horizontalOffset;
    self.titleLabel.left = horizontalOffset;

//    self.currentBackgroundImage.frame = CGRectInset(self.currentBackgroundImage.frame, 0, 11.0f);
//    BOOL bgImage;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]] && [((UIImageView *)view).image isEqual:self.currentBackgroundImage]) {
            view.frame = CGRectInset(view.frame, 0, self.height/4); // self.height is going to be at least 44.0f based on minimumSize/sizeThatFits
        }
    }

    if (_detailLabel) {
        [_detailLabel sizeToFit];
        _detailLabel.top = self.titleLabel.top;
        _detailLabel.right = self.width - horizontalOffset;
    }
}

- (CGSize)sizeThatFits:(CGSize)pSize
{
    CGSize size = [super sizeThatFits:pSize];
    size.width = size.width+20.0f < minimumSize ? minimumSize : size.width+20.0f;
    size.height = size.height < minimumSize ? minimumSize : size.height;
    return size;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    [super setTitleColor:color forState:state];
    [_detailLabel setTextColor:color];
}

@end
