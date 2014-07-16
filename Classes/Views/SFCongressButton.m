//
//  SFCongressButton.m
//  Congress
//
//  Created by Daniel Cloud on 3/11/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCongressButton.h"

@implementation SFCongressButton {
    NSMutableArray *_constraints;
}

static NSInteger const horizontalOffset = 10.0f;
static NSInteger const minimumSize = 44.0f;

+ (instancetype)button {
    return [[self alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, minimumSize)];
}

+ (instancetype)buttonWithTitle:(NSString *)title {
    SFCongressButton *button = [[self alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, minimumSize)];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[UIImage buttonDefaultBackgroundImage] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage buttonSelectedBackgroundImage] forState:UIControlStateHighlighted];
        self.adjustsImageWhenHighlighted = NO;
        [self setTitleColor:[UIColor linkTextColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor linkHighlightedTextColor] forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont linkFont];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        _constraints = [NSMutableArray array];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.titleLabel sizeToFit];
    self.titleLabel.width = self.width - 2 * horizontalOffset;
    self.titleLabel.left = horizontalOffset;

    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]] && [((UIImageView *)view).image isEqual : self.currentBackgroundImage]) {
            view.frame = CGRectInset(view.frame, 0, self.height / 4); // self.height is going to be at least 44.0f based on minimumSize/sizeThatFits
        }
    }
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    return CGSizeMake(size.width + 20.0f, minimumSize);
}

- (void)updateConstraints {
    [self removeConstraints:_constraints];
    [_constraints removeAllObjects];

    NSDictionary *views = @{ @"title":self.titleLabel };
    NSDictionary *metrics = @{
        @"hOffset": @(horizontalOffset),
        @"minimumSize": @(minimumSize)
    };

    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(hOffset)-[title(>=minimumSize)]-(hOffset)-|" options:0 metrics:metrics views:views]];
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                            toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0f
                                                          constant:minimumSize]];
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                            toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0f
                                                          constant:minimumSize]];
    [self addConstraints:_constraints];
    [super updateConstraints];
}

- (CGSize)sizeThatFits:(CGSize)pSize {
    CGSize size = [super sizeThatFits:pSize];
    size.width = size.width + 20.0f < minimumSize ? minimumSize : size.width + 20.0f;
    size.height = size.height < minimumSize ? minimumSize : size.height;
    return size;
}

- (CGSize)contentSize {
    return self.currentBackgroundImage.size;
}

- (CGFloat)horizontalPadding {
    return (self.width - self.contentSize.width) / 2;
}

- (CGFloat)verticalPadding {
    return (self.height - self.contentSize.height) / 2;
}

@end
