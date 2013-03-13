//
//  SFLegislatorDetailView.h
//  Congress
//
//  Created by Daniel Cloud on 12/13/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFInsetsView.h"
//#import "SFMapView.h"

@interface SFLegislatorDetailView : SFInsetsView

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *infoText;
@property (nonatomic, retain) UIImageView *photo;
@property (nonatomic, retain) UIView *socialButtonsView;
@property (nonatomic, retain) UIButton *callButton;
@property (nonatomic, retain) UIButton *districtMapButton;
@property (nonatomic, retain) UIButton *websiteButton;
//@property (nonatomic, retain) SFMapView *map;

@end
