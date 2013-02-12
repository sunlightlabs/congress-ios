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
    _titleLabel.frame = CGRectMake(0.0f, 0.0f, size.width, labelTextSize.height);

    CGFloat offset_y = _titleLabel.frame.size.height + _titleLabel.frame.origin.y + 5.0f;
    CGSize dateLabelTextSize = [_dateLabel.text sizeWithFont:_dateLabel.font constrainedToSize:CGSizeMake(size.width, 88)];
    _dateLabel.frame = CGRectMake(0.0f, offset_y, size.width, dateLabelTextSize.height);

    offset_y = _dateLabel.frame.size.height + _dateLabel.frame.origin.y + 10.0f;
    CGSize resultLabelTextSize = [_resultLabel.text sizeWithFont:_resultLabel.font constrainedToSize:CGSizeMake(size.width, 88)];
    _resultLabel.frame = CGRectMake(0.0f, offset_y, size.width, resultLabelTextSize.height);

    offset_y = _resultLabel.frame.size.height + _resultLabel.frame.origin.y + 10.0f;
    _voteTable.frame = CGRectMake(0.0f, offset_y, size.width, (size.height - offset_y));
}

#pragma mark - Private

-(void)_initialize
{
    self.backgroundColor = [UIColor whiteColor];
	self.opaque = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;

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
