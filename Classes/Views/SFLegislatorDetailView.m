//
//  SFLegislatorDetailView.m
//  Congress
//
//  Created by Daniel Cloud on 12/13/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorDetailView.h"
#import "SFLineView.h"
#import "SFMapView.h"
#import "SFMapToggleButton.h"
#import <SAMLabel/SAMLabel.h>

@interface SFLegislatorDetailView ()

@property (nonatomic, strong) UIView *photoFrame;
@property (nonatomic, strong) SFLineView *decorativeLine;
@property (nonatomic, strong) UIView *mapViewContainer;
@property (nonatomic, strong) NSLayoutConstraint *mapTopConstraint;

@end

@implementation SFLegislatorDetailView

@synthesize nameLabel;
@synthesize infoText;
@synthesize contactLabel;
@synthesize addressLabel;
@synthesize photo;
@synthesize socialButtons = _socialButtons;
@synthesize callButton;
@synthesize emailButton;
//@synthesize officeMapButton;
@synthesize districtMapButton;
@synthesize websiteButton;
@synthesize followButton;
@synthesize mapView = _mapView;
@synthesize expandoButton;

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)_initialize {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self setInsetForAllEdges:10];

    CGRect lineRect = CGRectMake(0, 0, 2.0f, 1.0f);
    self.decorativeLine = [[SFLineView alloc] initWithFrame:lineRect];
    self.decorativeLine.lineColor = [UIColor detailLineColor];
    self.decorativeLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.decorativeLine];

    self.contactLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.contactLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.contactLabel.textColor = [UIColor subtitleColor];
    self.contactLabel.backgroundColor = [UIColor primaryBackgroundColor];
    self.contactLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.contactLabel];

    self.addressLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    self.addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.addressLabel.textColor = [UIColor primaryTextColor];
    self.addressLabel.font = [UIFont bodySmallFont];
    self.addressLabel.backgroundColor = [UIColor clearColor];
    self.addressLabel.numberOfLines = 2;
    [self.addressLabel setAccessibilityLabel:@"DC Office Address"];
    [self addSubview:self.addressLabel];

    self.photo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 156)];
    self.photo.translatesAutoresizingMaskIntoConstraints = YES;
    self.photo.contentMode = UIViewContentModeScaleAspectFit;
    self.photoFrame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 156)];
    self.photoFrame.translatesAutoresizingMaskIntoConstraints = NO;
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage photoFrame]];
    backgroundView.size = self.photoFrame.size;
    [self.photoFrame addSubview:backgroundView];
    [self.photoFrame addSubview:self.photo];
    [self addSubview:self.photoFrame];

    self.nameLabel = [[SFLabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    self.nameLabel.font = [UIFont legislatorTitleFont];
    self.nameLabel.textColor = [UIColor primaryTextColor];
    self.nameLabel.numberOfLines = 3;
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.nameLabel.verticalTextAlignment = SAMLabelVerticalTextAlignmentTop;
    self.nameLabel.backgroundColor = [UIColor clearColor];
    [self.nameLabel setAccessibilityLabel:@"Legislator"];
    [self addSubview:self.nameLabel];

    self.infoText = [[UILabel alloc] initWithFrame:CGRectZero];
    self.infoText.translatesAutoresizingMaskIntoConstraints = NO;
    self.infoText.font = [UIFont bodyTextFont];
    self.infoText.textColor = [UIColor primaryTextColor];
    self.infoText.numberOfLines = 0;
    self.infoText.textAlignment = NSTextAlignmentLeft;
    self.infoText.lineBreakMode = NSLineBreakByWordWrapping;
    self.infoText.backgroundColor = [UIColor clearColor];
    [self addSubview:self.infoText];

    self.followButton = [SFFollowButton button];
    self.followButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.followButton];

//    self.officeMapButton = [SFCongressButton buttonWithTitle:@"Map"];
//    self.officeMapButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.officeMapButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [self.officeMapButton sizeToFit];
//    [self.officeMapButton setAccessibilityHint:@"Tap to load D.C. office in Apple maps"];
//    [self addSubview:self.officeMapButton];
    
    self.emailButton = [SFCongressButton buttonWithTitle:@"Email"];
    self.emailButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.emailButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.emailButton sizeToFit];
    [self.emailButton setAccessibilityHint:@"Tap to email the legislator's D.C. office"];
    [self addSubview:self.emailButton];

    self.callButton = [SFCongressButton buttonWithTitle:@"Call"];
    self.callButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.callButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.callButton sizeToFit];
    [self.callButton setAccessibilityHint:@"Tap to initiate a call to the legislator's D.C. office"];
    [self addSubview:self.callButton];

    self.websiteButton = [SFImageButton buttonWithDefaultImage:[UIImage websiteImage]];
    self.websiteButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addSubview:self.websiteButton];

    self.mapViewContainer = [[UIView alloc] initWithFrame:CGRectZero];
    self.mapViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.mapViewContainer];

    self.expandoButton = [SFMapToggleButton button];
    self.expandoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.expandoButton setHidden:YES];
    [self.expandoButton setIsAccessibilityElement:YES];
    [self.expandoButton setAccessibilityLabel:@"Expand map to full screen"];
    [self.expandoButton setAccessibilityValue:@"Collapsed"];
    [self.expandoButton setAccessibilityValue:@"Tap button to make map full screen and interactive."];
}

