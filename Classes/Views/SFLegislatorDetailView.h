//
//  SFLegislatorDetailView.h
//  Congress
//
//  Created by Daniel Cloud on 12/13/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFContentView.h"
#import "SFFollowButton.h"
#import "SFCongressButton.h"
#import "SFImageButton.h"
#import "SFLabel.h"

@class SFMapView;
@class SFMapToggleButton;

@interface SFLegislatorDetailView : SFContentView

@property (nonatomic, strong) SFLabel *nameLabel;
@property (nonatomic, strong) UILabel *infoText;
@property (nonatomic, strong) UILabel *contactLabel;
@property (nonatomic, strong) SFLabel *addressLabel;
@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) NSArray *socialButtons;
@property (nonatomic, strong) SFCongressButton *callButton;
@property (nonatomic, strong) SFCongressButton *emailButton;
//@property (nonatomic, strong) SFCongressButton *officeMapButton;
@property (nonatomic, strong) SFCongressButton *districtMapButton;
@property (nonatomic, strong) SFImageButton *websiteButton;
@property (nonatomic, strong) SFFollowButton *followButton;
@property (nonatomic, strong) SFMapView *mapView;
@property (nonatomic, strong) SFMapToggleButton *expandoButton;

- (void)setMapExpandedConstraint;
- (void)setMapCollapsedConstraint;

@end
