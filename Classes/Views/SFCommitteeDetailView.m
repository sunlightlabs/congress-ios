//
//  SFCommitteeDetailView.m
//  Congress
//
//  Created by Jeremy Carbaugh on 8/14/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteeDetailView.h"
#import "SFCalloutBackgroundView.h"
#import "SFLineView.h"

@implementation SFCommitteeDetailView {
    SFCalloutBackgroundView *_calloutBackground;
    SFLineView *_titleLine;
}

@synthesize prefixNameLabel = _prefixNameLabel;
@synthesize primaryNameLabel = _primaryNameLabel;
@synthesize callButton = _callButton;
@synthesize followButton = _followButton;
@synthesize websiteButton = _websiteButton;
@synthesize subcommitteeListView = _subcommitteeListView;
@synthesize noSubcommitteesLabel = _noSubcommitteesLabel;

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

- (void)_initialize {
    self.translatesAutoresizingMaskIntoConstraints = NO;

    _calloutBackground = [[SFCalloutBackgroundView alloc] initWithFrame:CGRectZero];
    _calloutBackground.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_calloutBackground];

    _titleLine = [[SFLineView alloc] initWithFrame:CGRectMake(0, 0, 2.0f, 1.0f)];
    _titleLine.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLine.lineColor = [UIColor detailLineColor];
    [self addSubview:_titleLine];

    _prefixNameLabel = [[SAMLabel alloc] initWithFrame:CGRectZero];
    _prefixNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _prefixNameLabel.font = [UIFont subitleEmFont];
    _prefixNameLabel.textColor = [UIColor subtitleColor];
    _prefixNameLabel.textAlignment = NSTextAlignmentCenter;
    _prefixNameLabel.backgroundColor = [UIColor secondaryBackgroundColor];
    [_prefixNameLabel setIsAccessibilityElement:NO];
    [self addSubview:_prefixNameLabel];

    _primaryNameLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _primaryNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _primaryNameLabel.numberOfLines = 3;
    _primaryNameLabel.verticalTextAlignment = SAMLabelVerticalTextAlignmentTop;
    _primaryNameLabel.font = [UIFont billTitleFont];
    _primaryNameLabel.textColor = [UIColor titleColor];
    _primaryNameLabel.textAlignment = NSTextAlignmentLeft;
    _primaryNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _primaryNameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_primaryNameLabel];

    _callButton = [[SFCongressButton alloc] initWithFrame:CGRectZero];
    _callButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_callButton setTitle:@"Call Committee" forState:UIControlStateNormal];
    [_callButton setAccessibilityHint:@"Tap to initiate a call to the committee's office"];
    [self addSubview:_callButton];

    _followButton = [SFFollowButton button];
    _followButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_followButton];

    _websiteButton = [SFImageButton buttonWithDefaultImage:[UIImage websiteImage]];
    _websiteButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_websiteButton];

    _noSubcommitteesLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _noSubcommitteesLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _noSubcommitteesLabel.numberOfLines = 0;
    _noSubcommitteesLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _noSubcommitteesLabel.font = [UIFont bodyTextFont];
    _noSubcommitteesLabel.textColor = [UIColor primaryTextColor];
    _noSubcommitteesLabel.textAlignment = NSTextAlignmentLeft;
    _noSubcommitteesLabel.verticalTextAlignment = SAMLabelVerticalTextAlignmentTop;
    _noSubcommitteesLabel.backgroundColor = self.backgroundColor;
    [self addSubview:_noSubcommitteesLabel];
}

- (void)updateContentConstraints {
    NSDictionary *views = @{
        @"callout": _calloutBackground,
        @"prefixName": self.prefixNameLabel,
        @"line": _titleLine,
        @"primaryName": self.primaryNameLabel,
        @"callButton": self.callButton,
        @"websiteButton": self.websiteButton,
        @"follow": self.followButton,
    };

    [self.primaryNameLabel sizeToFit];
    CGFloat nameHeight = ceilf(self.primaryNameLabel.numberOfLines * self.primaryNameLabel.font.lineHeight);

    [self.prefixNameLabel sizeToFit];
    self.prefixNameLabel.textAlignment = NSTextAlignmentCenter;

    CGFloat prefixNameWidth = ceilf(self.prefixNameLabel.size.width + 18.0f);
    CGFloat calloutInset = self.contentInset.left + _calloutBackground.contentInset.left;
    NSDictionary *metrics = @{ @"calloutInset": @(calloutInset),
                               @"contentInset": @(self.contentInset.left),
                               @"prefixNameWidth": @(prefixNameWidth),
                               @"nameHeight": @(nameHeight) };



    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[callout]"
                                                                                         options:0
                                                                                         metrics:metrics
                                                                                           views:views]];

    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[callout]|"
                                                                                         options:0
                                                                                         metrics:metrics
                                                                                           views:views]];

    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(contentInset)-[prefixName]-[primaryName]-[websiteButton]" options:0 metrics:metrics views:views]];

//    PrefixNameLabel
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.prefixNameLabel attribute:NSLayoutAttributeWidth constant:prefixNameWidth]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.prefixNameLabel attribute:NSLayoutAttributeCenterX toItem:self]];

//    Line
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(contentInset)-[line]-(contentInset)-|" options:0 metrics:metrics views:views]];
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[line(1)]" options:0 metrics:metrics views:views]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_titleLine attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.prefixNameLabel attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0f constant:0]];

//    Name label
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(contentInset)-[primaryName]"
                                                                                         options:0
                                                                                         metrics:metrics
                                                                                           views:views]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.primaryNameLabel attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                       toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f constant:nameHeight]];

//    websiteButton
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.websiteButton attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.primaryNameLabel attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f constant:-self.websiteButton.horizontalPadding]];

    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.websiteButton attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual toItem:self.callButton
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0f constant:0]];
//    callButton
//    No horizontal space needed as websiteButton has visual padding around image.
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.callButton attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                       toItem:self.websiteButton attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f constant:0]];

//    followButton
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.followButton attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f constant:(-self.contentInset.right + self.followButton.horizontalPadding)]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.followButton attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.primaryNameLabel attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f constant:-self.followButton.verticalPadding]];
    // Adjust primaryNameLabel based on followButton left
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.primaryNameLabel attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.followButton attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f constant:floorf(self.followButton.horizontalPadding / 2)]];


    // Callout height
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_calloutBackground attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.callButton attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f constant:22.0f]];

//    Subcommittees
    if (_subcommitteeListView) {
        if (![self.subviews containsObject:_subcommitteeListView]) {
            [self addSubview:_subcommitteeListView];
        }
        [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_subcommitteeListView attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_calloutBackground attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:5.0f]];
        [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_subcommitteeListView attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:0]];
        [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_subcommitteeListView attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self attribute:NSLayoutAttributeWidth
                                                                       multiplier:1.0f constant:0]];
    }

//    No subcommittees
    if (_noSubcommitteesLabel.text) {
        [_noSubcommitteesLabel sizeToFit];
        [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:_noSubcommitteesLabel attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_calloutBackground attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:14.0f]];
        [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(contentInset)-[noLabel]-(contentInset)-|"
                                                                                             options:0
                                                                                             metrics:metrics
                                                                                               views:@{ @"noLabel":_noSubcommitteesLabel }]];
    }
}

@end