- (void)layoutSubviews {
    if (self.mapView) {
        [self bringSubviewToFront:self.mapViewContainer];
        [self bringSubviewToFront:self.expandoButton];
        [self.mapView setFrame:self.mapViewContainer.bounds];
    }
    [super layoutSubviews];
}

- (void)updateContentConstraints {
    NSDictionary *views = @{ @"photo": self.photoFrame,
                             @"address": self.addressLabel,
                             @"contact": self.contactLabel,
                             @"line": self.decorativeLine,
                             @"name": self.nameLabel,
                             @"callButton": self.callButton,
                             @"emailButton": self.emailButton,
//                             @"officeMapButton": self.officeMapButton,
                             @"websiteButton": self.websiteButton,
                             @"info": self.infoText };

    CGFloat nameTopOffset = floorf(self.nameLabel.font.lineHeight - self.nameLabel.font.ascender);

    [self.contactLabel sizeToFit];
    self.contactLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat contactWidth = ceilf(self.contactLabel.size.width + 18.0f);

    NSDictionary *metrics = @{ @"contentInset": @(self.contentInset.left),
                               @"contactWidth": @(contactWidth) };

    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(contentInset)-[photo]"
                                                                                         options:0
                                                                                         metrics:metrics
                                                                                           views:views]];
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(contentInset)-[photo]-[name]"
                                                                                         options:0
                                                                                         metrics:metrics
                                                                                           views:views]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.photoFrame attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f constant:self.photoFrame.width]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.photoFrame attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f constant:self.photoFrame.height]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.photoFrame attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f constant:-nameTopOffset]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationLessThanOrEqual
                                                                       toItem:self.followButton attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f constant:0]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.infoText attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.nameLabel attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0f constant:5.0f]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.infoText attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.nameLabel attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0f constant:0]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.followButton attribute:NSLayoutAttributeRight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0f constant:0]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.followButton attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0f constant:-1.0f]];
    // MARK: Social buttons
    SFImageButton *prevButton = nil;
    for (SFImageButton *button in self.socialButtons) {
        [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(44)]" options:0 metrics:0 views:@{ @"button":button }]];
        [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(44)]" options:0 metrics:0 views:@{ @"button":button }]];
        if (prevButton != nil) {
            [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:prevButton attribute:NSLayoutAttributeRight
                                                                           multiplier:1.0f constant:0]];
            [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:prevButton attribute:NSLayoutAttributeTop
                                                                           multiplier:1.0f constant:0]];
        }
        else {
            CGFloat inset = 10;
            [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.nameLabel attribute:NSLayoutAttributeLeft
                                                                           multiplier:1.0f constant:-inset]];
            [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.photoFrame attribute:NSLayoutAttributeBottom
                                                                           multiplier:1.0f constant:inset]];
        }
        prevButton = button;
    }
    // MARK: Callout height
