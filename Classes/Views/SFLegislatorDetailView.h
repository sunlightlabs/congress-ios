//
//  SFLegislatorDetailView.h
//  Congress
//
//  Created by Daniel Cloud on 12/13/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFInsetsView.h"
#import "SFFavoriteButton.h"
#import "SFCongressButton.h"
#import "SFImageButton.h"
#import "SFLabel.h"
//#import "SFMapView.h"

@interface SFLegislatorDetailView : SFInsetsView

@property (nonatomic, retain) SFLabel *nameLabel;
@property (nonatomic, retain) UILabel *infoText;
@property (nonatomic, retain) UILabel *contactLabel;
@property (nonatomic, retain) SFLabel *addressLabel;
@property (nonatomic, retain) UIImageView *photo;
@property (nonatomic, retain) UIView *socialButtonsView;
@property (nonatomic, retain) SFCongressButton *callButton;
@property (nonatomic, retain) SFCongressButton *officeMapButton;
@property (nonatomic, retain) SFCongressButton *districtMapButton;
@property (nonatomic, retain) SFImageButton *websiteButton;
@property (nonatomic, strong) SFFavoriteButton *favoriteButton;
//@property (nonatomic, retain) SFMapView *map;

@end
