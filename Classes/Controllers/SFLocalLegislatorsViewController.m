//
//  SFLocalLegislatorsViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 5/28/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLocalLegislatorsViewController.h"
#import "SFBoundaryService.h"
#import "SFLabel.h"
#import "SFLegislatorService.h"
#import "SFLegislator.h"
#import "SFLegislatorTableViewController.h"
#import "SFPeoplePickerNavigationController.h"
#import "SFMessage.h"
#import "SFAppDelegate.h"

static const int DEFAULT_MAP_ZOOM = 9;
static const double LEGISLATOR_LIST_HEIGHT = 223.0;

static const double MAX_LOCATION_DISTANCE = 2414.017;

static const CLLocationCoordinate2D CENTER_OF_USA = { .latitude = 39.50, .longitude =  -98.35 };

@interface SFLocalLegislatorsViewController () {
    CLLocation *_restorationLocation;
    CLLocationManager *_locationManager;
    CLLocationCoordinate2D _currentCoordinate;

    UIBarButtonItem *_followButton;

    NSString *currentState;
    NSNumber *currentDistrict;

    int _locationUpdates;
}

@end

@implementation SFLocalLegislatorsViewController

static NSString *const LocalLegislatorsFetchErrorMessage = @"Unable to fetch legislators";

@synthesize coordinateAnnotation = _coordinateAnnotation;
@synthesize districtAnnotation = _districtAnnotation;
@synthesize localLegislatorListController = _localLegislatorListController;
@synthesize mapView = _mapView;
@synthesize directionsLabel = _directionsLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _initialize];
        self.screenName = @"Local Legislators";
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        _locationManager = nil;
        _currentCoordinate = kCLLocationCoordinate2DInvalid;
        _locationUpdates = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor colorWithRed:0.98f green:0.98f blue:0.92f alpha:1.00f]];
    self.navigationItem.rightBarButtonItem = _followButton;

    if (nil == _locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
    [_locationManager setDistanceFilter:500];

    // nothing here view

    SFLabel *nothingHereLabel = [[SFLabel alloc] initWithFrame:CGRectMake(0, 30.0, 320.0, 30.0)];
    nothingHereLabel.textColor = [UIColor primaryTextColor];
    nothingHereLabel.font = [UIFont bodySmallFont];
    nothingHereLabel.backgroundColor = [UIColor clearColor];
    nothingHereLabel.numberOfLines = 2;
    nothingHereLabel.translatesAutoresizingMaskIntoConstraints = NO;

    
    [nothingHereLabel setTextAlignment:NSTextAlignmentCenter];
    [nothingHereLabel setText:@"You have left the United States.\nEnjoy your travels!"];

    UIView *nothingHereView = [UIView new];
    [nothingHereView setBackgroundColor:[UIColor colorWithRed:0.98f green:0.98f blue:0.92f alpha:1.00f]];
    [nothingHereView addSubview:nothingHereLabel];
    [self.view addSubview:nothingHereView];

    // legislator list
    [_localLegislatorListController.tableView setScrollEnabled:NO];
    _localLegislatorListController.dataProvider.sectionTitleGenerator = chamberTitlesGenerator;
    _localLegislatorListController.dataProvider.sortIntoSectionsBlock = byChamberSorterBlock;
    _localLegislatorListController.dataProvider.orderItemsInSectionsBlock = lastNameFirstOrderBlock;

    [self addChildViewController:_localLegislatorListController];
    [self.view addSubview:_localLegislatorListController.view];

    // map view gestures

    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [longPressGR setMinimumPressDuration:0.3];

    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapGR setNumberOfTapsRequired:1];
    [tapGR setNumberOfTouchesRequired:1];

    if (![APP_DELEGATE wasLastUnreachable]) {
        _mapView = [[SFMapView alloc] initWithRetinaSupport];
        [_mapView setFrame:CGRectMake(0.0, 0.0, 320.0, [[UIScreen mainScreen] bounds].size.height - LEGISLATOR_LIST_HEIGHT - 80)];
        [_mapView setZoom:MIN(DEFAULT_MAP_ZOOM, [_mapView maximumZoom]) atCoordinate:CENTER_OF_USA animated:NO];

        [_mapView addGestureRecognizer:longPressGR];
        [_mapView addGestureRecognizer:tapGR];
        [self.view addSubview:_mapView];
    }

    // map directions

    _directionsLabel = [[UILabel alloc] init];
    [_directionsLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:10.0f]];
    [_directionsLabel setTextColor:[UIColor colorWithRed:0.91f green:0.91f blue:0.80f alpha:1.00f]];
    [_directionsLabel setBackgroundColor:[UIColor colorWithRed:0.51f green:0.53f blue:0.45f alpha:1.00f]];
    [_directionsLabel setTextAlignment:NSTextAlignmentCenter];
    [_directionsLabel setText:@"TAP THE MAP TO DROP PIN IN A NEW LOCATION"];
    [_directionsLabel setIsAccessibilityElement:NO];
    [self.view addSubview:_directionsLabel];

    /******** auto layout - to move elsewhere ***********/

    UIView *_listView = _localLegislatorListController.view;
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_directionsLabel, _mapView, _listView, nothingHereView);

    [_directionsLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_listView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [nothingHereView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [nothingHereView addConstraint:[NSLayoutConstraint constraintWithItem:nothingHereLabel
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nothingHereView
                                                                attribute:NSLayoutAttributeTopMargin multiplier:1.0 constant:40.0]];

    [nothingHereView addConstraint:[NSLayoutConstraint constraintWithItem:nothingHereLabel
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nothingHereView
                                                                attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_listView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0 constant:0.0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_listView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:LEGISLATOR_LIST_HEIGHT]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_directionsLabel]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDict]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_mapView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDict]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_listView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDict]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[nothingHereView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDict]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_directionsLabel][_mapView][_listView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewDict]];

    [self.view addConstraints:@[
         [NSLayoutConstraint constraintWithItem:nothingHereView
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:_listView
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1.0
                                       constant:1.0],
         [NSLayoutConstraint constraintWithItem:nothingHereView
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:_listView
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1.0
                                       constant:1.0]
     ]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (CLLocationCoordinate2DIsValid(_currentCoordinate)) {
        [self moveAnnotationToCoordinate:_currentCoordinate andRecenter:NO];
    }
    else if (_restorationLocation) {
        [self moveAnnotationToCoordinate:_restorationLocation.coordinate andRecenter:YES];
        _restorationLocation = nil;
    }
    else {
        _locationUpdates = 0;
        [_locationManager startUpdatingLocation];
    }
}

