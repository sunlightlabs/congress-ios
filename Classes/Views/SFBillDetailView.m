//
//  SFBillDetailView.m
//  Congress
//
//  Created by Daniel Cloud on 12/4/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFBillDetailView.h"

@implementation SFBillDetailView

@synthesize billTitleLabel = _billTitleLabel;
@synthesize billSummary = _billSummary;

#pragma mark - UIView

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

    CGSize labelTextSize = [_billTitleLabel.text sizeWithFont:_billTitleLabel.font];
    _billTitleLabel.frame = CGRectMake(8.0f, 4.0f, size.width - 16.0f, labelTextSize.height);
    NSLog(@"labelTextSize.height: %f", labelTextSize.height);

    CGFloat offset_y = _billTitleLabel.frame.origin.y + labelTextSize.height + 6.0f;
    _billSummary.frame = CGRectMake(6.0f, offset_y, size.width - 16.0f, size.height);
    NSLog(@"_billTitleLabel.frame.origin.y: %f", _billTitleLabel.frame.origin.y);
    NSLog(@"offset_y: %f", offset_y);
    NSLog(@"size.height: %f", size.height);
    NSLog(@"_billSummary.text: %@", _billSummary.text);
}

#pragma mark - Private Methods

-(void)_initialize
{
    _billTitleLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _billTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    _billTitleLabel.backgroundColor = [UIColor colorWithWhite:0.895 alpha:1.000]; // Gray for dev purposes
    _billTitleLabel.textColor = [UIColor blackColor];
    _billTitleLabel.textAlignment = NSTextAlignmentLeft;
    _billTitleLabel.verticalTextAlignment = SSLabelVerticalTextAlignmentTop;
    _billTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    [self addSubview:_billTitleLabel];

    _billSummary = [[UITextView alloc] initWithFrame:CGRectZero];
    _billSummary.font = [UIFont systemFontOfSize:14.0f];
    _billSummary.textColor = [UIColor blackColor];
    _billTitleLabel.backgroundColor = [UIColor colorWithWhite:0.895 alpha:1.000]; // Gray for dev purposes

    [self addSubview:_billSummary];
}


@end
