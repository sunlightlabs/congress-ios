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
    
    NSDictionary *metrics = @{@"offset": @(self.contentInset.left),
                              @"offset2": @(self.contentInset.left * 2),
                              @"contentWidth": @(appFrame.size.width - (self.contentInset.left+self.contentInset.right))};
    
    NSDictionary *views = @{@"scroll": _scrollView,
                            @"logo": _logoView,
                            @"header": _headerLabel,
                            @"disclaimer": _disclaimerLabel,
                            @"description": _descriptionLabel,
                            @"donate": _donateButton,
                            @"join": _joinButton,
                            @"feedback": _feedbackButton,
                            @"optOut": _analyticsOptOutSwitch,
                            @"optOutLabel": _analyticsOptOutSwitchLabel,
                            @"settingsLine": _settingsLine,
                            @"settingsLabel": _settingsLabel};
    
    [_settingsLabel sizeToFit];
    [_analyticsOptOutSwitchLabel sizeToFit];
    
    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[settingsLine]|" options:0 metrics:metrics views:views]];
    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offset)-[settingsLabel]" options:0 metrics:metrics views:views]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_settingsLine
                                                               attribute:NSLayoutAttributeCenterY
                                                                  toItem:_settingsLabel]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_settingsLine
                                                               attribute:NSLayoutAttributeHeight
                                                                constant:1.0]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_settingsLabel
                                                               attribute:NSLayoutAttributeWidth
                                                                constant:_settingsLabel.width + 12.0]];
    
    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offset)-[logo]-(30)-[description]-(30)-[settingsLabel]-(15)-[optOut]-(8)-[disclaimer]" options:0 metrics:metrics views:views]];
    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offset)-[description(contentWidth)]-(offset)-|" options:0 metrics:metrics views:views]];
    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offset)-[optOutLabel]-(10)-[optOut]-(offset2)-|" options:0 metrics:metrics views:views]];
    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offset)-[disclaimer]-(offset)-|" options:0 metrics:metrics views:views]];
    
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_logoView
                                                               attribute:NSLayoutAttributeCenterX
                                                                  toItem:_scrollView]];
    
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_analyticsOptOutSwitchLabel
                                                               attribute:NSLayoutAttributeCenterY
                                                                  toItem:_analyticsOptOutSwitch]];
    
    [_scrollView addConstraints:_scrollConstraints];
    
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scroll]|" options:0 metrics:metrics views:views]];
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:0 metrics:metrics views:views]];
}

@end
