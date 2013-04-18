//
//  SFDistrictMapViewController.h
//  Congress
//
//  Created by Jeremy Carbaugh on 1/11/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapBox/MapBox.h>
#import "SFLegislator.h"
#import "SFMapView.h"
#import "GAITrackedViewController.h"

@interface SFDistrictMapViewController : GAITrackedViewController <RMMapViewDelegate>

@property (nonatomic) CGRect originalFrame;
@property (nonatomic) BOOL isExpanded;
@property (nonatomic, strong) SFMapView *mapView;
@property (nonatomic, retain) NSMutableArray *shapes;

- (void)afterMapMove:(RMMapView *)map byUser:(BOOL)wasUserAction;
- (void)afterMapZoom:(RMMapView *)map byUser:(BOOL)wasUserAction;
- (void)loadBoundaryForLegislator:(SFLegislator *)legislator;
- (void)zoomToPointsAnimated:(BOOL)animated;

@end
