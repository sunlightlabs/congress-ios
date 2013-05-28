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

@interface SFLocalLegislatorsViewController () {
    CLLocation *_restorationLocation;
    CLLocationManager *_locationManager;
    CLLocationCoordinate2D _currentCoordinate;
    
    NSString *currentState;
    NSNumber *currentDistrict;
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
    }
    return self;
}


#pragma mark - SFLocalLegislatorsViewController

- (void)_initialize
{
    _localLegislatorListController = [[SFLegislatorTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self setTitle:@"Local Legislators"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.98f green:0.98f blue:0.92f alpha:1.00f]];
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    if (nil == _locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
    }
    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [_localLegislatorListController.view setFrame:CGRectMake(0.0, 240.0, 320.0, applicationFrame.size.height - 240.0)];
    [_localLegislatorListController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self addChildViewController:_localLegislatorListController];
    [self.view addSubview:_localLegislatorListController.view];
    
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [longPressGR setMinimumPressDuration:0.3];
    
    _mapView = [[SFMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 240.0)
                                  andTilesource:[[RMMapBoxSource alloc] initWithMapID:@"sunfoundation.map-3l6khrw5"]];
    [_mapView setZoom:9.0];
    [_mapView addGestureRecognizer:longPressGR];
    [self.view addSubview:_mapView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (CLLocationCoordinate2DIsValid(_currentCoordinate))
    {
        [self moveAnnotationToCoordinate:_currentCoordinate];
    }
    else if (_restorationLocation)
    {
        [self moveAnnotationToCoordinate:_restorationLocation.coordinate];
        _restorationLocation = nil;
    }
    else
    {
        [_locationManager startUpdatingLocation];
    }
}

- (void)viewDidDisappear:(BOOL)animatedd
{
    [_locationManager stopUpdatingLocation];
}

- (void)moveAnnotationToCoordinate:(CLLocationCoordinate2D)coordinate
{
    _currentCoordinate = coordinate;
    
    if (nil == _coordinateAnnotation) {
        _coordinateAnnotation = [[RMPointAnnotation alloc] initWithMapView:_mapView coordinate:coordinate andTitle:nil];
        [_mapView addAnnotation:_coordinateAnnotation];
    } else {
        [_coordinateAnnotation setCoordinate:coordinate];
    }
    [_mapView setCenterCoordinate:coordinate animated:YES];
    
    [self updateLegislatorsForCoordinate:coordinate];
}

- (void)updateLegislatorsForCoordinate:(CLLocationCoordinate2D)coordinate
{
    [SFLegislatorService legislatorsForCoordinate:coordinate completionBlock:^(NSArray *resultsArray) {
        
        NSNumber *district = nil;
        NSString *state = nil;
        NSString *party = nil;
        
        if (resultsArray) {
            _localLegislatorListController.items = [NSArray arrayWithArray:resultsArray];
            [_localLegislatorListController reloadTableView];
        }
        
        for (SFLegislator *legislator in resultsArray) {
            if (![legislator.title isEqualToString:@"Sen"]) {
                state = legislator.stateAbbreviation;
                district = legislator.district;
                party = legislator.party;
                break;
            }
        }
        
        if (state != nil && ![state isEqualToString:@"AK"] && district != nil) {
            
            if (![state isEqualToString:currentState] || (currentDistrict == nil || ![district isEqualToNumber:currentDistrict])) {
                
                [[SFBoundaryService sharedInstance] shapeForState:state district:district completionBlock:^(NSArray *shapes) {

                    for (NSArray *shape in shapes) {
                        
                        for (NSArray *coordinates in shape) {
                            
                            NSMutableArray *locations = [NSMutableArray arrayWithCapacity:[coordinates count]];
                            for (NSArray *coord in coordinates) {
                                CLLocation *loc = [[CLLocation alloc] initWithLatitude: [[coord objectAtIndex:1] doubleValue]
                                                                             longitude: [[coord objectAtIndex:0] doubleValue]];
                                [locations addObject:loc];
                            }
                            
                            if (nil != _districtAnnotation)
                            {
                                [_mapView removeAnnotation:_districtAnnotation];
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
                
                currentState = state;
                currentDistrict = district;
                
            }
        }
        
    }];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *loc = [locations lastObject];
    
    NSDate* eventDate = loc.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if (abs(howRecent) < 15.0)
    {
        [self moveAnnotationToCoordinate:loc.coordinate];
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
    [self moveAnnotationToCoordinate:coord];
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