- (void)viewDidDisappear:(BOOL)animatedd {
    [_locationManager stopUpdatingLocation];
}

- (void)setupLayoutConstraints {
}

#pragma mark - SFLocalLegislatorsViewController - public

- (void)moveAnnotationToCoordinate:(CLLocationCoordinate2D)coordinate andRecenter:(BOOL)recenter {
    if (!_mapView)
        return;

    _currentCoordinate = coordinate;

    if (nil == _coordinateAnnotation) {
        UIImage *markerIcon = [UIImage imageNamed:@"MapPin"];
        _coordinateAnnotation = [[RMAnnotation alloc] initWithMapView:_mapView coordinate:coordinate andTitle:nil];
        [_coordinateAnnotation setAnnotationIcon:markerIcon];
        [_coordinateAnnotation setLayer:[[RMMarker alloc] initWithUIImage:markerIcon anchorPoint:CGPointMake(0.5, 0.82)]];
        [_mapView addAnnotation:_coordinateAnnotation];
        recenter = YES;
    }
    else {
        [_coordinateAnnotation setCoordinate:coordinate];
    }

    [self updateLegislatorsForCoordinate:coordinate];

    if (recenter) {
        [_mapView setCenterCoordinate:coordinate animated:YES];
    }
}

- (void)moveAnnotationToAddress:(NSDictionary *)address andRecenter:(BOOL)recenter {
    if (!_mapView)
        return;

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressDictionary:address
                     completionHandler: ^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            [_mapView setZoom:MIN(DEFAULT_MAP_ZOOM, [_mapView maximumZoom])];
            [self moveAnnotationToCoordinate:placemark.location.coordinate andRecenter:recenter];
        }
        else {
            // not geocodeable
        }
    }];
}

- (void)clearDistrictAnnotation {
    if (!_mapView)
        return;

    NSArray *annotations = [NSArray arrayWithArray:_mapView.annotations];
    for (RMAnnotation *annotation in annotations) {
        if ([annotation isKindOfClass:[RMShapeAnnotation class]]) {
            [_mapView removeAnnotation:annotation];
        }
    }
}

#pragma mark - SFLocalLegislatorsViewController - private

