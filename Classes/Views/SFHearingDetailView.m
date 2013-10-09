//
//  SFHearingDetailView.m
//  Congress
//
//  Created by Jeremy Carbaugh on 8/23/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFHearingDetailView.h"

@implementation SFHearingDetailView

@synthesize committeePrefixLabel = _committeePrefixLabel;
@synthesize committeePrimaryLabel = _committeePrimaryLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize locationLabel = _locationLabel;
@synthesize occursAtLabel = _occursAtLabel;
@synthesize urlButton = _urlButton;
@synthesize lineView = _lineView;
@synthesize calloutBackground = _calloutBackground;

@synthesize relatedBillsButton = _relatedBillsButton;

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
    }
    return self;
}

- (void)_initialize
{
    _calloutBackground = [[UIImageView alloc] initWithImage:[UIImage calloutBoxBackgroundImage]];
    [_calloutBackground setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_calloutBackground];
    
    _lineView = [[SSLineView alloc] initWithFrame:CGRectZero];
    _lineView.lineColor = [UIColor detailLineColor];
    _lineView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_lineView];
    
    _committeePrefixLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _committeePrefixLabel.font = [UIFont subitleEmFont];
    _committeePrefixLabel.textColor = [UIColor subtitleColor];
    _committeePrefixLabel.textAlignment = NSTextAlignmentCenter;
    _committeePrefixLabel.backgroundColor = [UIColor secondaryBackgroundColor];
    _committeePrefixLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_committeePrefixLabel setIsAccessibilityElement:NO];
    [self addSubview:_committeePrefixLabel];
    
    _committeePrimaryLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _committeePrimaryLabel.numberOfLines = 0;
    _committeePrimaryLabel.font = [UIFont billTitleFont];
    _committeePrimaryLabel.textColor = [UIColor titleColor];
    _committeePrimaryLabel.textAlignment = NSTextAlignmentLeft;
    _committeePrimaryLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _committeePrimaryLabel.backgroundColor = [UIColor clearColor];
    _committeePrimaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_committeePrimaryLabel];
    
    _occursAtLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _occursAtLabel.numberOfLines = 1;
    _occursAtLabel.font = [UIFont subitleFont];
    _occursAtLabel.textColor = [UIColor secondaryTextColor];
    _occursAtLabel.textAlignment = NSTextAlignmentLeft;
    _occursAtLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _occursAtLabel.backgroundColor = [UIColor clearColor];
    _occursAtLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_occursAtLabel];
    
    _locationLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _locationLabel.numberOfLines = 0;
    _locationLabel.font = [UIFont subitleFont];
    _locationLabel.textColor = [UIColor secondaryTextColor];
    _locationLabel.textAlignment = NSTextAlignmentLeft;
    _locationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _locationLabel.backgroundColor = [UIColor clearColor];
    _locationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_locationLabel];
    
    _descriptionLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.font = [UIFont bodyTextFont];
    _descriptionLabel.textColor = [UIColor primaryTextColor];
    _descriptionLabel.textAlignment = NSTextAlignmentLeft;
    _descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_descriptionLabel];
    
    _relatedBillsButton = [[SFCongressButton alloc] init];
    [_relatedBillsButton setTitle:@"Related Bills" forState:UIControlStateNormal];
    [_relatedBillsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [_calloutView addSubview:_relatedBillsButton];
}

- (void)updateConstraints
{
    float viewInset = 4;
    float calloutInset = viewInset + 8;
    
    [super updateConstraints];
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    
    CGSize nameSize = [_committeePrimaryLabel sizeThatFits:CGSizeMake(frame.size.width - (calloutInset * 2), CGFLOAT_MAX)];
    CGSize descriptionSize = [_descriptionLabel sizeThatFits:CGSizeMake(frame.size.width - (calloutInset * 2), CGFLOAT_MAX)];
    
    NSDictionary *views = @{@"callout": _calloutBackground,
                            @"prefix": _committeePrefixLabel,
                            @"primary": _committeePrimaryLabel,
                            @"occursAt": _occursAtLabel,
                            @"location": _locationLabel,
                            @"description": _descriptionLabel,
                            @"line": _lineView,
                            @"relatedBills": _relatedBillsButton};
    
    NSDictionary *metrics = @{@"viewInset": @(viewInset),
                              @"calloutInset": @(calloutInset),
                              @"primaryWidth": @(nameSize.width),
                              @"primaryHeight": @(nameSize.height),
                              @"descriptionHeight": @(descriptionSize.height)};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(viewInset)-[callout]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(viewInset)-[callout]-(viewInset)-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_committeePrefixLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:_committeePrefixLabel.width + 10]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_committeePrefixLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(calloutInset)-[prefix]-(8)-[primary(primaryHeight)]-(8)-[occursAt]-(8)-[location]-(30)-[description(==descriptionHeight)]" options:0 metrics:metrics views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(calloutInset)-[primary]-(calloutInset)-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(calloutInset)-[occursAt]-(calloutInset)-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(calloutInset)-[location]-(calloutInset)-|" options:0 metrics:metrics views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(calloutInset)-[description]-(calloutInset)-|" options:0 metrics:metrics views:views]];
    
    /* line view */
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_lineView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:1.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_lineView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_committeePrimaryLabel
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_lineView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_committeePrimaryLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_lineView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_committeePrefixLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0]];
    
    /* callout background */
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_calloutBackground
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_locationLabel
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:22.0]];

}

@end
