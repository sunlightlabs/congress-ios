//
//  SFSettingsSectionView.m
//  Congress
//
//  Created by Daniel Cloud on 4/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFSettingsSectionView.h"
#import "SFCongressButton.h"
#import "SFLabel.h"

@implementation SFSettingsSectionView
{
    SSLineView *_leftLineView;
    SSLineView *_rightLineView;
    SSLineView *_disclaimerLineView;
}

@synthesize scrollView = _scrollView;
//@synthesize editFavoritesButton = _editFavoritesButton;
@synthesize headerLabel = _headerLabel;
@synthesize disclaimerLabel = _disclaimerLabel;
@synthesize descriptionView = _descriptionView;
@synthesize logoView = _logoView;
@synthesize donateButton = _donateButton;
@synthesize joinButton = _joinButton;
@synthesize feedbackButton = _feedbackButton;

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

#pragma mark - SFSettingsSectionView

- (void)_initialize
{
    _headerLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _headerLabel.textColor = [UIColor subtitleColor];
    _headerLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_headerLabel];
    CGRect lineRect = CGRectMake(0, 0, 20.0f, 1.0f);
    _leftLineView = [[SSLineView alloc] initWithFrame:lineRect];
    _leftLineView.lineColor = [UIColor detailLineColor];
    [self addSubview:_leftLineView];
    _rightLineView = [[SSLineView alloc] initWithFrame:lineRect];
    _rightLineView.lineColor = [UIColor detailLineColor];
    [self addSubview:_rightLineView];

    _logoView = [[UIImageView alloc] initWithImage:[UIImage sfLogoImage]];
    [self addSubview:_logoView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.contentInset = UIEdgeInsetsMake(0, 85.0f, 10.0f, 40.0f);
    [self addSubview:_scrollView];

//    _editFavoritesButton = [SFCongressButton buttonWithTitle:@"Edit Following"];
//    [_editFavoritesButton addTarget:self action:@selector(handleEditFavoritesPress) forControlEvents:UIControlEventTouchUpInside];
//    [_scrollView addSubview:_editFavoritesButton];

    _disclaimerLineView = [[SSLineView alloc] initWithFrame:lineRect];
    _disclaimerLineView.lineColor = [UIColor detailLineColor];
    [_scrollView addSubview:_disclaimerLineView];

    _disclaimerLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _disclaimerLabel.font = [UIFont subitleFont];
    _disclaimerLabel.textColor = [UIColor subtitleColor];
    _disclaimerLabel.backgroundColor = [UIColor clearColor];
    _disclaimerLabel.numberOfLines = 0;
    [_scrollView addSubview:_disclaimerLabel];
    
    _descriptionView = [[SSWebView alloc] initWithFrame:CGRectZero];
    _descriptionView.scalesPageToFit = NO;
    _descriptionView.scrollView.scrollEnabled = NO;
    _descriptionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_scrollView addSubview:_descriptionView];

    _feedbackButton = [SFCongressButton buttonWithTitle:@"Email Feedback"];
    _feedbackButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_feedbackButton];
    
    _donateButton = [SFCongressButton buttonWithTitle:@"Donate"];
    _donateButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_donateButton];
    
    _joinButton = [SFCongressButton buttonWithTitle:@"Join Us"];
    _joinButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_joinButton];

}

- (void)layoutSubviews
{
    CGSize size = self.bounds.size;

    [_headerLabel sizeToFit];
    _headerLabel.top = 36.0f;
    _leftLineView.width = 20.0f;
    _leftLineView.left = 10.0f;
    _leftLineView.center = CGPointMake(_leftLineView.center.x, _headerLabel.center.y);

    _headerLabel.left = _leftLineView.right + 10.0f;

    _rightLineView.width = size.width - _headerLabel.right - 20.0f;
    _rightLineView.left = _headerLabel.right + 10.0f;
    _rightLineView.center = CGPointMake(_rightLineView.center.x, _headerLabel.center.y);

    _logoView.top = _headerLabel.bottom + 20.0f;
    _logoView.left = _scrollView.contentInset.left;
    [_logoView sizeToFit];

    CGSize contentSize = CGSizeZero;
    contentSize.width = size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
    CGFloat scrollviewOffset = _logoView.bottom + 20.0f;
    _scrollView.frame = CGRectMake(0, scrollviewOffset, size.width, size.height-scrollviewOffset);

    _descriptionView.top = 0;
    _descriptionView.width = contentSize.width;

    [_donateButton sizeToFit];
    _donateButton.width = contentSize.width;
    _donateButton.top = _descriptionView.bottom + 16.0f;
    
    [_joinButton sizeToFit];
    _joinButton.width = contentSize.width;
    _joinButton.top = _donateButton.bottom - _donateButton.verticalPadding + 16.0f;
    
    [_feedbackButton sizeToFit];
    _feedbackButton.width = contentSize.width;
    _feedbackButton.top = _joinButton.bottom - _joinButton.verticalPadding + 16.0f;

    _disclaimerLineView.width = contentSize.width;
    _disclaimerLineView.top = _feedbackButton.bottom - _feedbackButton.verticalPadding + 30.0f;

    _disclaimerLabel.width = contentSize.width;
    [_disclaimerLabel sizeToFit];
    _disclaimerLabel.top = _disclaimerLineView.bottom + 30.0f;

    contentSize.height = _disclaimerLabel.bottom + 10.0f;
    [_scrollView setContentSize:contentSize];
}

@end
