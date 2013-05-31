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
#import "SFAppSettings.h"
#import "TTTAttributedLabel.h"

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
@synthesize descriptionLabel = _descriptionLabel;
@synthesize logoView = _logoView;
@synthesize donateButton = _donateButton;
@synthesize joinButton = _joinButton;
@synthesize feedbackButton = _feedbackButton;
@synthesize analyticsOptOutSwitch = _analyticsOptOutSwitch;

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
    
    _feedbackButton = [SFCongressButton buttonWithTitle:@"Email Feedback"];
    _feedbackButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_feedbackButton];

    _donateButton = [SFCongressButton buttonWithTitle:@"Donate"];
    _donateButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_donateButton];

    _joinButton = [SFCongressButton buttonWithTitle:@"Join Us"];
    _joinButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_joinButton];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.backgroundColor = [UIColor primaryBackgroundColor];
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
    
    _descriptionLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    _descriptionLabel.font = [UIFont bodyTextFont];
    _descriptionLabel.textColor = [UIColor primaryTextColor];
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    _descriptionLabel.numberOfLines = 0;
    [_scrollView addSubview:_descriptionLabel];

    _analyticsOptOutSwitchLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _analyticsOptOutSwitchLabel.font = [UIFont subitleFont];
    _analyticsOptOutSwitchLabel.textColor = [UIColor subtitleColor];
    _analyticsOptOutSwitchLabel.backgroundColor = [UIColor clearColor];
    _analyticsOptOutSwitchLabel.numberOfLines = 0;
    [_scrollView addSubview:_analyticsOptOutSwitchLabel];
    
    _analyticsOptOutSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    _analyticsOptOutSwitch.backgroundColor = [UIColor primaryBackgroundColor];
    [_analyticsOptOutSwitch setOn:![[SFAppSettings sharedInstance] googleAnalyticsOptOut]];
    [_scrollView addSubview:_analyticsOptOutSwitch];

}

- (void)layoutSubviews
{
    CGSize size = self.bounds.size;
    CGSize contentSize = CGSizeZero;
    contentSize.width = size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;

    CGFloat buttonWidth = floorf(size.width*0.5f);
    CGFloat buttonLeft = floorf(((size.width-buttonWidth)/2));

    _logoView.top = 20.0f;
    _logoView.left = _scrollView.contentInset.left;
    [_logoView sizeToFit];

    [_donateButton sizeToFit];
    _donateButton.width = buttonWidth;
    _donateButton.left = buttonLeft;
    _donateButton.top = _logoView.bottom + 16.0f;

    [_joinButton sizeToFit];
    _joinButton.width = buttonWidth;
    _joinButton.left = buttonLeft;
//    _joinButton.top = _donateButton.bottom - _donateButton.verticalPadding + 16.0f;
    _joinButton.top = _donateButton.bottom;

    [_feedbackButton sizeToFit];
    _feedbackButton.width = buttonWidth;
    _feedbackButton.left = buttonLeft;
//    _feedbackButton.top = _joinButton.bottom - _joinButton.verticalPadding + 16.0f;
    _feedbackButton.top = _joinButton.bottom;

    [_headerLabel sizeToFit];
    _headerLabel.top = _feedbackButton.bottom + 16.0f;
    _leftLineView.width = 20.0f;
    _leftLineView.left = 10.0f;
    _leftLineView.center = CGPointMake(_leftLineView.center.x, _headerLabel.center.y);

    _headerLabel.left = _leftLineView.right + 10.0f;

    _rightLineView.width = size.width - _headerLabel.right - 20.0f;
    _rightLineView.left = _headerLabel.right + 10.0f;
    _rightLineView.center = CGPointMake(_rightLineView.center.x, _headerLabel.center.y);
    
    CGFloat scrollviewOffset = _headerLabel.bottom + 20.0f;
    _scrollView.frame = CGRectMake(0, scrollviewOffset, size.width, size.height-scrollviewOffset);

    CGSize fitSize = [_descriptionLabel sizeThatFits:CGSizeMake(contentSize.width, CGFLOAT_MAX)];
    _descriptionLabel.frame = CGRectMake(0, 0, fitSize.width, fitSize.height);

    _disclaimerLineView.width = contentSize.width;
    _disclaimerLineView.top = _descriptionLabel.bottom + 16.0f;

    _disclaimerLabel.width = contentSize.width;
    [_disclaimerLabel sizeToFit];
    _disclaimerLabel.top = _disclaimerLineView.bottom + 30.0f;
    
    _analyticsOptOutSwitchLabel.width = 100.0f;
    [_analyticsOptOutSwitchLabel sizeToFit];
    _analyticsOptOutSwitchLabel.top = _disclaimerLabel.bottom + 15.0f;
    
    _analyticsOptOutSwitch.width = contentSize.width;
    _analyticsOptOutSwitch.height = 10.0f;
    _analyticsOptOutSwitch.top = _disclaimerLabel.bottom + 15.0f;
    _analyticsOptOutSwitch.left = 100.0f;

    contentSize.height = _analyticsOptOutSwitch.bottom + 10.0f;
    [_scrollView setContentSize:contentSize];
}

@end
