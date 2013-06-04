//
//  SFLocalLegislatorsViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 5/28/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLocalLegislatorsViewController.h"
#import "SFBoundaryService.h"
#import "SFLegislatorService.h"
#import "SFLegislator.h"
#import "SFMapBoxSource.h"
#import "SFLegislatorTableViewController.h"
#import "SFPeoplePickerNavigationController.h"
#import "SFMessage.h"
#import <GAI.h>

static const int DEFAULT_MAP_ZOOM = 9;
static const double LEGISLATOR_LIST_HEIGHT = 235.0;

@interface SFLocalLegislatorsViewController () {
    CLLocation *_restorationLocation;
    CLLocationManager *_locationManager;
    CLLocationCoordinate2D _currentCoordinate;
    
    UIBarButtonItem *_addressBookButton;
    
    NSString *currentState;
    NSNumber *currentDistrict;
    
    int _locationUpdates;
}

@end

@implementation SFLocalLegislatorsViewController

@synthesize coordinateAnnotation = _coordinateAnnotation;
@synthesize districtAnnotation = _districtAnnotation;
@synthesize localLegislatorListController = _localLegislatorListController;
@synthesize mapView = _mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _initialize];
        self.trackedViewName = @"Local Legislators";
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        _locationManager = nil;
        _currentCoordinate = kCLLocationCoordinate2DInvalid;
        _locationUpdates = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.98f green:0.98f blue:0.92f alpha:1.00f]];
//    self.navigationItem.rightBarButtonItem = _addressBookButton;
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    if (nil == _locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
    }
    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [_localLegislatorListController.view setFrame:CGRectMake(0.0, applicationFrame.size.height - LEGISLATOR_LIST_HEIGHT, 320.0, LEGISLATOR_LIST_HEIGHT)];
    [_localLegislatorListController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_localLegislatorListController.tableView setScrollEnabled:NO];
    
    _localLegislatorListController.sectionTitleGenerator = chamberTitlesGenerator;
    _localLegislatorListController.sortIntoSectionsBlock = byChamberSorterBlock;
    _localLegislatorListController.orderItemsInSectionsBlock = lastNameFirstOrderBlock;
    
    [self addChildViewController:_localLegislatorListController];
    [self.view addSubview:_localLegislatorListController.view];
    
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [longPressGR setMinimumPressDuration:0.3];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapGR setNumberOfTapsRequired:1];
    [tapGR setNumberOfTouchesRequired:1];
    
    _mapView = [[SFMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, applicationFrame.size.height - LEGISLATOR_LIST_HEIGHT)];
    [_mapView setTileSource:[[SFMapBoxSource alloc] initWithRetinaSupport]];
    [_mapView setZoom:DEFAULT_MAP_ZOOM];
    [_mapView addGestureRecognizer:longPressGR];
    [_mapView addGestureRecognizer:tapGR];
    [self.view addSubview:_mapView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (CLLocationCoordinate2DIsValid(_currentCoordinate))
    {
        [self moveAnnotationToCoordinate:_currentCoordinate andRecenter:NO];
    }
    else if (_restorationLocation)
    {
        [self moveAnnotationToCoordinate:_restorationLocation.coordinate andRecenter:YES];
        _restorationLocation = nil;
    }
    else
    {
        _locationUpdates = 0;
        [_locationManager startUpdatingLocation];
    }
}

- (void)viewDidDisappear:(BOOL)animatedd
{
    [_locationManager stopUpdatingLocation];
}


#pragma mark - SFLocalLegislatorsViewController - public

