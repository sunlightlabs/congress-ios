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
    SSLineView *_settingsLine;
    SSLineView *_disclaimerLineView;
    NSMutableArray *_scrollConstraints;
}

@synthesize scrollView = _scrollView;
@synthesize headerLabel = _headerLabel;
@synthesize disclaimerLabel = _disclaimerLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize logoView = _logoView;
@synthesize donateButton = _donateButton;
@synthesize joinButton = _joinButton;
@synthesize feedbackButton = _feedbackButton;
@synthesize analyticsOptOutSwitch = _analyticsOptOutSwitch;
@synthesize settingsLabel = _settingsLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

#pragma mark - SFSettingsSectionView

- (void)_initialize
{
    _scrollConstraints = [NSMutableArray array];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.backgroundColor = [UIColor primaryBackgroundColor];
    [self addSubview:_scrollView];
    
    _settingsLine = [[SSLineView alloc] initWithFrame:CGRectZero];
    _settingsLine.translatesAutoresizingMaskIntoConstraints = NO;
    _settingsLine.lineColor = [UIColor detailLineColor];
    [_scrollView addSubview:_settingsLine];
    
    _settingsLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _settingsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _settingsLabel.font = [UIFont cellDecorativeTextFont];
    _settingsLabel.textAlignment = NSTextAlignmentCenter;
    _settingsLabel.textColor = [UIColor secondaryTextColor];
    _settingsLabel.backgroundColor = [UIColor primaryBackgroundColor];
    _settingsLabel.numberOfLines = 1;
    _settingsLabel.text = @"Settings";
    [_scrollView addSubview:_settingsLabel];
    
    _headerLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _headerLabel.textColor = [UIColor subtitleColor];
    _headerLabel.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_headerLabel];
    
//    CGRect lineRect = CGRectMake(0, 0, 20.0f, 1.0f);
//    _leftLineView = [[SSLineView alloc] initWithFrame:lineRect];
//    _leftLineView.lineColor = [UIColor detailLineColor];
//    [self addSubview:_leftLineView];
//    _rightLineView = [[SSLineView alloc] initWithFrame:lineRect];
//    _rightLineView.lineColor = [UIColor detailLineColor];
//    [self addSubview:_rightLineView];

    _logoView = [[UIImageView alloc] initWithImage:[UIImage sfLogoImage]];
    _logoView.translatesAutoresizingMaskIntoConstraints = NO;
    _logoView.accessibilityLabel = @"Sunlight Foundation logo";
    _logoView.accessibilityHint = @"Congress app was created by the Sunlight Foundation";
    [_scrollView addSubview:_logoView];

    _feedbackButton = [SFCongressButton buttonWithTitle:@"Email Feedback"];
    _feedbackButton.translatesAutoresizingMaskIntoConstraints = NO;
    _feedbackButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _feedbackButton.accessibilityLabel = @"Email Feedback";
    _feedbackButton.accessibilityHint = @"Let us know any suggestions or issues you have with the app";
    [_scrollView addSubview:_feedbackButton];

    _donateButton = [SFCongressButton buttonWithTitle:@"Donate"];
    _donateButton.translatesAutoresizingMaskIntoConstraints = NO;
    _donateButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _donateButton.accessibilityLabel  = @"Donate";
    _donateButton.accessibilityHint = @"Support projects like this app with a donation to the Sunlight Foundation";
    [_scrollView addSubview:_donateButton];

    _joinButton = [SFCongressButton buttonWithTitle:@"Join Us"];
    _joinButton.translatesAutoresizingMaskIntoConstraints = NO;
    _joinButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _joinButton.accessibilityLabel = @"Join Us";
    _joinButton.accessibilityHint = @"Find out ways you can help us open the government";
    [_scrollView addSubview:_joinButton];
    
    _disclaimerLineView = [[SSLineView alloc] initWithFrame:CGRectZero];
    _disclaimerLineView.translatesAutoresizingMaskIntoConstraints = NO;
    _disclaimerLineView.lineColor = [UIColor detailLineColor];
    [_scrollView addSubview:_disclaimerLineView];

    _disclaimerLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _disclaimerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _disclaimerLabel.font = [UIFont subitleFont];
    _disclaimerLabel.textColor = [UIColor subtitleColor];
    _disclaimerLabel.backgroundColor = [UIColor clearColor];
    _disclaimerLabel.numberOfLines = 0;
    [_scrollView addSubview:_disclaimerLabel];

    _descriptionLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _descriptionLabel.font = [UIFont bodyTextFont];
    _descriptionLabel.textColor = [UIColor primaryTextColor];
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    _descriptionLabel.numberOfLines = 0;
    [_scrollView addSubview:_descriptionLabel];

    _analyticsOptOutSwitchLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _analyticsOptOutSwitchLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _analyticsOptOutSwitchLabel.font = [UIFont subitleFont];
    _analyticsOptOutSwitchLabel.textColor = [UIColor subtitleColor];
    _analyticsOptOutSwitchLabel.backgroundColor = [UIColor clearColor];
    _analyticsOptOutSwitchLabel.numberOfLines = 0;
    [_scrollView addSubview:_analyticsOptOutSwitchLabel];

    _analyticsOptOutSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    _analyticsOptOutSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    _analyticsOptOutSwitch.backgroundColor = [UIColor primaryBackgroundColor];
    [_analyticsOptOutSwitch setOn:![[SFAppSettings sharedInstance] googleAnalyticsOptOut]];
    [_scrollView addSubview:_analyticsOptOutSwitch];

}

