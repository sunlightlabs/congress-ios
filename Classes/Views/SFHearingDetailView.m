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
    self.insets = UIEdgeInsetsMake(4.0f, 4.0f, 4.0f, 4.0f);
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
    _calloutView = [[SFCalloutView alloc] initWithFrame:CGRectZero];
    _calloutView.insets = UIEdgeInsetsMake(4.0f, 14.0f, 13.0f, 14.0f);
    [self addSubview:_calloutView];
    
    _committeePrefixLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _committeePrefixLabel.font = [UIFont subitleEmFont];
    _committeePrefixLabel.textColor = [UIColor subtitleColor];
    _committeePrefixLabel.textAlignment = NSTextAlignmentCenter;
    _committeePrefixLabel.backgroundColor = [UIColor clearColor];
    [_committeePrefixLabel setIsAccessibilityElement:NO];
    [_calloutView addSubview:_committeePrefixLabel];
    
    _committeePrimaryLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _committeePrimaryLabel.numberOfLines = 2;
    _committeePrimaryLabel.font = [UIFont billTitleFont];
    _committeePrimaryLabel.textColor = [UIColor titleColor];
    _committeePrimaryLabel.textAlignment = NSTextAlignmentLeft;
    _committeePrimaryLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _committeePrimaryLabel.backgroundColor = [UIColor clearColor];
    [_calloutView addSubview:_committeePrimaryLabel];
    
    _descriptionLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _descriptionLabel.numberOfLines = 20;
    _descriptionLabel.font = [UIFont bodyTextFont];
    _descriptionLabel.textColor = [UIColor titleColor];
    _descriptionLabel.textAlignment = NSTextAlignmentLeft;
    _descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    [_calloutView addSubview:_descriptionLabel];
    
    CGRect lineRect = CGRectMake(0, 0, 2.0f, 1.0f);
    _titleLines = @[[[SSLineView alloc] initWithFrame:lineRect], [[SSLineView alloc] initWithFrame:lineRect]];
    for (SSLineView *lview in _titleLines) {
        lview.autoresizingMask = UIViewAutoresizingNone;
        lview.lineColor = [UIColor detailLineColor];
        [_calloutView addSubview:lview]; 
    }
}

- (void)layoutSubviews
{    
    _calloutView.top = self.topInset;
    _calloutView.left = self.leftInset;
    _calloutView.width = self.insetsWidth;
    
    CGFloat calloutContentWidth = _calloutView.insetsWidth;
        
    [_committeePrefixLabel sizeToFit];
    _committeePrefixLabel.top = _calloutView.top + self.topInset;
    _committeePrefixLabel.center = CGPointMake((_calloutView.insetsWidth / 2), _committeePrefixLabel.center.y);
    
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
    
    labelTextSize = [_descriptionLabel.text sizeWithFont:_descriptionLabel.font constrainedToSize:CGSizeMake(calloutContentWidth, NSIntegerMax)];
    _descriptionLabel.width = _calloutView.insetsWidth;
    _descriptionLabel.frame = CGRectMake(0, _committeePrimaryLabel.bottom + 5.0f, calloutContentWidth - 15.0f, labelTextSize.height);
    
    [_calloutView layoutSubviews];
}

@end
