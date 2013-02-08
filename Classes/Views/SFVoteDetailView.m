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

    CGFloat offset_y = _titleLabel.frame.size.height + _titleLabel.frame.origin.y;
    CGSize dateLabelTextSize = [_dateLabel.text sizeWithFont:_dateLabel.font constrainedToSize:CGSizeMake(size.width, 88)];
    _dateLabel.frame = CGRectMake(0.0f, offset_y, size.width, dateLabelTextSize.height);
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

    _dateLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _dateLabel.font = [UIFont systemFontOfSize:16.0f];
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_dateLabel];
}

@end
