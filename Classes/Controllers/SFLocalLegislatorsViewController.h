//
//  SFLocalLegislatorsViewController.h
//  Congress
//
//  Created by Jeremy Carbaugh on 5/28/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GAITrackedViewController.h"
#import "SFLegislatorTableViewController.h"
#import "SFMapView.h"

@interface SFLocalLegislatorsViewController : GAITrackedViewController <CLLocationManagerDelegate, UIViewControllerRestoration>

@property (nonatomic, retain) RMPointAnnotation *coordinateAnnotation;
@property (nonatomic, retain) RMPolygonAnnotation *districtAnnotation;
@property (nonatomic, retain) SFLegislatorTableViewController *localLegislatorListController;
@property (nonatomic, retain) SFMapView *mapView;

- (void)moveAnnotationToCoordinate:(CLLocationCoordinate2D)coordinate;

@end
