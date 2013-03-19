//
//  SFSegmentedView.m
//  Congress
//
//  Created by Daniel Cloud on 2/1/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFSegmentedView.h"

@implementation SFSegmentedView

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

- (void)layoutSubviews
{
    CGSize size = self.bounds.size;

    [_segmentedControl sizeToFit];
    _segmentedControl.frame = CGRectMake(4.0f, 5.0f, (size.width-8.0f), _segmentedControl.height);

    _contentView.frame = CGRectMake(0.0f, _segmentedControl.bottom + 5.0f, size.width, (size.height-_segmentedControl.bottom));

}

- (void)setContentView:(UIView *)contentView
{
    [_contentView removeFromSuperview];
    _contentView = contentView;
    [self addSubview:_contentView];
}

#pragma mark - Private

- (void)_initialize
{
    _segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectZero];
    _segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
//    _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:_segmentedControl];
}

@end