- (void)moveAnnotationToCoordinate:(CLLocationCoordinate2D)coordinate andRecenter:(BOOL)recenter
{
    _currentCoordinate = coordinate;
    
    if (nil == _coordinateAnnotation) {
        _coordinateAnnotation = [[RMPointAnnotation alloc] initWithMapView:_mapView coordinate:coordinate andTitle:nil];
        [_mapView addAnnotation:_coordinateAnnotation];
        recenter = YES;
    } else {
        [_coordinateAnnotation setCoordinate:coordinate];
    }
    
    [self updateLegislatorsForCoordinate:coordinate];
    
    if (recenter) {
        [_mapView setCenterCoordinate:coordinate animated:YES];
    }
}

- (void)moveAnnotationToAddress:(NSDictionary *)address andRecenter:(BOOL)recenter
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressDictionary:address
                     completionHandler:^(NSArray *placemarks, NSError *error) {
                         if (placemarks.count > 0) {
                             CLPlacemark *placemark = [placemarks objectAtIndex:0];
                             [_mapView setZoom:DEFAULT_MAP_ZOOM];
                             [self moveAnnotationToCoordinate:placemark.location.coordinate andRecenter:recenter];
                         } else {
                             // not geocodeable
                         }
                     }];
}

- (void)clearDistrictAnnotation
{
    NSArray *annotations = [NSArray arrayWithArray:_mapView.annotations];
    for (RMAnnotation *annotation in annotations) {
        if ([annotation isKindOfClass:[RMShapeAnnotation class]]) {
            [_mapView removeAnnotation:annotation];
        }
    }
}

#pragma mark - SFLocalLegislatorsViewController - private

- (void)_initialize
{
    [self setTitle:@"Local Legislators"];
    
    _localLegislatorListController = [[SFLegislatorTableViewController alloc] initWithStyle:UITableViewStylePlain];

    _addressBookButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"152-rolodex"]
                                                      style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(selectAddress)];
    [_addressBookButton setAccessibilityLabel:@"Address Book"];
    [_addressBookButton setAccessibilityHint:@"Find who represents an address in your contacts"];
}

- (void)updateLegislatorsForCoordinate:(CLLocationCoordinate2D)coordinate
{
    [SFLegislatorService legislatorsForCoordinate:coordinate completionBlock:^(NSArray *resultsArray) {
        
        NSNumber *district = nil;
        NSString *state = nil;
        NSString *party = nil;
        
        if (resultsArray.count == 0) {
            [self clearDistrictAnnotation];
            _localLegislatorListController.items = nil;
            [_localLegislatorListController sortItemsIntoSectionsAndReload];
            return;
        } else {
            [SFMessage dismissActiveNotification];
        }
        
        if (resultsArray) {
            _localLegislatorListController.items = [NSArray arrayWithArray:resultsArray];
            [_localLegislatorListController sortItemsIntoSectionsAndReload];
            [_localLegislatorListController.view setHidden:NO];
        }
        
        for (SFLegislator *legislator in resultsArray) {
            if (![legislator.title isEqualToString:@"Sen"]) {
                state = legislator.stateAbbreviation;
                district = legislator.district;
                party = legislator.party;
                break;
            }
        }
        
        if (state != nil && district != nil) {
            
            if (![state isEqualToString:currentState] || (currentDistrict == nil || ![district isEqualToNumber:currentDistrict])) {
                
                [self clearDistrictAnnotation];
                
                if (![state isEqualToString:@"AK"]) {
                
                    [[SFBoundaryService sharedInstance] shapeForState:state district:district completionBlock:^(NSArray *shapes) {
                        
                        [self clearDistrictAnnotation];

                        for (NSArray *shape in shapes) {
                            
                            for (NSArray *coordinates in shape) {
                                
                                NSMutableArray *locations = [NSMutableArray arrayWithCapacity:[coordinates count]];
                                for (NSArray *coord in coordinates) {
                                    CLLocation *loc = [[CLLocation alloc] initWithLatitude: [[coord objectAtIndex:1] doubleValue]
                                                                                 longitude: [[coord objectAtIndex:0] doubleValue]];
                                    [locations addObject:loc];
                                }
                                
                                _districtAnnotation = [[RMPolygonAnnotation alloc] initWithMapView:_mapView points:locations];
                                RMShape *shape = (RMShape *)_districtAnnotation.layer;
                                shape.lineWidth = 1.0;
                                
                                if ([party isEqualToString:@"R"])
                                {
                                    shape.fillColor = [UIColor colorWithRed:0.77f green:0.25f blue:0.14f alpha:0.2f];
                                    shape.lineColor = [UIColor colorWithRed:0.77f green:0.25f blue:0.14f alpha:0.6f];
                                }
                                else if ([party isEqualToString:@"D"])
                                {
                                    shape.fillColor = [UIColor colorWithRed:0.07f green:0.38f blue:0.61f alpha:0.2f];
                                    shape.lineColor = [UIColor colorWithRed:0.07f green:0.38f blue:0.61f alpha:0.6f];
                                }
                                else
                                {
                                    shape.fillColor = [UIColor colorWithRed:0.77f green:0.66f blue:0.16f alpha:0.2f];
                                    shape.lineColor = [UIColor colorWithRed:0.77f green:0.66f blue:0.16f alpha:0.6f];
                                }
                                
                                [_mapView addAnnotation:_districtAnnotation];
                            }
                        }
                    }];
                    
                }
                
                currentState = state;
                currentDistrict = district;
                
                [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"Location"
                                                                  withAction:@"Geolocate"
                                                                   withLabel:[NSString stringWithFormat:@"%@-%@", state, district]
                                                                   withValue:nil];
                
            }
        } else {
            [self clearDistrictAnnotation];
        }
        
    }];
}