- (void)_initialize {
    [self setTitle:@"Local Legislators"];

    _localLegislatorListController = [[SFLegislatorTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    _followButton = [[UIBarButtonItem alloc] initWithImage:[UIImage followingNavButtonImage]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(bulkFollowing)];
    [_followButton setAccessibilityLabel:@"Change following"];
    [_followButton setAccessibilityHint:@"Follow or unfollow all members in this list"];
}

- (void)updateLegislatorsForCoordinate:(CLLocationCoordinate2D)coordinate {
    [SFLegislatorService legislatorsForCoordinate:coordinate completionBlock: ^(NSArray *resultsArray) {
        NSNumber *district = nil;
        NSString *stateName = nil;
        NSString *state = nil;
        NSString *party = nil;

        if (!resultsArray) {
            // Network or other error returns nil
            [SFMessage showErrorMessageInViewController:self withMessage:LocalLegislatorsFetchErrorMessage];
            CLS_LOG(@"%@", LocalLegislatorsFetchErrorMessage);
            return;
        }

        if (resultsArray.count == 0) {
            [self clearDistrictAnnotation];
            [UIView animateWithDuration:0.1
                             animations: ^{ _localLegislatorListController.view.alpha = 0.0; }
                             completion: ^(BOOL finished) {
                    _localLegislatorListController.dataProvider.items = nil;
                    [_localLegislatorListController sortItemsIntoSectionsAndReload];
                }];
            [_mapView setAccessibilityLabel:@"Map of a location outside of the United States"];
            return;
        }
        else {
            [SFMessage dismissActiveNotification];
        }

        _localLegislatorListController.dataProvider.items = [NSArray arrayWithArray:resultsArray];
        [_localLegislatorListController sortItemsIntoSectionsAndReload];
        [UIView animateWithDuration:0.1 animations: ^{ _localLegislatorListController.view.alpha = 1.0; }];

        for (SFLegislator * legislator in resultsArray) {
            state = legislator.stateAbbreviation;
            stateName = legislator.stateName;
            if (![legislator.title isEqualToString:@"Sen"]) {
                district = legislator.district;
                party = legislator.party;
                break;
            }
        }

        if (district == nil) {
            [_mapView setAccessibilityLabel:[NSString stringWithFormat:@"Map of %@", stateName]];
        }
        else if (district == 0) {
            [_mapView setAccessibilityLabel:[NSString stringWithFormat:@"Map of %@, at-large", stateName]];
        }
        else {
            [_mapView setAccessibilityLabel:[NSString stringWithFormat:@"Map of %@, district %@", stateName, district]];
        }

        if (state != nil && district != nil) {
            if (![state isEqualToString:currentState] || (currentDistrict == nil || ![district isEqualToNumber:currentDistrict])) {
                [self clearDistrictAnnotation];

                if (![state isEqualToString:@"AK"]) {
                    [[SFBoundaryService sharedInstance] shapeForState:state district:district completionBlock: ^(NSArray *shapes) {
                            [self clearDistrictAnnotation];

                            for (NSArray * shape in shapes) {
                                for (NSArray * coordinates in shape) {
                                    NSMutableArray *locations = [NSMutableArray arrayWithCapacity:[coordinates count]];
                                    for (NSArray * coord in coordinates) {
                                        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[[coord objectAtIndex:1] doubleValue]
                                                                                     longitude:[[coord objectAtIndex:0] doubleValue]];
                                        [locations addObject:loc];
                                    }

                                    _districtAnnotation = [[RMPolygonAnnotation alloc] initWithMapView:_mapView points:locations];
                                    RMShape *layer = (RMShape *)_districtAnnotation.layer;
                                    layer.lineWidth = 1.0;

                                    if ([party isEqualToString:@"R"]) {
                                        layer.fillColor = [UIColor colorWithRed:0.77f green:0.25f blue:0.14f alpha:0.2f];
                                        layer.lineColor = [UIColor colorWithRed:0.77f green:0.25f blue:0.14f alpha:0.6f];
                                    }
                                    else if ([party isEqualToString:@"D"]) {
                                        layer.fillColor = [UIColor colorWithRed:0.07f green:0.38f blue:0.61f alpha:0.2f];
                                        layer.lineColor = [UIColor colorWithRed:0.07f green:0.38f blue:0.61f alpha:0.6f];
                                    }
                                    else {
                                        layer.fillColor = [UIColor colorWithRed:0.77f green:0.66f blue:0.16f alpha:0.2f];
                                        layer.lineColor = [UIColor colorWithRed:0.77f green:0.66f blue:0.16f alpha:0.6f];
                                    }

                                    [_mapView addAnnotation:_districtAnnotation];
                                }
                            }
                        }];
                }

                currentState = state;
                currentDistrict = district;

                [[[GAI sharedInstance] defaultTracker] send:
                 [[GAIDictionaryBuilder createEventWithCategory:@"Location"
                                                         action:@"Geolocate"
                                                          label:[NSString stringWithFormat:@"%@-%@", state, district]
                                                          value:nil] build]];
            }
        }
        else {
            [self clearDistrictAnnotation];
        }
    }];
}

- (void)bulkFollowing {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"For the legislators representing this location"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    BOOL followAny = NO;
    BOOL followAll = YES;
    
    for (SFLegislator *leg in _localLegislatorListController.dataProvider.items) {
        if ([leg isFollowed]) {
            followAny = YES;
        }
        followAll = followAll & [leg isFollowed];
    }
    
    if (followAny) {
        [actionSheet addButtonWithTitle:@"Unfollow all"];
    }
    if (!followAll) {
        [actionSheet addButtonWithTitle:@"Follow all"];
    }
    
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Unfollow all"]) {
        for (SFLegislator *leg in _localLegislatorListController.dataProvider.items) {
            [leg setFollowed:NO];
        }
        [_localLegislatorListController sortItemsIntoSectionsAndReload];
    } else if ([title isEqualToString:@"Follow all"]) {
        for (SFLegislator *leg in _localLegislatorListController.dataProvider.items) {
            [leg setFollowed:YES];
        }
        [_localLegislatorListController sortItemsIntoSectionsAndReload];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *loc = [locations lastObject];

    NSDate *eventDate = loc.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];

    _locationUpdates++;

    if ((loc.horizontalAccuracy <= MAX_LOCATION_DISTANCE && fabs(howRecent) < 15.0) || _locationUpdates > 2) {
        [self moveAnnotationToCoordinate:loc.coordinate andRecenter:YES];
        [_locationManager stopUpdatingLocation];
    }
    else {
        BOOL wifiReachable = [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
        BOOL generalReachable = [AFNetworkReachabilityManager sharedManager].reachable;
        UIAlertController *alertController = nil;
        if (!wifiReachable) {
            alertController = [self wifiAlertController];
        }
        else if (!generalReachable) {
            alertController = [self accuracyAlertController];
        }
        if (alertController != nil) {
            [self presentViewController:alertController animated:YES completion:nil];
        }

    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorLocationUnknown) {
        [manager stopUpdatingLocation];
        NSString *title = @"Failed to locate you";
        NSString *message = @"We were unable to get a location for you at this time. Sorry!";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:dismissAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (UIAlertController *)wifiAlertController {
    NSString *title = @"Please turn on WiFi to improve accuracy";
    NSString *message = @"We can't get an accurate location for you at this time. Please turn on WiFi to improve location accuracy.";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:dismissAction];
    return alertController;
}


- (UIAlertController *)accuracyAlertController {
    NSString *title = @"Can't accurately determine location";
    NSString *message = @"We can't get an accurate enough location to find your legislators. Sorry!";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:dismissAction];
    return alertController;
}



#pragma mark - UIGestureRecognizer

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;

    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
    CLLocationCoordinate2D coord = [_mapView pixelToCoordinate:touchPoint];
    [self moveAnnotationToCoordinate:coord andRecenter:YES];
}

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
    CLLocationCoordinate2D coord = [_mapView pixelToCoordinate:touchPoint];
    [self moveAnnotationToCoordinate:coord andRecenter:NO];
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier {
    [self dismissViewControllerAnimated:YES completion:nil];

    ABMultiValueRef addresses = ABRecordCopyValue(person, property);
    ABMultiValueRef address = ABMultiValueCopyValueAtIndex(addresses, identifier);

    [self moveAnnotationToAddress:(__bridge NSDictionary *)(address) andRecenter:YES];

    return NO;
}

#pragma mark - UIViewControllerRestoration

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {
    UIViewController *viewController = [[SFLocalLegislatorsViewController alloc] initWithNibName:nil bundle:nil];
    return viewController;
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    if (CLLocationCoordinate2DIsValid(_currentCoordinate)) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:_currentCoordinate.latitude
                                                          longitude:_currentCoordinate.longitude];
        [coder encodeObject:location forKey:@"location"];
    }
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    _restorationLocation = [coder decodeObjectForKey:@"location"];
}

@end
