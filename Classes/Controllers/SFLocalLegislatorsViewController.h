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

@interface SFLocalLegislatorsViewController : GAITrackedViewController <CLLocationManagerDelegate, UIViewControllerRestoration, ABPeoplePickerNavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) RMAnnotation *coordinateAnnotation;
@property (nonatomic, strong) RMPolygonAnnotation *districtAnnotation;
@property (nonatomic, strong) SFLegislatorTableViewController *localLegislatorListController;
@property (nonatomic, strong) SFMapView *mapView;
@property (nonatomic, strong) UILabel *directionsLabel;

- (void)moveAnnotationToCoordinate:(CLLocationCoordinate2D)coordinate andRecenter:(BOOL)recenter;
- (void)moveAnnotationToAddress:(NSDictionary *)address andRecenter:(BOOL)recenter;
- (void)clearDistrictAnnotation;

@end
