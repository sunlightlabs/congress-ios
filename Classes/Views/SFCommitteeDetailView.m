//
//  SFCommitteeDetailView.m
//  Congress
//
//  Created by Jeremy Carbaugh on 8/14/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteeDetailView.h"
#import "SFCalloutView.h"

@implementation SFCommitteeDetailView {
    SFCalloutView *_calloutView;
    NSArray *_titleLines;
}

@synthesize prefixNameLabel = _prefixNameLabel;
@synthesize primaryNameLabel = _primaryNameLabel;
@synthesize favoriteButton = _favoriteButton;
@synthesize subcommitteeListView = _subcommitteeListView;

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
    
    _prefixNameLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _prefixNameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _prefixNameLabel.font = [UIFont subitleEmFont];
    _prefixNameLabel.textColor = [UIColor subtitleColor];
    _prefixNameLabel.textAlignment = NSTextAlignmentCenter;
    _prefixNameLabel.backgroundColor = [UIColor clearColor];
//    [_prefixNameLabel setAccessibilityLabel:];
    [_calloutView addSubview:_prefixNameLabel];
    
    _primaryNameLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _primaryNameLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    _primaryNameLabel.numberOfLines = 0;
    _primaryNameLabel.font = [UIFont billTitleFont];
    _primaryNameLabel.textColor = [UIColor titleColor];
    _primaryNameLabel.textAlignment = NSTextAlignmentLeft;
    _primaryNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _primaryNameLabel.backgroundColor = [UIColor clearColor];
    [_calloutView addSubview:_primaryNameLabel];
    
    _favoriteButton = [[SFFavoriteButton alloc] init];
    [_calloutView addSubview:_favoriteButton];
    
    CGRect lineRect = CGRectMake(0, 0, 2.0f, 1.0f);
    _titleLines = @[[[SSLineView alloc] initWithFrame:lineRect], [[SSLineView alloc] initWithFrame:lineRect]];
    for (SSLineView *lview in _titleLines) {
        lview.lineColor = [UIColor detailLineColor];
        [_calloutView addSubview:lview];
    }
}

- (void)layoutSubviews
{
    _calloutView.top = 0.0f;
    _calloutView.left = self.insets.left;
    _calloutView.width = self.insetsWidth;
    
    CGFloat calloutContentWidth = _calloutView.contentView.width;
    
    [_prefixNameLabel sizeToFit];
    _prefixNameLabel.frame = CGRectMake(0, 0, _prefixNameLabel.width, _prefixNameLabel.height);
    _prefixNameLabel.center = CGPointMake((calloutContentWidth/2.0f), _prefixNameLabel.center.y);
    
    CGSize labelTextSize = [_primaryNameLabel.text sizeWithFont:_primaryNameLabel.font constrainedToSize:CGSizeMake(calloutContentWidth, NSIntegerMax)];
    _primaryNameLabel.frame = CGRectMake(0, _prefixNameLabel.bottom + 5.0f, calloutContentWidth, labelTextSize.height);
    
    SSLineView *lview = _titleLines[0];
    lview.width = _prefixNameLabel.left - 16.0f;
    lview.left = 0;
    lview.center = CGPointMake(lview.center.x, _prefixNameLabel.center.y);
    
    lview = _titleLines[1];
    lview.width = calloutContentWidth - _prefixNameLabel.right - 16.0f;
    lview.right = calloutContentWidth;
    lview.center = CGPointMake(lview.center.x, _prefixNameLabel.center.y);
    
    [_favoriteButton sizeToFit];
    CGPoint fromPoint = [self convertPoint:_primaryNameLabel.center fromView:_calloutView.contentView];
     _favoriteButton.right = _calloutView.right - self.insets.right;
     _favoriteButton.center = CGPointMake(_favoriteButton.center.x, fromPoint.y);
    
    [_calloutView layoutSubviews];
    
    if (_subcommitteeListView) {
        _subcommitteeListView.top = _calloutView.bottom + 5;
        _subcommitteeListView.height = self.height - _subcommitteeListView.top;
        if (![self.subviews containsObject:_subcommitteeListView]) {
            [self addSubview:_subcommitteeListView];
        }
    }
}

@end
