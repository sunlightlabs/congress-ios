//
//  SFLegislatorDetailView.m
//  Congress
//
//  Created by Daniel Cloud on 12/13/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorDetailView.h"
#import "SFCalloutView.h"
#import "SSLineView.h"

@implementation SFLegislatorDetailView
{
    UIImageView *_calloutBackground;
    UIView *_photoFrame;
    SSLineView *_decorativeLine;
    NSMutableArray *_constraints;
}

@synthesize nameLabel = _nameLabel;
@synthesize infoText = _infoText;
@synthesize contactLabel = _contactLabel;
@synthesize addressLabel = _addressLabel;
@synthesize photo = _photo;
@synthesize socialButtons = _socialButtons;
@synthesize callButton = _callButton;
@synthesize officeMapButton = _officeMapButton;
@synthesize districtMapButton = _districtMapButton;
@synthesize websiteButton = _websiteButton;
@synthesize favoriteButton = _favoriteButton;
@synthesize mapView = _mapView;

#pragma mark - UIView

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
    self.translatesAutoresizingMaskIntoConstraints = NO;
    _constraints = [NSMutableArray array];

    self.insets = UIEdgeInsetsMake(4.0f, 4.0f, 0, 4.0f);

    CGRect lineRect = CGRectMake(0, 0, 2.0f, 1.0f);
    _decorativeLine = [[SSLineView alloc] initWithFrame:lineRect];
    _decorativeLine.lineColor = [UIColor detailLineColor];
    _decorativeLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_decorativeLine];

    _contactLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _contactLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _contactLabel.textColor = [UIColor subtitleColor];
    _contactLabel.backgroundColor = [UIColor primaryBackgroundColor];
    _contactLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_contactLabel];

    _addressLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _addressLabel.textColor = [UIColor primaryTextColor];
    _addressLabel.font = [UIFont bodySmallFont];
    _addressLabel.backgroundColor = [UIColor clearColor];
    _addressLabel.numberOfLines = 2;
    [_addressLabel setAccessibilityLabel:@"DC Office Address"];
    [self addSubview:_addressLabel];

    _calloutBackground = [[UIImageView alloc] initWithImage:[UIImage calloutBoxBackgroundImage]];
    _calloutBackground.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_calloutBackground];

    _photo = [[UIImageView alloc] initWithFrame:CGRectMake(4.0f, 4.0f, 100.0f, 125.f)];
    _photo.translatesAutoresizingMaskIntoConstraints = NO;
    _photoFrame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 108.0f, 133.f)];
    _photoFrame.translatesAutoresizingMaskIntoConstraints = NO;
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage photoFrame]];
    backgroundView.size = _photoFrame.size;
    [_photoFrame addSubview:backgroundView];
    [_photoFrame addSubview:_photo];
    [self addSubview:_photoFrame];

    _nameLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    _nameLabel.font = [UIFont legislatorTitleFont];
    _nameLabel.textColor = [UIColor primaryTextColor];
    _nameLabel.numberOfLines = 2;
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _nameLabel.verticalTextAlignment = SSLabelVerticalTextAlignmentTop;
    _nameLabel.backgroundColor = [UIColor clearColor];
    [_nameLabel setAccessibilityLabel:@"Legislator"];
    [self addSubview:_nameLabel];

    _infoText = [[UILabel alloc] initWithFrame:CGRectZero];
    _infoText.translatesAutoresizingMaskIntoConstraints = NO;
    _infoText.font = [UIFont bodyTextFont];
    _infoText.textColor = [UIColor primaryTextColor];
    _infoText.numberOfLines = 0;
    _infoText.textAlignment = NSTextAlignmentLeft;
    _infoText.lineBreakMode = NSLineBreakByWordWrapping;
    _infoText.backgroundColor = [UIColor clearColor];
    [self addSubview:_infoText];

    _favoriteButton = [[SFFavoriteButton alloc] init];
    _favoriteButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_favoriteButton];

    _officeMapButton = [SFCongressButton buttonWithTitle:@"Map Office"];
    _officeMapButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_officeMapButton setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [_officeMapButton sizeToFit];
    [_officeMapButton setAccessibilityHint:@"Tap to load D.C. office in Apple maps"];
    [self addSubview:_officeMapButton];

    _callButton = [SFCongressButton buttonWithTitle:@"Call Office"];
    _callButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_callButton setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [_callButton sizeToFit];
    [_callButton setAccessibilityHint:@"Tap to initiate a call to the legislator's D.C. office"];
    [self addSubview:_callButton];

    _websiteButton = [SFImageButton button];
    _websiteButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_websiteButton setImage:[UIImage websiteImage] forState:UIControlStateNormal];
    [self addSubview:_websiteButton];
}