- (void)updateContentConstraints
{
    [_scrollView removeConstraints:_scrollConstraints];
    [_scrollConstraints removeAllObjects];
    
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    
    NSDictionary *metrics = @{@"offset": @(self.contentOffset),
                              @"contentWidth": @(appFrame.size.width - (self.contentOffset * 2))};
    
    NSDictionary *views = @{@"scroll": _scrollView,
                            @"logo": _logoView,
                            @"header": _headerLabel,
                            @"disclaimer": _disclaimerLabel,
                            @"description": _descriptionLabel,
                            @"donate": _donateButton,
                            @"join": _joinButton,
                            @"feedback": _feedbackButton,
                            @"optOut": _analyticsOptOutSwitch,
                            @"settingsLine": _settingsLine,
                            @"settingsLabel": _settingsLabel};
    
    [_settingsLabel sizeToFit];
    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[settingsLine]|" options:0 metrics:metrics views:views]];
    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offset)-[settingsLabel]" options:0 metrics:metrics views:views]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_settingsLine
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_settingsLabel
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0
                                                                constant:0.0]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_settingsLine
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:1.0]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_settingsLabel
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:_settingsLabel.width + 10.0]];
    
    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offset)-[logo]-(30)-[description]-(30)-[settingsLabel]" options:0 metrics:metrics views:views]];
    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offset)-[description(contentWidth)]-(offset)-|" options:0 metrics:metrics views:views]];
    
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_logoView
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_scrollView
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0
                                                                constant:0.0]];
    
    [_scrollView addConstraints:_scrollConstraints];
    
    [self.constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scroll]|" options:0 metrics:metrics views:views]];
    [self.constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:0 metrics:metrics views:views]];
}

//- (void)layoutSubviews
//{
//    CGSize size = self.bounds.size;
//    CGSize contentSize = CGSizeZero;
//    contentSize.width = size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
//
//    CGFloat buttonWidth = floorf(size.width*0.5f);
//    CGFloat buttonLeft = floorf(((size.width-buttonWidth)/2));
//
//    _logoView.top = 20.0f;
//    _logoView.left = _scrollView.contentInset.left;
//    [_logoView sizeToFit];
//
//    [_donateButton sizeToFit];
//    _donateButton.width = buttonWidth;
//    _donateButton.left = buttonLeft;
//    _donateButton.top = _logoView.bottom + 16.0f;
//
//    [_joinButton sizeToFit];
//    _joinButton.width = buttonWidth;
//    _joinButton.left = buttonLeft;
////    _joinButton.top = _donateButton.bottom - _donateButton.verticalPadding + 16.0f;
//    _joinButton.top = _donateButton.bottom;
//
//    [_feedbackButton sizeToFit];
//    _feedbackButton.width = buttonWidth;
//    _feedbackButton.left = buttonLeft;
////    _feedbackButton.top = _joinButton.bottom - _joinButton.verticalPadding + 16.0f;
//    _feedbackButton.top = _joinButton.bottom;
//
//    [_headerLabel sizeToFit];
//    _headerLabel.top = _feedbackButton.bottom + 16.0f;
//    _leftLineView.width = 20.0f;
//    _leftLineView.left = 10.0f;
//    _leftLineView.center = CGPointMake(_leftLineView.center.x, _headerLabel.center.y);
//
//    _headerLabel.left = _leftLineView.right + 10.0f;
//
//    _rightLineView.width = size.width - _headerLabel.right - 20.0f;
//    _rightLineView.left = _headerLabel.right + 10.0f;
//    _rightLineView.center = CGPointMake(_rightLineView.center.x, _headerLabel.center.y);
//
//    CGFloat scrollviewOffset = _headerLabel.bottom + 20.0f;
//    _scrollView.frame = CGRectMake(0, scrollviewOffset, size.width, size.height-scrollviewOffset);
//
//    CGSize fitSize = [_descriptionLabel sizeThatFits:CGSizeMake(contentSize.width, CGFLOAT_MAX)];
//    _descriptionLabel.frame = CGRectMake(0, 0, fitSize.width, fitSize.height);
//
//    _disclaimerLineView.width = contentSize.width;
//    _disclaimerLineView.top = _descriptionLabel.bottom + 16.0f;
//
//    _disclaimerLabel.width = contentSize.width;
//    [_disclaimerLabel sizeToFit];
//    _disclaimerLabel.top = _disclaimerLineView.bottom + 30.0f;
//
//    _analyticsOptOutSwitchLabel.width = 100.0f;
//    [_analyticsOptOutSwitchLabel sizeToFit];
//    _analyticsOptOutSwitchLabel.top = _disclaimerLabel.bottom + 15.0f;
//
//    _analyticsOptOutSwitch.width = contentSize.width;
//    _analyticsOptOutSwitch.height = 10.0f;
//    _analyticsOptOutSwitch.top = _disclaimerLabel.bottom + 15.0f;
//    _analyticsOptOutSwitch.left = 100.0f;
//    _analyticsOptOutSwitch.accessibilityLabel = @"Analytics opt-out";
//    _analyticsOptOutSwitch.accessibilityHint = @"Enable or disable anonymous usage statistics";
//
//    contentSize.height = _analyticsOptOutSwitch.bottom + 10.0f;
//    [_scrollView setContentSize:contentSize];
//}

@end
