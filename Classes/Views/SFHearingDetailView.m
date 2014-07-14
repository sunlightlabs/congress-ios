//
//  SFHearingDetailView.m
//  Congress
//
//  Created by Jeremy Carbaugh on 8/23/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFHearingDetailView.h"
#import "SFCalloutBackgroundView.h"

@implementation SFHearingDetailView

@synthesize committeePrefixLabel;
@synthesize committeePrimaryLabel;
@synthesize descriptionLabel;
@synthesize locationLabel;
@synthesize locationLabelLabel;

@synthesize occursAtLabel;
@synthesize urlButton;
@synthesize lineView;
@synthesize calloutBackground;
@synthesize billsTableView;

@synthesize relatedBillsLabel;
@synthesize relatedBillsLine;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.calloutBackground = [[SFCalloutBackgroundView alloc] initWithFrame:CGRectZero];
    [self.calloutBackground setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.calloutBackground];

    self.lineView = [[SFLineView alloc] initWithFrame:CGRectZero];
    self.lineView.lineColor = [UIColor detailLineColor];
    self.lineView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.lineView];

    self.committeePrefixLabel = [[SAMLabel alloc] initWithFrame:CGRectZero];
    self.committeePrefixLabel.font = [UIFont subitleEmFont];
    self.committeePrefixLabel.textColor = [UIColor subtitleColor];
    self.committeePrefixLabel.textAlignment = NSTextAlignmentCenter;
    self.committeePrefixLabel.backgroundColor = [UIColor secondaryBackgroundColor];
    self.committeePrefixLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.committeePrefixLabel setIsAccessibilityElement:NO];
    [self addSubview:self.committeePrefixLabel];

    self.committeePrimaryLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    self.committeePrimaryLabel.numberOfLines = 0;
    self.committeePrimaryLabel.font = [UIFont billTitleFont];
    self.committeePrimaryLabel.textColor = [UIColor titleColor];
    self.committeePrimaryLabel.textAlignment = NSTextAlignmentLeft;
    self.committeePrimaryLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.committeePrimaryLabel.backgroundColor = [UIColor clearColor];
    self.committeePrimaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.committeePrimaryLabel];

    self.occursAtLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    self.occursAtLabel.numberOfLines = 1;
    self.occursAtLabel.font = [UIFont cellImportantDetailFont];
    self.occursAtLabel.textColor = [UIColor secondaryTextColor];
    self.occursAtLabel.textAlignment = NSTextAlignmentLeft;
    self.occursAtLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.occursAtLabel.backgroundColor = [UIColor clearColor];
    self.occursAtLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.occursAtLabel];

    self.locationLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    self.locationLabel.numberOfLines = 0;
    self.locationLabel.font = [UIFont cellImportantDetailFont];
    self.locationLabel.textColor = [UIColor secondaryTextColor];
    self.locationLabel.textAlignment = NSTextAlignmentLeft;
    self.locationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.locationLabel.backgroundColor = [UIColor clearColor];
    self.locationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.locationLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self addSubview:self.locationLabel];

    self.locationLabelLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    self.locationLabelLabel.text = @"Location:";
    self.locationLabelLabel.font = [UIFont cellImportantDetailFont];
    self.locationLabelLabel.textColor = [UIColor secondaryTextColor];
    self.locationLabelLabel.textAlignment = NSTextAlignmentLeft;
    self.locationLabelLabel.backgroundColor = [UIColor clearColor];
    self.locationLabelLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.locationLabelLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self addSubview:self.locationLabelLabel];

    self.descriptionLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.font = [UIFont bodyTextFont];
    self.descriptionLabel.textColor = [UIColor primaryTextColor];
    self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
    self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.descriptionLabel.backgroundColor = [UIColor clearColor];
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.descriptionLabel];

    /* conditional stuff */

    self.relatedBillsLine = [[SFLineView alloc] initWithFrame:CGRectZero];
    self.relatedBillsLine.lineColor = [UIColor detailLineColor];
    self.relatedBillsLine.translatesAutoresizingMaskIntoConstraints = NO;

    self.relatedBillsLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    self.relatedBillsLabel.font = [UIFont subitleEmFont];
    self.relatedBillsLabel.textColor = [UIColor subtitleColor];
    self.relatedBillsLabel.textAlignment = NSTextAlignmentCenter;
    self.relatedBillsLabel.backgroundColor = [UIColor primaryBackgroundColor];
    self.relatedBillsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.relatedBillsLabel setIsAccessibilityElement:NO];
}

