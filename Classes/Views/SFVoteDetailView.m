//
//  SFVoteDetailView.m
//  Congress
//
//  Created by Daniel Cloud on 2/7/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFVoteDetailView.h"
#import "SFCongressButton.h"

@implementation SFVoteDetailView
{
    UIScrollView *_scrollView;
}

@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;
@synthesize resultLabel = _resultLabel;
@synthesize voteTable = _voteTable;
@synthesize followedVoterLabel = _followedVoterLabel;
@synthesize followedVoterTable = _followedVoterTable;

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

    CGSize labelTextSize = [_titleLabel.text sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(size.width, 88)];
    _titleLabel.size = CGSizeMake(self.insetsWidth, labelTextSize.height);
    _titleLabel.origin = CGPointMake(self.leftInset, 5.0f);

    CGSize dateLabelTextSize = [_dateLabel.text sizeWithFont:_dateLabel.font constrainedToSize:CGSizeMake(size.width, 88)];
    _dateLabel.frame = CGRectMake(self.leftInset, _titleLabel.bottom+5.0f, self.insetsWidth, dateLabelTextSize.height);

    CGSize resultLabelTextSize = [_resultLabel.text sizeWithFont:_resultLabel.font constrainedToSize:CGSizeMake(size.width, 88)];
    _resultLabel.frame = CGRectMake(self.leftInset, _dateLabel.bottom+10.0f, self.insetsWidth, resultLabelTextSize.height);

    CGFloat scrollViewTop = _resultLabel.bottom + 12.0f;
    _voteTable.frame = CGRectMake(0.0f, 0.0f, _scrollView.width, _voteTable.contentSize.height);
    CGSize voterLabelSize = [_followedVoterLabel.text sizeWithFont:_followedVoterLabel.font constrainedToSize:CGSizeMake(size.width, 88)];
    _followedVoterLabel.frame = CGRectMake(0.0f, _voteTable.bottom+ 15.0f, _scrollView.width, voterLabelSize.height);
    _followedVoterTable.frame = CGRectMake(0.0f, _followedVoterLabel.bottom + 6.0f, _scrollView.width, _followedVoterTable.contentSize.height);

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

    _titleLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.textColor = [UIColor primaryTextColor];
    _titleLabel.backgroundColor = self.backgroundColor;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_titleLabel];

    _resultLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _resultLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    _resultLabel.numberOfLines = 1;
    _resultLabel.font = [UIFont systemFontOfSize:18];
    _resultLabel.textColor = [UIColor primaryTextColor];
    _resultLabel.backgroundColor = self.backgroundColor;
    _resultLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_resultLabel];

    _dateLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _dateLabel.font = [UIFont systemFontOfSize:16.0f];
    _dateLabel.textColor = [UIColor primaryTextColor];
    _dateLabel.backgroundColor = self.backgroundColor;
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_dateLabel];

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
