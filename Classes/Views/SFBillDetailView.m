//
//  SFBillDetailView.m
//  Congress
//
//  Created by Daniel Cloud on 12/4/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFBillDetailView.h"
#import "SFCalloutBackgroundView.h"
#import "SFLineView.h"

@implementation SFBillDetailView
{
    SFCalloutBackgroundView *_calloutBackground;
    SFLineView *_decorativeLine;
}

@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;
@synthesize summary = _summary;
@synthesize sponsorButton = _sponsorButton;
@synthesize cosponsorsButton = _cosponsorsButton;
@synthesize linkOutButton = _linkOutButton;
@synthesize followButton = _followButton;

#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self _initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)updateContentConstraints {
    CGRect bounds = [self bounds];

    NSDictionary *views = @{
        @"callout": _calloutBackground,
        @"line": _decorativeLine,
        @"title": _titleLabel,
        @"date": _dateLabel,
        @"summary": _summary,
        @"sponsor": _sponsorButton,
        @"cosponsors": _cosponsorsButton,
        @"linkOut": _linkOutButton,
        @"follow": _followButton
    };



    CGFloat calloutInset = 20.0f;
    CGFloat calloutBottomConstant = calloutInset + _calloutBackground.contentInset.bottom;
    CGSize maxTitle = CGSizeMake((bounds.size.width - 2 * calloutInset), CGFLOAT_MAX);
    CGSize titleSize = [_titleLabel sizeThatFits:maxTitle];
    CGSize maxSummary = CGSizeMake((bounds.size.width - self.contentInset.left - self.contentInset.right), CGFLOAT_MAX);
    CGSize summarySize = [_summary sizeThatFits:maxSummary];
    NSDictionary *metrics = @{
        @"calloutInset": @(calloutInset),
        @"contentInset": @(self.contentInset.left),
        @"maxWidth": @(bounds.size.width),
        @"titleHeight": @(titleSize.height),
        @"summaryHeight": @(summarySize.height)
    };

//    MARK: Callout contents and vertical orientation
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[callout]"
                                                                                         options:0
                                                                                         metrics:metrics views:views]];

    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[callout(maxWidth)]|"
                                                                                         options:0
                                                                                         metrics:metrics views:views]];

    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_calloutBackground attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                       toItem:_sponsorButton attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f constant:calloutBottomConstant]];

//    Vertival layout
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(calloutInset)-[date]-[title(>=titleHeight@750)]-[sponsor]"
                                                                                         options:0
                                                                                         metrics:metrics views:views]];
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[callout]-[summary]-[linkOut]"
                                                                                         options:0
                                                                                         metrics:metrics views:views]];
//    MARK: _dateLabel
    [_dateLabel sizeToFit];
    CGFloat dateWidth = _dateLabel.width + 20.0f;
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_dateLabel attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f constant:dateWidth]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_dateLabel attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0f constant:1.0f]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_dateLabel attribute:NSLayoutAttributeHeight constant:_dateLabel.height]];

//    MARK: _decorativeLine
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_decorativeLine attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0 constant:1.0]];
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(calloutInset)-[line][follow]"
                                                                                         options:0
                                                                                         metrics:metrics views:views]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_decorativeLine attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_dateLabel attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0f constant:1.0f]];

//    MARK: _titleLabel
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(calloutInset)-[title]-(calloutInset)-|"
                                                                                         options:0
                                                                                         metrics:metrics views:views]];

//    MARK: _sponsorButton
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_sponsorButton attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_titleLabel attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f constant:0]];

//    MARK: _cosponsorsButton
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[sponsor]-[cosponsors]" options:NSLayoutFormatAlignAllTop
                                                                                         metrics:metrics views:views]];

//    MARK: _followButton
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_followButton attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_dateLabel attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0f constant:-1.0f]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_followButton attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f constant:-_calloutBackground.contentInset.left]];
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(contentInset)-[summary]-(contentInset)-|" options:0
                                                                                         metrics:metrics views:views]];

    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_summary attribute:NSLayoutAttributeHeight constant:summarySize.height]];

//    MARK: _linkOutButton
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_linkOutButton attribute:NSLayoutAttributeLeft toItem:_summary]];
}

#pragma mark - Private Methods

- (void)_initialize {
    _calloutBackground = [[SFCalloutBackgroundView alloc] initWithFrame:CGRectZero];
    _calloutBackground.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_calloutBackground];

    CGRect lineRect = CGRectMake(0, 0, 2.0f, 1.0f);
    _decorativeLine = [[SFLineView alloc] initWithFrame:lineRect];
    _decorativeLine.translatesAutoresizingMaskIntoConstraints = NO;
    _decorativeLine.lineColor = [UIColor detailLineColor];
    [self addSubview:_decorativeLine];

    _titleLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont billTitleFont];
    _titleLabel.textColor = [UIColor titleColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_titleLabel];

    _dateLabel = [[SAMLabel alloc] initWithFrame:CGRectZero];
    _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _dateLabel.font = [UIFont subitleStrongFont];
    _dateLabel.textColor = [UIColor subtitleColor];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.backgroundColor = [UIColor secondaryBackgroundColor];
    [_dateLabel setAccessibilityLabel:@"Date of introduction"];
    [self addSubview:_dateLabel];

    _sponsorButton = [SFCongressButton button];
    _sponsorButton.translatesAutoresizingMaskIntoConstraints = NO;
    _sponsorButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_sponsorButton setAccessibilityLabel:@"Bill sponsor"];
    [self addSubview:_sponsorButton];

    _cosponsorsButton = [SFCongressButton button];
    _cosponsorsButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_cosponsorsButton setAccessibilityLabel:@"Bill co-sponsors"];
    [self addSubview:_cosponsorsButton];

    _followButton = [SFFollowButton button];
    _followButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_followButton];

    _summary = [[SFLabel alloc] initWithFrame:CGRectZero];
    _summary.translatesAutoresizingMaskIntoConstraints = NO;
    _summary.numberOfLines = 0;
    _summary.lineBreakMode = NSLineBreakByWordWrapping;
    _summary.font = [UIFont bodyTextFont];
    _summary.textColor = [UIColor primaryTextColor];
    _summary.textAlignment = NSTextAlignmentLeft;
    _summary.verticalTextAlignment = SAMLabelVerticalTextAlignmentTop;
    _summary.backgroundColor = self.backgroundColor;
    [_summary setAccessibilityLabel:@"Bill summary"];
    [self addSubview:_summary];

    _linkOutButton = [SFCongressButton buttonWithTitle:@"View Full Text"];
    _linkOutButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_linkOutButton setAccessibilityHint:@"Load Open Congress dot org in Safari to view the full text of this bill."];
    [self addSubview:_linkOutButton];
}

@end
