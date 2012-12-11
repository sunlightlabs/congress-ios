//
//  SFBillDetailView.m
//  Congress
//
//  Created by Daniel Cloud on 12/4/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFBillDetailView.h"

@implementation SFBillDetailView
{
    NSUInteger _horizontalMargin;
    NSUInteger _verticalMargin;
}

@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;
@synthesize summary = _summary;
@synthesize sponsorName = _sponsorName;

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
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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

//    CGSize labelTextSize = [_titleLabel.text sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(size.width, 140)];
    _titleLabel.frame = CGRectMake(_horizontalMargin, 0.0f, size.width-_horizontalMargin, 0.0f);
    [_titleLabel sizeToFit];

    CGFloat offset_y = _titleLabel.frame.origin.y + _titleLabel.frame.size.height;
    _dateLabel.frame = CGRectMake(_horizontalMargin, offset_y, size.width-_horizontalMargin, 0.0f);
    [_dateLabel sizeToFit];

    offset_y = _dateLabel.frame.origin.y + _dateLabel.frame.size.height;
    _sponsorName.frame = CGRectMake(_horizontalMargin, offset_y, size.width-_horizontalMargin, 0.0f);
    [_sponsorName sizeToFit];

    offset_y = _sponsorName.frame.origin.y + _sponsorName.frame.size.height;
    _summary.frame = CGRectMake(_horizontalMargin, offset_y, size.width-_horizontalMargin, 0.0f);
    [_summary sizeToFit];
}

#pragma mark - Private Methods

-(void)_initialize
{
    _horizontalMargin = 8;
    _verticalMargin = 6;
    self.backgroundColor = [UIColor whiteColor];
	self.opaque = YES;

    _titleLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_titleLabel];

    _dateLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _dateLabel.font = [UIFont systemFontOfSize:16.0f];
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_dateLabel];

    _sponsorName = [[SSLabel alloc] initWithFrame:CGRectZero];
    _sponsorName.font = [UIFont systemFontOfSize:16.0f];
    _sponsorName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _sponsorName.textAlignment = NSTextAlignmentLeft;
    _sponsorName.verticalTextAlignment = SSLabelVerticalTextAlignmentTop;
    [self addSubview:_sponsorName];

    
    _summary = [[SSLabel alloc] initWithFrame:CGRectZero];
    _summary.numberOfLines = 0;
    _summary.lineBreakMode = NSLineBreakByWordWrapping;
    _summary.font = [UIFont systemFontOfSize:14.0f];
    _summary.textColor = [UIColor blackColor];
    _summary.textAlignment = NSTextAlignmentLeft;
    _summary.verticalTextAlignment = SSLabelVerticalTextAlignmentTop;
//    _summary.backgroundColor = [UIColor colorWithWhite:0.400 alpha:1.000]; // Gray for dev purposes
    [self addSubview:_summary];
}


@end
