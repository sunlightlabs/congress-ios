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
@synthesize dateLabel = _dateLabel;
@synthesize summary = _summary;
@synthesize sponsorButton = _sponsorButton;
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

    CGSize labelTextSize = [_titleLabel.text sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(size.width, 88)];
    _titleLabel.frame = CGRectMake(0.0f, 0.0f, contentSize.width, labelTextSize.height);

    _dateLabel.frame = CGRectMake(0.0f, _titleLabel.bottom + 5.0f, contentSize.width, 0.0f);
    [_dateLabel sizeToFit];

    [_sponsorButton sizeToFit];
    _sponsorButton.top =  _dateLabel.bottom + 5.0f;

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

    _titleLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.textColor = [UIColor primaryTextColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.backgroundColor = self.backgroundColor;
    [_scrollView addSubview:_titleLabel];

    _dateLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _dateLabel.font = [UIFont systemFontOfSize:16.0f];
    _dateLabel.textColor = [UIColor primaryTextColor];
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    _dateLabel.backgroundColor = self.backgroundColor;
    [_scrollView addSubview:_dateLabel];

    _sponsorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sponsorButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_sponsorButton setTitleColor:[UIColor linkTextColor] forState:UIControlStateNormal];
    [_sponsorButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [_scrollView addSubview:_sponsorButton];

    
    _summary = [[SSLabel alloc] initWithFrame:CGRectZero];
    _summary.numberOfLines = 0;
    _summary.lineBreakMode = NSLineBreakByWordWrapping;
    _summary.font = [UIFont systemFontOfSize:14.0f];
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