- (void)selectAddress
{
    SFPeoplePickerNavigationController *picker = [[SFPeoplePickerNavigationController alloc] init];
    [picker setDisplayedProperties:@[[NSNumber numberWithInt:kABPersonAddressProperty], [NSNumber numberWithInt:kABPersonAddressStreetKey]]];
    [picker setPeoplePickerDelegate:self];
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *loc = [locations lastObject];
    
    NSDate* eventDate = loc.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    _locationUpdates++;
    
    NSLog(@"==== geolocation attempt #%d: accuracy=%f", _locationUpdates, loc.horizontalAccuracy);
    
    if ((loc.horizontalAccuracy < 100.0 && abs(howRecent) < 15.0) || _locationUpdates > 5)
    {
        NSLog(@"==== geolocation fixed: accuracy=%f", loc.horizontalAccuracy);
        [self moveAnnotationToCoordinate:loc.coordinate andRecenter:YES];
        [_locationManager stopUpdatingLocation];
    }
    
}

#pragma mark - UIGestureRecognizer

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
    CLLocationCoordinate2D coord = [_mapView pixelToCoordinate:touchPoint];
    [self moveAnnotationToCoordinate:coord andRecenter:YES];
}

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
    CLLocationCoordinate2D coord = [_mapView pixelToCoordinate:touchPoint];
    [self moveAnnotationToCoordinate:coord andRecenter:NO];
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{    
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    [self dismissViewControllerAnimated:YES completion:nil];

    ABMultiValueRef addresses = ABRecordCopyValue(person, property);
    ABMultiValueRef address = ABMultiValueCopyValueAtIndex(addresses, identifier);

    [self moveAnnotationToAddress:(__bridge NSDictionary *)(address) andRecenter:YES];
    
    return NO;
}

#pragma mark - UIViewControllerRestoration

+ (UIViewController*)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    UIViewController *viewController = [[SFLocalLegislatorsViewController alloc] initWithNibName:nil bundle:nil];
    return viewController;
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    if (CLLocationCoordinate2DIsValid(_currentCoordinate)) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:_currentCoordinate.latitude
                                                          longitude:_currentCoordinate.longitude];
        [coder encodeObject:location forKey:@"location"];
    }
    
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    _restorationLocation = [coder decodeObjectForKey:@"location"];
}

@end
