//
//  SFHearingDetailView.m
//  Congress
//
//  Created by Jeremy Carbaugh on 8/23/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFHearingDetailView.h"
#import "SFCalloutView.h"

@implementation SFHearingDetailView
{
    SFCalloutView *_calloutView;
    NSArray *_titleLines;
}

@synthesize committeePrefixLabel = _committeePrefixLabel;
@synthesize committeePrimaryLabel = _committeePrimaryLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize locationLabel = _locationLabel;
@synthesize occursAtLabel = _occursAtLabel;
@synthesize urlButton = _urlButton;

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[self _initialize];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)_initialize
{
    self.insets = UIEdgeInsetsMake(0, 4.0f, 16.0f, 4.0f);
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    _calloutView = [[SFCalloutView alloc] initWithFrame:CGRectZero];
    [self addSubview:_calloutView];
    
    _committeePrefixLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _committeePrefixLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _committeePrefixLabel.font = [UIFont subitleEmFont];
    _committeePrefixLabel.textColor = [UIColor subtitleColor];
    _committeePrefixLabel.textAlignment = NSTextAlignmentCenter;
    _committeePrefixLabel.backgroundColor = [UIColor clearColor];
    [_committeePrefixLabel setIsAccessibilityElement:NO];
    [_calloutView addSubview:_committeePrefixLabel];
    
    _committeePrimaryLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _committeePrimaryLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    _committeePrimaryLabel.numberOfLines = 2;
    _committeePrimaryLabel.font = [UIFont billTitleFont];
    _committeePrimaryLabel.textColor = [UIColor titleColor];
    _committeePrimaryLabel.textAlignment = NSTextAlignmentLeft;
    _committeePrimaryLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _committeePrimaryLabel.backgroundColor = [UIColor clearColor];
    [_calloutView addSubview:_committeePrimaryLabel];
}

- (void)layoutSubviews
{
    _calloutView.top = 0.0f;
    _calloutView.left = self.insets.left;
    _calloutView.width = self.insetsWidth;
    
    CGFloat calloutContentWidth = _calloutView.contentView.width;
    
    [_committeePrefixLabel sizeToFit];
    _committeePrefixLabel.frame = CGRectMake(0, 0, _committeePrefixLabel.width, _committeePrefixLabel.height);
    _committeePrefixLabel.center = CGPointMake((calloutContentWidth/2.0f), _committeePrefixLabel.center.y);
    
    SSLineView *lview = _titleLines[0];
    lview.width = _committeePrefixLabel.left - 16.0f;
    lview.left = 0;
    lview.center = CGPointMake(lview.center.x, _committeePrefixLabel.center.y);
    
    lview = _titleLines[1];
    lview.width = calloutContentWidth - _committeePrefixLabel.right - 16.0f;
    lview.right = calloutContentWidth;
    lview.center = CGPointMake(lview.center.x, _committeePrefixLabel.center.y);
    
    CGSize labelTextSize = [_committeePrimaryLabel.text sizeWithFont:_committeePrimaryLabel.font constrainedToSize:CGSizeMake(calloutContentWidth, NSIntegerMax)];
    _committeePrimaryLabel.frame = CGRectMake(0, _committeePrefixLabel.bottom + 5.0f, calloutContentWidth - 15.0f, labelTextSize.height);
    
    [_calloutView layoutSubviews];
}

@end
