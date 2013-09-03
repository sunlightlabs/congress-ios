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
@synthesize calloutView = _calloutView;
@synthesize lineView = _lineView;

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
    self.insets = UIEdgeInsetsMake(4.0f, 4.0f, 4.0f, 4.0f);
    
    _calloutView = [[SFCalloutView alloc] initWithFrame:CGRectZero];
    _calloutView.insets = UIEdgeInsetsMake(4.0f, 14.0f, 13.0f, 14.0f);
    _calloutView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_calloutView];
    
//    CGRect lineRect = CGRectMake(0, 0, 2.0f, 1.0f);
    _lineView = [[SSLineView alloc] initWithFrame:CGRectZero];
    _lineView.lineColor = [UIColor detailLineColor];
    _lineView.translatesAutoresizingMaskIntoConstraints = NO;
    [_calloutView addSubview:_lineView];
    
    _committeePrefixLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    _committeePrefixLabel.font = [UIFont subitleEmFont];
    _committeePrefixLabel.textColor = [UIColor subtitleColor];
    _committeePrefixLabel.textAlignment = NSTextAlignmentCenter;
    _committeePrefixLabel.backgroundColor = [UIColor secondaryBackgroundColor];
    _committeePrefixLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_committeePrefixLabel setIsAccessibilityElement:NO];
    [_calloutView addSubview:_committeePrefixLabel];
    
    _committeePrimaryLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _committeePrimaryLabel.numberOfLines = 0;
    _committeePrimaryLabel.font = [UIFont billTitleFont];
    _committeePrimaryLabel.textColor = [UIColor titleColor];
    _committeePrimaryLabel.textAlignment = NSTextAlignmentLeft;
    _committeePrimaryLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _committeePrimaryLabel.backgroundColor = [UIColor clearColor];
    _committeePrimaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_calloutView addSubview:_committeePrimaryLabel];
    
    _occursAtLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _occursAtLabel.numberOfLines = 1;
    _occursAtLabel.font = [UIFont subitleFont];
    _occursAtLabel.textColor = [UIColor secondaryTextColor];
    _occursAtLabel.textAlignment = NSTextAlignmentLeft;
    _occursAtLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _occursAtLabel.backgroundColor = [UIColor clearColor];
    _occursAtLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_calloutView addSubview:_occursAtLabel];
    
    _locationLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _locationLabel.numberOfLines = 0;
    _locationLabel.font = [UIFont subitleFont];
    _locationLabel.textColor = [UIColor secondaryTextColor];
    _locationLabel.textAlignment = NSTextAlignmentLeft;
    _locationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _locationLabel.backgroundColor = [UIColor clearColor];
    _locationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_calloutView addSubview:_locationLabel];
    
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
    [self addSubview:_relatedBillsButton];
}

//- (void)layoutSubviews
//{
//    NSLog(@"----> [SFHearingDetailView] layoutSubviews:");
//    [super layoutSubviews];
//}

- (void)updateConstraints
{
    NSLog(@"----> [SFHearingDetailView] updateConstraints:");
    
    [super updateConstraints];
    
    CGSize nameSize = [_committeePrimaryLabel sizeThatFits:CGSizeMake(284, CGFLOAT_MAX)];
    CGSize descriptionSize = [_descriptionLabel sizeThatFits:CGSizeMake(284, CGFLOAT_MAX)];
    
    NSDictionary *views = @{@"callout": _calloutView,
                            @"prefix": _committeePrefixLabel,
                            @"primary": _committeePrimaryLabel,
                            @"occursAt": _occursAtLabel,
                            @"location": _locationLabel,
                            @"description": _descriptionLabel,
                            @"line": _lineView,
                            @"relatedBills": _relatedBillsButton};
    
    NSDictionary *metrics = @{@"primaryWidth": [NSNumber numberWithFloat:nameSize.width],
                              @"primaryHeight": [NSNumber numberWithFloat:nameSize.height],
                              @"descriptionWidth": [NSNumber numberWithFloat:descriptionSize.width],
                              @"descriptionHeight": [NSNumber numberWithFloat:descriptionSize.height],
                              @"prefixWidth": [NSNumber numberWithFloat:_committeePrefixLabel.width + 20.0f]};
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(4)-[callout]-(16)-[description]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(4)-[callout]-(4)-|" options:0 metrics:nil views:views]];
    
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
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(9)-[line(1)]" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(4)-[prefix]-(8)-[primary(primaryHeight)]-(8)-[occursAt]-(8)-[location]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[primary]|" options:0 metrics:metrics views:views]];
    
    /* line view */
    
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
    
    /* description label */
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_committeePrimaryLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_committeePrimaryLabel
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionLabel
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:descriptionSize.height]];

}

- (CGSize)sizeThatFits:(CGSize)size
{
    NSLog(@"----> [SFHearingDetailView] sizeThatFits:");
    return [super sizeThatFits:size];
}

- (CGSize)intrinsicContentSize
{
    NSLog(@"----> [SFHearingDetailView] intrinsicContentSize:");
    return [super intrinsicContentSize];
}

@end
