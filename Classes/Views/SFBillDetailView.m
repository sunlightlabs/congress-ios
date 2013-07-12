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
    NSArray *_titleLines;
}

@synthesize scrollView = _scrollView;
@synthesize callout = _callout;
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

//-(void)layoutSubviews
//{
//    CGSize size = self.bounds.size;
//    _scrollView.frame = self.bounds;
//    CGSize contentSize = CGSizeZero;
//    contentSize.width = size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
//
//    _callout.top = 0.0f;
//    _callout.width = _scrollView.contentSize.width;
//
//    CGFloat calloutContentWidth = _callout.contentView.width;
//
//    [_subtitleLabel sizeToFit];
//    _subtitleLabel.frame = CGRectMake(0, 0, _subtitleLabel.width, _subtitleLabel.height);
//    _subtitleLabel.center = CGPointMake((calloutContentWidth/2.0f), _subtitleLabel.center.y);
//
//    SSLineView *lview = _titleLines[0];
//    lview.width = _subtitleLabel.left - 16.0f;
//    lview.left = 0;
//    lview.center = CGPointMake(lview.center.x, _subtitleLabel.center.y);
//    lview = _titleLines[1];
//    lview.width = calloutContentWidth - _subtitleLabel.right - 16.0f;
//    lview.right = calloutContentWidth;
//    lview.center = CGPointMake(lview.center.x, _subtitleLabel.center.y);
//
//    CGSize labelTextSize = [_titleLabel.text sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(calloutContentWidth, NSIntegerMax)];
//    _titleLabel.frame = CGRectMake(0, _subtitleLabel.bottom + 5.0f, calloutContentWidth, labelTextSize.height);
//    [_titleLabel setAccessibilityLabel:@"Bill title"];
//
//    CGFloat maxLabelWidth = floorf(contentSize.width*0.5f);
//    CGSize sponsorSize = [_sponsorButton sizeThatFits:CGSizeMake(maxLabelWidth, NSIntegerMax)];
//    CGFloat labelWidth = sponsorSize.width < maxLabelWidth ? sponsorSize.width : maxLabelWidth;
//    _sponsorButton.frame = CGRectMake(0, _titleLabel.bottom + 12.0f, labelWidth, sponsorSize.height);
//
//    [_cosponsorsButton sizeToFit];
//    _cosponsorsButton.top =  _sponsorButton.top;
//    _cosponsorsButton.left = _sponsorButton.right + 10.0f;
//
//    [_callout layoutSubviews];
//
//    [_favoriteButton sizeToFit];
////    CGRect fromRect = [_scrollView convertRect:_sponsorButton.frame fromView:_callout.contentView];
////    CGFloat favButtonY = fromRect.origin.y + fromRect.size.height + _favoriteButton.imageView.height/2;
//    CGPoint fromPoint = [_scrollView convertPoint:_sponsorButton.center fromView:_callout.contentView];
//    _favoriteButton.right = _callout.right;
//    _favoriteButton.center = CGPointMake(_favoriteButton.center.x, fromPoint.y);
//
//    _summary.top = _callout.bottom+14.0f;
//    _summary.left = 15.0f;
//    _summary.width = contentSize.width - (_summary.left*2);
//    [_summary sizeToFit];
//
//    [_linkOutButton sizeToFit];
//    _linkOutButton.origin = CGPointMake(_summary.left, _summary.bottom+12.0f);
//
//    contentSize.height = _linkOutButton.bottom + 5.0f;
//    [_scrollView setContentSize:contentSize];
//}

#pragma mark - Private Methods

-(void)_initialize
{
    self.insets = UIEdgeInsetsMake(0, 4.0f, 16.0f, 4.0f);
    
//    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    _scrollView = [[UIScrollView alloc] init];
    [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    _scrollView.contentInset = self.insets;
//    [self addSubview:_scrollView];

    _callout = [[SFCalloutView alloc] initWithFrame:CGRectZero];
    [_callout setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [_scrollView addSubview:_callout];
    [self addSubview:_callout];

    _titleLabel = [[SFLabel alloc] init];
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont billTitleFont];
    _titleLabel.textColor = [UIColor titleColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.backgroundColor = [UIColor clearColor];
//    [_callout addSubview:_titleLabel];
    [_callout addSubview:_titleLabel];

    _subtitleLabel = [[SSLabel alloc] init];
    [_subtitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    _subtitleLabel.font = [UIFont subitleStrongFont];
    _subtitleLabel.textColor = [UIColor subtitleColor];
    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    _subtitleLabel.backgroundColor = [UIColor clearColor];
    [_subtitleLabel setAccessibilityLabel:@"Date of introduction"];
//    [_callout addSubview:_subtitleLabel];

//    CGRect lineRect = CGRectMake(0, 0, 2.0f, 1.0f);
//    _titleLines = @[[[SSLineView alloc] initWithFrame:lineRect], [[SSLineView alloc] initWithFrame:lineRect]];
//    for (SSLineView *lview in _titleLines) {
//        lview.lineColor = [UIColor detailLineColor];
//        [_callout addSubview:lview];
//    }

    _sponsorButton = [SFCongressButton button];
    [_sponsorButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    _sponsorButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_sponsorButton setAccessibilityLabel:@"Bill sponsor"];
//    [_callout addSubview:_sponsorButton];

    _cosponsorsButton = [SFCongressButton button];
    [_cosponsorsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_cosponsorsButton setAccessibilityLabel:@"Bill co-sponsors"];
//    [_callout addSubview:_cosponsorsButton];

    _favoriteButton = [[SFFavoriteButton alloc] init];
    [_favoriteButton setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [_scrollView addSubview:_favoriteButton];

    _summary = [[SFLabel alloc] init];
    [_summary setTranslatesAutoresizingMaskIntoConstraints:NO];
    _summary.numberOfLines = 0;
    _summary.lineBreakMode = NSLineBreakByWordWrapping;
    _summary.font = [UIFont bodyTextFont];
    _summary.textColor = [UIColor primaryTextColor];
    _summary.textAlignment = NSTextAlignmentLeft;
    _summary.verticalTextAlignment = SSLabelVerticalTextAlignmentTop;
    _summary.backgroundColor = self.backgroundColor;
    [_summary setAccessibilityLabel:@"Bill summary"];
//    [_scrollView addSubview:_summary];

    _linkOutButton = [SFCongressButton buttonWithTitle:@"View Full Text"];
    [_linkOutButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_linkOutButton setAccessibilityHint:@"Load Open Congress dot org in Safari to view the full text of this bill."];
//    [_scrollView addSubview:_linkOutButton];
}

@end
