//
//  SFLocalLegislatorsViewController.h
//  Congress
//
//  Created by Jeremy Carbaugh on 5/28/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CoreLocation.h>
#import "GAITrackedViewController.h"
#import "SFLegislatorTableViewController.h"
#import "SFMapView.h"

@interface SFLocalLegislatorsViewController : GAITrackedViewController <CLLocationManagerDelegate, UIViewControllerRestoration, ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, retain) RMPointAnnotation *coordinateAnnotation;
@property (nonatomic, retain) RMPolygonAnnotation *districtAnnotation;
@property (nonatomic, retain) SFLegislatorTableViewController *localLegislatorListController;
@property (nonatomic, retain) SFMapView *mapView;
@property (nonatomic, retain) UILabel *directionsLabel;

- (void)moveAnnotationToCoordinate:(CLLocationCoordinate2D)coordinate andRecenter:(BOOL)recenter;
- (void)moveAnnotationToAddress:(NSDictionary *)address andRecenter:(BOOL)recenter;
- (void)clearDistrictAnnotation;

@end
