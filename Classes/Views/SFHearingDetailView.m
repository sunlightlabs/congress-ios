//
//  SFHearingDetailView.m
//  Congress
//
//  Created by Jeremy Carbaugh on 8/23/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFHearingDetailView.h"

@implementation SFHearingDetailView {
    NSMutableArray *_constraints;
}

@synthesize committeePrefixLabel = _committeePrefixLabel;
@synthesize committeePrimaryLabel = _committeePrimaryLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize locationLabel = _locationLabel;
@synthesize locationLabelLabel = _locationLabelLabel;

@synthesize occursAtLabel = _occursAtLabel;
@synthesize urlButton = _urlButton;
@synthesize lineView = _lineView;
@synthesize calloutBackground = _calloutBackground;
@synthesize billsTableView = _billsTableView;

@synthesize relatedBillsLabel = _relatedBillsLabel;
@synthesize relatedBillsLine = _relatedBillsLine;

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
    
    _constraints = [NSMutableArray array];
    
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
    
    _locationLabelLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _locationLabelLabel.numberOfLines = 0;
    _locationLabelLabel.font = [UIFont subitleFont];
    _locationLabelLabel.textColor = [UIColor secondaryTextColor];
    _locationLabelLabel.textAlignment = NSTextAlignmentLeft;
    _locationLabelLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _locationLabelLabel.backgroundColor = [UIColor clearColor];
    _locationLabelLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_locationLabelLabel];
    
    _descriptionLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.font = [UIFont bodyTextFont];
    _descriptionLabel.textColor = [UIColor primaryTextColor];
    _descriptionLabel.textAlignment = NSTextAlignmentLeft;
    _descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_descriptionLabel];
    
    /* conditional stuff */
    
    _relatedBillsLine = [[SSLineView alloc] initWithFrame:CGRectZero];
    _relatedBillsLine.lineColor = [UIColor detailLineColor];
    _relatedBillsLine.translatesAutoresizingMaskIntoConstraints = NO;
    
    _relatedBillsLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _relatedBillsLabel.font = [UIFont subitleEmFont];
    _relatedBillsLabel.textColor = [UIColor subtitleColor];
    _relatedBillsLabel.textAlignment = NSTextAlignmentCenter;
    _relatedBillsLabel.backgroundColor = [UIColor primaryBackgroundColor];
    _relatedBillsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_relatedBillsLabel setIsAccessibilityElement:NO];
}

- (void)updateConstraints
{
    float viewInset = 4;
    float calloutInset = viewInset + 8;
    
    [super updateConstraints];
    
    [self removeConstraints:_constraints];
    [_constraints removeAllObjects];
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    
    CGSize nameSize = [_committeePrimaryLabel sizeThatFits:CGSizeMake(frame.size.width - (calloutInset * 2), CGFLOAT_MAX)];
    CGSize descriptionSize = [_descriptionLabel sizeThatFits:CGSizeMake(frame.size.width - (calloutInset * 2), CGFLOAT_MAX)];
    
    [_locationLabelLabel setText:@"Location:"];
    [_locationLabelLabel sizeToFit];
    
    NSDictionary *views = @{@"callout": _calloutBackground,
                            @"prefix": _committeePrefixLabel,
                            @"primary": _committeePrimaryLabel,
                            @"occursAt": _occursAtLabel,
                            @"location": _locationLabel,
                            @"locationLabel": _locationLabelLabel,
                            @"description": _descriptionLabel,
                            @"line": _lineView};
    
    NSDictionary *metrics = @{@"viewInset": @(viewInset),
                              @"calloutInset": @(calloutInset),
                              @"primaryWidth": @(nameSize.width),
                              @"primaryHeight": @(nameSize.height),
                              @"descriptionHeight": @(descriptionSize.height)};
    
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(viewInset)-[callout]"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(viewInset)-[callout]-(viewInset)-|"
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_committeePrefixLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:_committeePrefixLabel.width + 10]];
    
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_committeePrefixLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0]];
    
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(calloutInset)-[prefix]-(8)-[primary(primaryHeight)]-(8)-[occursAt]-(8)-[location]-(40)-[description(==descriptionHeight)]" options:0 metrics:metrics views:views]];
    
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(calloutInset)-[primary]-(calloutInset)-|" options:0 metrics:metrics views:views]];
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(calloutInset)-[occursAt]-(calloutInset)-|" options:0 metrics:metrics views:views]];
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(calloutInset)-[locationLabel]-(5)-[location]-(calloutInset)-|" options:0 metrics:metrics views:views]];
    
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(calloutInset)-[description]-(calloutInset)-|" options:0 metrics:metrics views:views]];
    
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_locationLabelLabel
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_locationLabel
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:0.0]];
    
    /* line view */
    
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_lineView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:1.0]];
    
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_lineView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_committeePrimaryLabel
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0
                                                      constant:0]];
    
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_lineView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_committeePrimaryLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0]];
    
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_lineView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_committeePrefixLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0]];
    
    /* callout background */
    
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_calloutBackground
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_locationLabel
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:22.0]];
    
    /* bills table view */
    
    if (_billsTableView) {
        NSDictionary *relatedBillsViews = @{@"description": _descriptionLabel,
                                            @"line": _relatedBillsLine,
                                            @"label": _relatedBillsLabel,
                                            @"bills": _billsTableView,};
        
        [self addSubview:_relatedBillsLine];
        [self addSubview:_relatedBillsLabel];
        
        [_relatedBillsLabel setText:@"Related Bills"];
        [_relatedBillsLabel sizeToFit];
        
        [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[description]-(==40)-[line(1)]-(15)-[bills]" options:0 metrics:metrics views:relatedBillsViews]];
        
        [_constraints addObject:[NSLayoutConstraint constraintWithItem:_billsTableView
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0
                                                              constant:_billsTableView.height]];
        
        [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[line]|" options:0 metrics:nil views:relatedBillsViews]];
        
        [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bills]|" options:0 metrics:nil views:relatedBillsViews]];
        
        [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(calloutInset)-[label]" options:0 metrics:metrics views:relatedBillsViews]];
        
        [_constraints addObject:[NSLayoutConstraint constraintWithItem:_relatedBillsLabel
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0
                                                              constant:_relatedBillsLabel.width + 10.0f]];
        
        [_constraints addObject:[NSLayoutConstraint constraintWithItem:_relatedBillsLabel
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_relatedBillsLine
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0.0]];
    }
    
    [self addConstraints:_constraints];
}

@end