//    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.calloutBackground attribute:NSLayoutAttributeBottom
//                                                                    relatedBy:NSLayoutRelationEqual
//                                                                       toItem:self.photoFrame attribute:NSLayoutAttributeBottom
//                                                                   multiplier:1.0f constant:22.0f]];
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[photo]-(14)-[contact]-(7)-[address]"
                                                                                         options:0 metrics:metrics views:views]];
    // MARK: Contact label, etc
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.contactLabel attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0f constant:0]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.contactLabel attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0 constant:contactWidth]];
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[line]|" options:0 metrics:metrics views:views]];
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[line(1)]" options:0 metrics:metrics views:views]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.decorativeLine attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contactLabel attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0f constant:0]];
    // MARK: Address and related buttons
    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(contentInset)-[address]-(<=6)-[emailButton]-(<=4)-[callButton]-(contentInset)-|"
                                                                                         options:0 metrics:metrics views:views]];
//    [self.contentConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[officeMapButton(44)]"
//                                                                                         options:0 metrics:metrics views:views]];
//    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.officeMapButton attribute:NSLayoutAttributeCenterY
//                                                                    relatedBy:NSLayoutRelationEqual
//                                                                       toItem:self.addressLabel attribute:NSLayoutAttributeCenterY
//                                                                   multiplier:1.0f constant:0]];
//    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.officeMapButton attribute:NSLayoutAttributeHeight
//                                                                    relatedBy:NSLayoutRelationEqual
//                                                                       toItem:nil attribute:NSLayoutAttributeNotAnAttribute
//                                                                   multiplier:1.0f constant:44.0f]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.callButton attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.addressLabel attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0f constant:0]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.callButton attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f constant:44.0f]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.emailButton attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.addressLabel attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0f constant:0]];
    [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.emailButton attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0f constant:44.0f]];

    // MARK: Map
    if (self.mapView) {
        if (_mapTopConstraint) {
            [self.contentConstraints addObject:_mapTopConstraint];
        }
        [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f constant:0]];
        [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0f constant:0]];
        [self.contentConstraints addObject:[NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self attribute:NSLayoutAttributeRight
                                                                       multiplier:1.0f constant:0]];
    }
}

- (void)setSocialButtons:(NSArray *)newButtons {
    if (_socialButtons) {
        for (SFImageButton *oldbutton in self.socialButtons) {
            [oldbutton removeFromSuperview];
        }
    }
    _socialButtons = newButtons;
    for (SFImageButton *button in self.socialButtons) {
        [self addSubview:button];
    }
    [self setNeedsUpdateConstraints];
}

- (void)setMapView:(SFMapView *)pMapView {
    
    _mapView = pMapView;
//    [_mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.mapView removeFromSuperview];
    [self.mapViewContainer addSubview:self.mapView];
    [self.mapViewContainer addSubview:self.expandoButton];
    [self.mapViewContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.expandoButton
                                                                      attribute:NSLayoutAttributeCenterX
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.mapView
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1.0f
                                                                       constant:0]];
    [self.mapViewContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.expandoButton
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.mapView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0f
                                                                       constant:-self.expandoButton.imageView.top]];
    
    [self setMapCollapsedConstraint];
}

- (void)setMapExpandedConstraint {
    _mapTopConstraint = [NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f constant:0];
    [self updateConstraints];
}

- (void)setMapCollapsedConstraint {
    _mapTopConstraint = [NSLayoutConstraint constraintWithItem:self.mapViewContainer attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.addressLabel attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0f constant:20.0f];
    [self updateConstraints];
}

@end
