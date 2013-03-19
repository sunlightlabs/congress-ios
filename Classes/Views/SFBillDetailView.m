//
//  SFBillDetailView.m
//  Congress
//
//  Created by Daniel Cloud on 12/4/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFBillDetailView.h"
#import "SFCalloutView.h"

@implementation SFBillDetailView
{
    SFCalloutView *_calloutView;
}

@synthesize titleLabel = _titleLabel;
@synthesize subtitleLabel = _subtitleLabel;
@synthesize summary = _summary;
@synthesize sponsorButton = _sponsorButton;
@synthesize cosponsorsButton = _cosponsorsButton;
@synthesize linkOutButton = _linkOutButton;
@synthesize favoriteButton = _favoriteButton;

#pragma mark - UIView

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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void)layoutSubviews
{
    CGSize size = self.bounds.size;
    _scrollView.frame = self.bounds;
    CGSize contentSize = CGSizeZero;
    contentSize.width = size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;

    _calloutView.top = 0.0f;
    _calloutView.width = _scrollView.contentSize.width;

    CGFloat calloutContentWidth = _calloutView.contentView.width;

    [_subtitleLabel sizeToFit];
    _subtitleLabel.frame = CGRectMake(0, 0, calloutContentWidth, _subtitleLabel.height);

    CGSize labelTextSize = [_titleLabel.text sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(calloutContentWidth, 88)];
    _titleLabel.frame = CGRectMake(0, _subtitleLabel.bottom + 5.0f, calloutContentWidth, labelTextSize.height);

    [_sponsorButton sizeToFit];
    _sponsorButton.left = 0;
    _sponsorButton.top =  _titleLabel.bottom + 13.0f;

    [_cosponsorsButton sizeToFit];
    _cosponsorsButton.top =  _sponsorButton.top;
    _cosponsorsButton.left = _sponsorButton.right + 10.0f;

    [_favoriteButton sizeToFit];
    _favoriteButton.center = CGPointMake(_favoriteButton.center.x, _cosponsorsButton.center.y);
    _favoriteButton.right = calloutContentWidth;

    [_calloutView layoutSubviews];

    _summary.top = _calloutView.bottom+14.0f;
    _summary.left = 15.0f;
    _summary.width = contentSize.width - (_summary.left*2);
    [_summary sizeToFit];

    [_linkOutButton sizeToFit];
    _linkOutButton.origin = CGPointMake(_summary.left, _summary.bottom+12.0f);

    contentSize.height = _linkOutButton.bottom + 5.0f;
    [_scrollView setContentSize:contentSize];
}

#pragma mark - Private Methods

-(void)_initialize
{
    self.insets = UIEdgeInsetsMake(0, 4.0f, 16.0f, 4.0f);
    
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    _scrollView.contentInset = self.insets;
    [self addSubview:_scrollView];

    _calloutView = [[SFCalloutView alloc] initWithFrame:CGRectZero];
    [_scrollView addSubview:_calloutView];

    _titleLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont h1Font];
    _titleLabel.textColor = [UIColor h1Color];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.backgroundColor = [UIColor clearColor];
    [_calloutView addSubview:_titleLabel];

    _subtitleLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _subtitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _subtitleLabel.font = [UIFont h2Font];
    _subtitleLabel.textColor = [UIColor h2Color];
    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    _subtitleLabel.backgroundColor = [UIColor clearColor];
    [_calloutView addSubview:_subtitleLabel];

    _sponsorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sponsorButton.titleLabel.font = [UIFont linkFont];
    [_sponsorButton setTitleColor:[UIColor linkTextColor] forState:UIControlStateNormal];
    [_sponsorButton setTitleColor:[UIColor linkHighlightedTextColor] forState:UIControlStateHighlighted];
    [_calloutView addSubview:_sponsorButton];

    _cosponsorsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cosponsorsButton.titleLabel.font = [UIFont linkFont];
    [_cosponsorsButton setTitleColor:[UIColor linkTextColor] forState:UIControlStateNormal];
    [_cosponsorsButton setTitleColor:[UIColor linkHighlightedTextColor] forState:UIControlStateHighlighted];
    [_calloutView addSubview:_cosponsorsButton];

    _favoriteButton = [[SFFavoriteButton alloc] init];
    [_calloutView addSubview:_favoriteButton];

    _summary = [[SFLabel alloc] initWithFrame:CGRectZero];
    _summary.numberOfLines = 0;
    _summary.lineBreakMode = NSLineBreakByWordWrapping;
    _summary.font = [UIFont bodyTextFont];
    _summary.textColor = [UIColor primaryTextColor];
    _summary.textAlignment = NSTextAlignmentLeft;
    _summary.verticalTextAlignment = SSLabelVerticalTextAlignmentTop;
    _summary.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _summary.backgroundColor = self.backgroundColor;
    [_scrollView addSubview:_summary];

    _linkOutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_linkOutButton setTitle:@"View Full Text" forState:UIControlStateNormal];
    [_scrollView addSubview:_linkOutButton];
}

@end
