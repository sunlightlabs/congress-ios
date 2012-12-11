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

    CGSize labelTextSize = [_titleLabel.text sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(size.width, 140)];
    _titleLabel.frame = CGRectMake(0.0f, 0.0f, size.width, labelTextSize.height);

    CGFloat offset_y = _titleLabel.frame.origin.y + labelTextSize.height + 6.0f;
    CGSize dateLabelTextSize = [_dateLabel.text sizeWithFont:_dateLabel.font];
    _dateLabel.frame = CGRectMake(0.0f, offset_y, size.width, dateLabelTextSize.height);

    offset_y = _dateLabel.frame.origin.y + dateLabelTextSize.height + 6.0f;
    _summary.frame = CGRectMake(0.0f, offset_y, size.width, size.height);
}

#pragma mark - Private Methods

-(void)_initialize
{
    self.backgroundColor = [UIColor whiteColor];
	self.opaque = YES;

    _titleLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    _titleLabel.backgroundColor = [UIColor colorWithWhite:0.895 alpha:1.000]; // Gray for dev purposes
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.verticalTextAlignment = SSLabelVerticalTextAlignmentTop;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_titleLabel];

    _dateLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _dateLabel.font = [UIFont systemFontOfSize:16.0f];
//    _titleLabel.backgroundColor = [UIColor colorWithWhite:0.702 alpha:1.000]; // Gray for dev purposes
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    _dateLabel.verticalTextAlignment = SSLabelVerticalTextAlignmentTop;
    [self addSubview:_dateLabel];

    
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