- (void)updateContentConstraints {
//    MARK: views and metrics
    NSDictionary *views = @{ @"callout": self.calloutBackground,
                             @"prefix": self.committeePrefixLabel,
                             @"primary": self.committeePrimaryLabel,
                             @"occursAt": self.occursAtLabel,
                             @"location": self.locationLabel,
                             @"locationLabel": self.locationLabelLabel,
                             @"description": self.descriptionLabel,
                             @"line": self.lineView };

    NSDictionary *metrics = @{
        @"contentInset": @(self.contentInset.left),
    };

    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[callout]"
                                                                                         options:0
                                                                                         metrics:metrics
                                                                                           views:views]];

    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[callout]|"
                                                                                         options:0
                                                                                         metrics:metrics
                                                                                           views:views]];

    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.committeePrefixLabel
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0
                                                                     constant:self.committeePrefixLabel.width + 10]];

    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.committeePrefixLabel
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0
                                                                     constant:0]];

    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(contentInset)-[prefix]-(8)-[primary]-(8)-[occursAt]-(8)-[location]-(40)-[description]" options:0 metrics:metrics views:views]];

    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(contentInset)-[primary]-(contentInset)-|" options:0 metrics:metrics views:views]];
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(contentInset)-[occursAt]-(contentInset)-|" options:0 metrics:metrics views:views]];
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(contentInset)-[locationLabel]-(5)-[location]-(contentInset)-|" options:0 metrics:metrics views:views]];

    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(contentInset)-[description]-(contentInset)-|" options:0 metrics:metrics views:views]];

    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.locationLabelLabel
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.locationLabel
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0
                                                                     constant:0.0]];

    /* MARK: line view */

    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.lineView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0
                                                                     constant:1.0]];

    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.lineView
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.committeePrimaryLabel
                                                                    attribute:NSLayoutAttributeWidth
                                                                   multiplier:1.0
                                                                     constant:0]];

    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.lineView
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.committeePrimaryLabel
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0
                                                                     constant:0]];

    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.lineView
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.committeePrefixLabel
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0
                                                                     constant:0]];

    /* MARK: callout background */

    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.calloutBackground
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.locationLabel
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:22.0]];

    /* MARK: bills table view */

    if (self.billsTableView) {
        NSDictionary *relatedBillsViews = @{ @"description": self.descriptionLabel,
                                             @"line": self.relatedBillsLine,
                                             @"label": self.relatedBillsLabel,
                                             @"bills": self.billsTableView, };

        [self addSubview:self.relatedBillsLine];
        [self addSubview:self.relatedBillsLabel];

        [self.relatedBillsLabel setText:@"Related Bills"];
        [self.relatedBillsLabel sizeToFit];

        [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[description]-(==40)-[line(1)]-(15)-[bills]" options:0 metrics:metrics views:relatedBillsViews]];

        [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.billsTableView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:self.billsTableView.height]];

        [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[line]|" options:0 metrics:nil views:relatedBillsViews]];

        [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bills]|" options:0 metrics:nil views:relatedBillsViews]];

        [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(contentInset)-[label]" options:0 metrics:metrics views:relatedBillsViews]];

        [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.relatedBillsLabel
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:self.relatedBillsLabel.width + 10.0f]];

        [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.relatedBillsLabel
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.relatedBillsLine
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.0
                                                                         constant:0.0]];
    }
}

@end
