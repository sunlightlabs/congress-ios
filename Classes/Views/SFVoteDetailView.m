//
//  SFVoteDetailView.m
//  Congress
//
//  Created by Daniel Cloud on 2/7/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFVoteDetailView.h"

@implementation SFVoteDetailView

@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;
@synthesize resultLabel = _resultLabel;
@synthesize voteTable = _voteTable;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self _initialize];
    }
    return self;
}

-(void)layoutSubviews
{
    CGSize size = self.bounds.size;

    CGSize labelTextSize = [_titleLabel.text sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(size.width, 88)];
    _titleLabel.size = CGSizeMake(self.insetsWidth, labelTextSize.height);
    _titleLabel.origin = CGPointMake(self.leftInset, 5.0f);

    CGSize dateLabelTextSize = [_dateLabel.text sizeWithFont:_dateLabel.font constrainedToSize:CGSizeMake(size.width, 88)];
    _dateLabel.frame = CGRectMake(self.leftInset, _titleLabel.bottom+5.0f, self.insetsWidth, dateLabelTextSize.height);

    CGSize resultLabelTextSize = [_resultLabel.text sizeWithFont:_resultLabel.font constrainedToSize:CGSizeMake(size.width, 88)];
    _resultLabel.frame = CGRectMake(self.leftInset, _dateLabel.bottom+10.0f, self.insetsWidth, resultLabelTextSize.height);

    _voteTable.frame = CGRectMake(self.leftInset, _resultLabel.bottom+10.0f, self.insetsWidth, (size.height - _resultLabel.bottom));
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
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_titleLabel];

    _resultLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _resultLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    _resultLabel.numberOfLines = 1;
    _resultLabel.font = [UIFont systemFontOfSize:18];
    _resultLabel.textColor = [UIColor blackColor];
    _resultLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_resultLabel];

    _dateLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _dateLabel.font = [UIFont systemFontOfSize:16.0f];
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_dateLabel];

    _voteTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_voteTable];
}

@end
