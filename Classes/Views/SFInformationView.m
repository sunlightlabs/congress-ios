//
//  SFInformationView.m
//  Congress
//
//  Created by Daniel Cloud on 12/2/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFInformationView.h"
#import "SFLabel.h"
#import "TTTAttributedLabel.h"
#import "SFCongressButton.h"
#import "SFLineView.h"

@implementation SFInformationView
{
    SFLineView *_headerLine;
    NSMutableArray *_scrollConstraints;
}

@synthesize scrollView = _scrollView;
@synthesize headerLabel = _headerLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize logoView = _logoView;
@synthesize donateButton = _donateButton;
@synthesize joinButton = _joinButton;
@synthesize feedbackButton = _feedbackButton;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

#pragma mark - SFInformationView

- (void)_initialize {
    self.contentInset = UIEdgeInsetsMake(16.0f, 32.0f, 16.0f, 32.0f);

    _scrollConstraints = [NSMutableArray array];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.backgroundColor = [UIColor primaryBackgroundColor];
    [self addSubview:_scrollView];

    _headerLine = [[SFLineView alloc] initWithFrame:CGRectZero];
    _headerLine.translatesAutoresizingMaskIntoConstraints = NO;
    _headerLine.lineColor = [UIColor detailLineColor];
    [_scrollView addSubview:_headerLine];

    _headerLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _headerLabel.textColor = [UIColor subtitleColor];
    _headerLabel.textAlignment = NSTextAlignmentCenter;
    _headerLabel.backgroundColor = [UIColor primaryBackgroundColor];
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

    _descriptionLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _descriptionLabel.font = [UIFont bodyTextFont];
    _descriptionLabel.textColor = [UIColor primaryTextColor];
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    _descriptionLabel.numberOfLines = 0;
    [_scrollView addSubview:_descriptionLabel];
}

- (void)updateContentConstraints {
    [_scrollView removeConstraints:_scrollConstraints];
    [_scrollConstraints removeAllObjects];

    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];

    CGFloat verticalPadding = self.contentInset.left + self.contentInset.right;
    CGFloat descriptionWidth = appFrame.size.width - verticalPadding * 2;
    CGFloat contentWidth = appFrame.size.width - verticalPadding;
    CGFloat lineWidth = floorf(appFrame.size.width - verticalPadding / 2);
    NSDictionary *metrics = @{ @"offset": @(self.contentInset.left),
                               @"descriptionWidth": @(descriptionWidth),
                               @"contentWidth": @(contentWidth),
                               @"lineWidth": @(lineWidth) };

    NSDictionary *views = @{ @"scroll": _scrollView,
                             @"logo": _logoView,
                             @"header": _headerLabel,
                             @"headerLine": _headerLine,
                             @"description": _descriptionLabel,
                             @"donate": _donateButton,
                             @"join": _joinButton,
                             @"feedback": _feedbackButton };

    [_headerLabel sizeToFit];

    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offset)-[logo]-[donate][join][feedback]-(30)-[header]-[description]-(30)-|" options:0 metrics:metrics views:views]];


    //    MARK: _logoView and buttons
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_logoView
                                                               attribute:NSLayoutAttributeCenterX
                                                                  toItem:_scrollView]];

    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_donateButton
                                                               attribute:NSLayoutAttributeCenterX
                                                                  toItem:_scrollView]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_donateButton
                                                               attribute:NSLayoutAttributeWidth
                                                                  toItem:_logoView]];

    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_joinButton
                                                               attribute:NSLayoutAttributeCenterX
                                                                  toItem:_scrollView]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_joinButton
                                                               attribute:NSLayoutAttributeWidth
                                                                  toItem:_logoView]];

    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_feedbackButton
                                                               attribute:NSLayoutAttributeCenterX
                                                                  toItem:_scrollView]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_feedbackButton
                                                               attribute:NSLayoutAttributeWidth
                                                                  toItem:_logoView]];


    //    MARK: _headerLabel and _headerLine
    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offset)-[header]" options:0 metrics:metrics views:views]];
    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[headerLine(lineWidth)]-|" options:0 metrics:metrics views:views]];
    [_scrollConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(offset)-[header]" options:0 metrics:metrics views:views]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_headerLine
                                                               attribute:NSLayoutAttributeCenterY
                                                                  toItem:_headerLabel]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_headerLine
                                                               attribute:NSLayoutAttributeHeight
                                                                constant:1.0]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_headerLabel
                                                               attribute:NSLayoutAttributeWidth
                                                                constant:_headerLabel.width + 12.0]];

    //    MARK: _descriptionLabel
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_descriptionLabel attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_scrollView attribute:NSLayoutAttributeLeft
                                                              multiplier:1.0f constant:self.contentInset.left * 2]];
    [_scrollConstraints addObject:[NSLayoutConstraint constraintWithItem:_descriptionLabel attribute:NSLayoutAttributeWidth
                                                                constant:descriptionWidth]];

    [_scrollView addConstraints:_scrollConstraints];

    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scroll]|" options:0 metrics:metrics views:views]];
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scroll]|" options:0 metrics:metrics views:views]];
}

@end