- (void)updateConstraints
{
    float viewInset = 4;
    float calloutInset = viewInset + 8;

    NSDictionary *views = @{@"callout": _calloutBackground,
                            @"photo": _photoFrame,
                            @"address": _addressLabel,
                            @"contact": _contactLabel,
                            @"line": _decorativeLine,
                            @"name": _nameLabel,
                            @"callButton": _callButton,
                            @"officeMapButton": _officeMapButton,
                            @"websiteButton": _websiteButton,
                            @"info": _infoText,
                            };

    CGFloat nameHeight = _nameLabel.numberOfLines * _nameLabel.font.lineHeight;
    CGFloat nameTopOffset = floorf(_nameLabel.font.lineHeight - _nameLabel.font.ascender);

    [_contactLabel sizeToFit];
    _contactLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat contactWidth = ceilf(_contactLabel.size.width + 18.0f);

    NSDictionary *metrics = @{@"viewInset": @(viewInset),
                              @"calloutInset": @(calloutInset),
                              @"nameHeight": @(nameHeight),
                              @"contactWidth": @(contactWidth)
                              };

    [super updateConstraints];
    [self removeConstraints:_constraints];
    [_constraints removeAllObjects];

    // Callout contents (photo, name, info, etc)
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(viewInset)-[callout]"
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:views]];

    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(viewInset)-[callout]-(viewInset)-|"
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:views]];
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(calloutInset)-[photo]"
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:views]];
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(calloutInset)-[photo]-[name]-(calloutInset)-|"
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:views]];
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_photoFrame attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0f constant:_photoFrame.width]];
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_photoFrame attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0f constant:_photoFrame.height]];
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_photoFrame attribute:NSLayoutAttributeTop
                                                        multiplier:1.0f constant:-nameTopOffset]];
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0f constant:nameHeight]];
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_infoText attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_nameLabel attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0f constant:5.0f]];
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_infoText attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_nameLabel attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0f constant:0]];
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_favoriteButton attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self attribute:NSLayoutAttributeRight
                                                        multiplier:1.0f constant:0]];
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_favoriteButton attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self attribute:NSLayoutAttributeTop
                                                        multiplier:1.0f constant:-1.0f]];
    // Social buttons
    SFImageButton *prevButton = nil;
    for (SFImageButton *button in _socialButtons) {
        [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(44)]" options:0 metrics:0 views:@{@"button":button}]];
        [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(44)]" options:0 metrics:0 views:@{@"button":button}]];
        if (prevButton != nil) {
            [_constraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:prevButton attribute:NSLayoutAttributeRight
                                                                multiplier:1.0f constant:0]];
            [_constraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:prevButton attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f constant:0]];
        }
        else {
            CGFloat inset = 10;
            [_constraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_nameLabel attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0f constant:-inset]];
            [_constraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_photoFrame attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0f constant:inset]];
        }
        prevButton = button;
    }
    // Callout height
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_calloutBackground attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_photoFrame attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0f constant:22.0f]];
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[callout]-(7)-[contact]-(7)-[address]"
                                                                              options:0 metrics:metrics views:views]];
    // Contact label, etc
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_contactLabel attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0f constant:0]];
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_contactLabel attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0 constant:contactWidth]];
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(9)-[line]-(9)-|" options:0 metrics:metrics views:views]];
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[line(1)]" options:0 metrics:metrics views:views]];
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_decorativeLine attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_contactLabel attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f constant:0]];
    // Address and related buttons
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(9)-[address]"
                                                                              options:0 metrics:metrics views:views]];
    [_constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[officeMapButton]-[callButton]-(9)-|"
                                                                              options:0 metrics:metrics views:views]];
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_officeMapButton attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_addressLabel attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f constant:0]];
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_officeMapButton attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0f constant:44.0f]];
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_callButton attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                            toItem:_officeMapButton attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0f constant:0]];
    [_constraints addObject:[NSLayoutConstraint constraintWithItem:_callButton attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0f constant:44.0f]];

    // Map
    if (self.mapView) {
        [_constraints addObject:[NSLayoutConstraint constraintWithItem:_mapView attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_addressLabel attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0f constant:20.0f
                                 ]];
        [_constraints addObject:[NSLayoutConstraint constraintWithItem:_mapView attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0f constant:0]];
        [_constraints addObject:[NSLayoutConstraint constraintWithItem:_mapView attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0f constant:0]];
        [_constraints addObject:[NSLayoutConstraint constraintWithItem:_mapView attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self attribute:NSLayoutAttributeRight
                                                            multiplier:1.0f constant:0]];
    }

    [self addConstraints:_constraints];
}

- (void)setSocialButtons:(NSArray *)newButtons
{
    if (_socialButtons) {
        for (SFImageButton *oldbutton in _socialButtons) {
            [oldbutton removeFromSuperview];
        }
    }
    _socialButtons = newButtons;
    for (SFImageButton *button in _socialButtons) {
        [self addSubview:button];
    }
    [self setNeedsUpdateConstraints];
}

- (void)setMapView:(SFMapView *)mapView
{
    _mapView = mapView;
    _mapView.translatesAutoresizingMaskIntoConstraints = NO;
}

@end
