//
//  SFLegislatorDetailViewController.h
//  Congress
//
//  Created by Daniel Cloud on 12/13/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapBox/RMMapViewDelegate.h>
#import "SFDistrictMapViewController.h"
#import "SFShareableViewController.h"
#import "SFFollowing.h"
#import "SFFollowButton.h"

@class SFLegislator;
@class SFLegislatorDetailView;

@interface SFLegislatorDetailViewController : SFShareableViewController <SFFollowing, UIViewControllerRestoration>

+ (NSDictionary *)socialButtonImages;

@property (nonatomic, strong, setter = setLegislator:) SFLegislator *legislator;
@property (nonatomic, strong) SFLegislatorDetailView *legislatorDetailView;
@property (nonatomic, strong) SFDistrictMapViewController *mapViewController;

@end
