//
//  SFBillDetailView.m
//  Congress
//
//  Created by Daniel Cloud on 12/4/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFBillDetailView.h"

@implementation SFBillDetailView

@synthesize titleLabel = _titleLabel;
@synthesize subtitleLabel = _subtitleLabel;
@synthesize summary = _summary;
@synthesize sponsorButton = _sponsorButton;
@synthesize cosponsorsButton = _cosponsorsButton;
@synthesize linkOutButton = _linkOutButton;

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

    [_subtitleLabel sizeToFit];
    _subtitleLabel.frame = CGRectMake(0.0f, 0.0f, contentSize.width, _subtitleLabel.height);

    CGSize labelTextSize = [_titleLabel.text sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(size.width, 88)];
    _titleLabel.frame = CGRectMake(0.0f, _subtitleLabel.bottom + 5.0f, contentSize.width, labelTextSize.height);

    [_sponsorButton sizeToFit];
    _sponsorButton.top =  _titleLabel.bottom + 5.0f;

    [_cosponsorsButton sizeToFit];
    _cosponsorsButton.top =  _sponsorButton.top;
    _cosponsorsButton.left = _sponsorButton.right + 10.0f;

    _summary.top = _sponsorButton.bottom+10.0f;
    _summary.width = contentSize.width;
    [_summary sizeToFit];

    [_linkOutButton sizeToFit];
    _linkOutButton.origin = CGPointMake(0.0f, _summary.bottom+12.0f);

    contentSize.height = _linkOutButton.bottom + 5.0f;
    [_scrollView setContentSize:contentSize];
}

#pragma mark - Private Methods

-(void)_initialize
{
    self.insets = UIEdgeInsetsMake(8.0f, 8.0f, 16.0f, 8.0f);
    
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    _scrollView.contentInset = self.insets;
    [self addSubview:_scrollView];

    _titleLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont h1Font];
    _titleLabel.textColor = [UIColor h1Color];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.backgroundColor = self.backgroundColor;
    [_scrollView addSubview:_titleLabel];

    _subtitleLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _subtitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _subtitleLabel.font = [UIFont h2Font];
    _subtitleLabel.textColor = [UIColor h2Color];
    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    _subtitleLabel.backgroundColor = self.backgroundColor;
    [_scrollView addSubview:_subtitleLabel];

    _sponsorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sponsorButton.titleLabel.font = [UIFont linkFont];
    [_sponsorButton setTitleColor:[UIColor linkTextColor] forState:UIControlStateNormal];
    [_sponsorButton setTitleColor:[UIColor linkHighlightedTextColor] forState:UIControlStateHighlighted];
    [_scrollView addSubview:_sponsorButton];

    _cosponsorsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cosponsorsButton.titleLabel.font = [UIFont linkFont];
    [_cosponsorsButton setTitleColor:[UIColor linkTextColor] forState:UIControlStateNormal];
    [_cosponsorsButton setTitleColor:[UIColor linkHighlightedTextColor] forState:UIControlStateHighlighted];
    [_scrollView addSubview:_cosponsorsButton];

    _summary = [[SFLabel alloc] initWithFrame:CGRectZero];
    _summary.numberOfLines = 0;
    _summary.lineBreakMode = NSLineBreakByWordWrapping;
    _summary.font = [UIFont bodyTextFont];
    _summary.textColor = [UIColor blackColor];
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
