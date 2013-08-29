//
//  SFVoteDetailView.m
//  Congress
//
//  Created by Daniel Cloud on 2/7/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFVoteDetailView.h"
#import "SFCalloutView.h"
#import "SFCongressButton.h"

@implementation SFVoteDetailView
{
    UIScrollView *_scrollView;
    SFCalloutView *_calloutView;
    NSArray *_decorativeLines;
}

@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;
@synthesize resultLabel = _resultLabel;
@synthesize voteTable = _voteTable;
@synthesize followedVoterLabel = _followedVoterLabel;
@synthesize followedVoterTable = _followedVoterTable;
@synthesize billButton = _billButton;

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
    [super layoutSubviews];
    CGSize size = self.bounds.size;

    _calloutView.top = self.topInset;
    _calloutView.left = self.leftInset;
    _calloutView.width = self.insetsWidth;

    CGSize labelTextSize = [_titleLabel sizeThatFits:CGSizeMake(_calloutView.insetsWidth, CGFLOAT_MAX)];
    _titleLabel.size = CGSizeMake(_calloutView.insetsWidth, labelTextSize.height);
    _titleLabel.origin = CGPointMake(0, 0);
    
    /** **/
    
    [_resultLabel sizeToFit];
    _resultLabel.top = _titleLabel.bottom + 15.0f;
    _resultLabel.center = CGPointMake((_calloutView.insetsWidth/2), _resultLabel.center.y);
    
    SSLineView *lview = _decorativeLines[0];
    lview.width = _resultLabel.left - 17.0f;
    lview.left = 0;
    lview.center = CGPointMake(lview.center.x, _resultLabel.center.y);
    lview = _decorativeLines[1];
    lview.width = _calloutView.insetsWidth - _resultLabel.right - 17.0f;
    lview.right = _calloutView.insetsWidth;
    lview.center = CGPointMake(lview.center.x, _resultLabel.center.y);
    
    /** **/
    
    CGSize dateLabelTextSize = [_dateLabel.text sizeWithFont:_dateLabel.font constrainedToSize:CGSizeMake(_calloutView.insetsWidth, 88)];
    _dateLabel.frame = CGRectMake(0, _resultLabel.bottom + 15.0f, _calloutView.insetsWidth, dateLabelTextSize.height);
    _dateLabel.right = _calloutView.insetsWidth;
    
    [_billButton sizeToFit];
    _billButton.top = _resultLabel.bottom - 1.0f;
    _billButton.left = 200.0;

    /** **/
    
    [_calloutView layoutSubviews];

    _voteTable.frame = CGRectMake(0.0f, 0.0f, _scrollView.width, _voteTable.contentSize.height);
    CGSize voterLabelSize = [_followedVoterLabel.text sizeWithFont:_followedVoterLabel.font constrainedToSize:CGSizeMake(size.width, 88)];
    _followedVoterLabel.frame = CGRectMake(0.0f, _voteTable.bottom+ 15.0f, _scrollView.width, voterLabelSize.height);
    _followedVoterTable.frame = CGRectMake(0.0f, _followedVoterLabel.bottom + 6.0f, _scrollView.width, _followedVoterTable.contentSize.height);

    CGFloat scrollViewTop = _calloutView.bottom;
    CGFloat scrollViewHeight = size.height - scrollViewTop - self.bottomInset;
    _scrollView.frame = CGRectMake(self.leftInset, scrollViewTop, self.insetsWidth, scrollViewHeight);

    CGSize contentSize = CGSizeMake(self.insetsWidth, _followedVoterTable.bottom);
    [_scrollView setContentSize:contentSize];
}

- (void)setVoteTable:(UITableView *)voteTable
{
    if (_voteTable) {
        [_voteTable removeFromSuperview];
    }
    _voteTable = voteTable;
    _voteTable.scrollEnabled = NO;
    [_scrollView addSubview:_voteTable];
}

- (void)setFollowedVoterTable:(UITableView *)followedVoterTable
{
    if (_followedVoterTable) {
        [_followedVoterTable removeFromSuperview];
    }
    _followedVoterTable = followedVoterTable;
    _followedVoterTable.scrollEnabled = NO;
    [_scrollView addSubview:_followedVoterTable];
}

#pragma mark - Private

-(void)_initialize
{
	self.opaque = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    self.insets = UIEdgeInsetsMake(8.0f, 8.0f, 8.0f, 8.0f);

    _calloutView = [[SFCalloutView alloc] initWithFrame:CGRectZero];
    _calloutView.insets = UIEdgeInsetsMake(14.0f, 14.0f, 13.0f, 14.0f);
    [self addSubview:_calloutView];

    CGRect lineRect = CGRectMake(0, 0, 2.0f, 1.0f);
    _decorativeLines = @[[[SSLineView alloc] initWithFrame:lineRect], [[SSLineView alloc] initWithFrame:lineRect]];
    for (SSLineView *lview in _decorativeLines) {
        lview.lineColor = [UIColor detailLineColor];
        [_calloutView addSubview:lview];
    }


    _titleLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont billTitleFont];
    _titleLabel.textColor = [UIColor primaryTextColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_titleLabel setAccessibilityLabel:@"Roll call"];
    [_calloutView addSubview:_titleLabel];

    _resultLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _resultLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    _resultLabel.numberOfLines = 1;
    _resultLabel.font = [UIFont subitleEmFont];
    _resultLabel.textColor = [UIColor primaryTextColor];
    _resultLabel.backgroundColor = [UIColor clearColor];
    _resultLabel.textAlignment = NSTextAlignmentCenter;
    [_resultLabel setAccessibilityLabel:@"Result of roll call"];
    [_calloutView addSubview:_resultLabel];

    _dateLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _dateLabel.font = [UIFont subitleFont];
    _dateLabel.textColor = [UIColor subtitleColor];
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    [_dateLabel setAccessibilityLabel:@"Date of roll call"];
    [_calloutView addSubview:_dateLabel];
    
    _billButton = [SFCongressButton buttonWithTitle:@"View Bill"];
    [_billButton setAccessibilityLabel:@"View bill"];
    [_billButton setAccessibilityHint:@"Tap to view bill overview"];
    [_calloutView addSubview:_billButton];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self addSubview:_scrollView];

    _followedVoterLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _followedVoterLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _followedVoterLabel.font = [UIFont systemFontOfSize:16.0f];
    _followedVoterLabel.textColor = [UIColor primaryTextColor];
    _followedVoterLabel.backgroundColor = self.backgroundColor;
    _followedVoterLabel.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:_followedVoterLabel];

    _voteTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _voteTable.backgroundColor = self.backgroundColor;
    _voteTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _voteTable.scrollEnabled = NO;
    [_scrollView addSubview:_voteTable];

    _followedVoterTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _followedVoterTable.backgroundColor = self.backgroundColor;
    _followedVoterTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _followedVoterTable.scrollEnabled = NO;
    [_scrollView addSubview:_followedVoterTable];

}

@end
