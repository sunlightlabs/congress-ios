//
//  SFSegmentedView.m
//  Congress
//
//  Created by Daniel Cloud on 2/1/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFSegmentedView.h"

@implementation SFSegmentedView {
    NSMutableArray *_constraints;
}

@synthesize segmentedControl = _segmentedControl;
@synthesize contentView = _contentView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)updateConstraints
{
    [self removeConstraints:_constraints];
    [_constraints removeAllObjects];

    NSDictionary *views = @{@"tabs": _segmentedControl, @"contentView": _contentView};

    NSDictionary *metrics = @{@"tabHeight": @33};

    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(5)-[tabs(tabHeight)]-(5)-[contentView]|"
                                                                             options:0
                                                                             metrics:metrics
                                                                                views:views]];
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(4)-[tabs]-(4)-|" options:0 metrics:metrics views:views]];
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:metrics views:views]];


    if ([_contentView.subviews count] > 0) {
        // Make sure the subview(s) get laid out inside the _contentView...
        // There should be only one subview.
        UIView *contentSubview = [_contentView.subviews objectAtIndex:0];
        NSDictionary *contentViews = @{@"contentSubview": contentSubview};
        [_contentView removeConstraints:_contentView.constraints];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentSubview]|" options:0 metrics:nil views:contentViews]];
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentSubview]|" options:0 metrics:nil views:contentViews]];
    }

    [self addConstraints:_constraints];
    [super updateConstraints];

}

- (void)setContentView:(UIView *)newView
{
    for (UIView *subview in _contentView.subviews) {
        [subview removeFromSuperview];
    }
    [_contentView addSubview:newView];
    newView.frame = _contentView.bounds;
    [self updateConstraints];
}

#pragma mark - Private

- (void)_initialize
{
    _segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectZero];
    _segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_segmentedControl];

    _contentView = [UIView new];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_contentView];

    _constraints = [NSMutableArray array];
}

@end
