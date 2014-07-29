//
//  SFDistrictMapViewController.h
//  Congress
//
//  Created by Jeremy Carbaugh on 1/11/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapbox.h>
#import "SFLegislator.h"
#import "SFMapView.h"

@interface SFDistrictMapViewController : UIViewController <RMMapViewDelegate>

@property (nonatomic, strong) SFMapView *mapView;

- (void)loadBoundaryForLegislator:(SFLegislator *)legislator;
- (void)zoomToPointsAnimated:(BOOL)animated;

@end
