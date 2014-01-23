//
//  SFDistrictMapViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 1/11/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBoundaryService.h"
#import "SFDistrictMapViewController.h"
#import "SFMapToggleButton.h"
#import "SFAppDelegate.h"

@implementation SFDistrictMapViewController {
    NSArray *_bounds;
}

@synthesize mapView = _mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.restorationIdentifier = NSStringFromClass(self.class);
    }
    return self;
}

- (void)loadView {
    [self _initialize];
    _mapView.frame = [[UIScreen mainScreen] applicationFrame];
    _mapView.autoresizesSubviews = YES;
    self.view = _mapView;
}

#pragma mark - Private

- (void)_initialize {
    if (!_mapView && ![APP_DELEGATE wasLastUnreachable]) {
        _mapView = [[SFMapView alloc] initWithRetinaSupport];
        [_mapView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_mapView setDelegate:self];
        [_mapView setDraggingEnabled:NO];
        [_mapView setZoom:6.0];
    }
}

#pragma mark - Public

- (SFMapView *)mapView {
    if (!_mapView) {
        [self loadView];
    }
    return _mapView;
}

- (void)loadBoundaryForLegislator:(SFLegislator *)legislator {
    if (!_mapView)
        return;

    SFBoundaryService *service = [SFBoundaryService sharedInstance];
    if ([[legislator.stateAbbreviation uppercaseString] isEqualToString:@"AK"]) {
        [_mapView setAccessibilityLabel:@"Map of Alaska"];

        NSMutableArray *locations = [NSMutableArray arrayWithCapacity:2];

        [locations addObject:[[CLLocation alloc] initWithLatitude:56.316537 longitude:-168.750000]];
        [locations addObject:[[CLLocation alloc] initWithLatitude:74.663663 longitude:-138.691406]];

        _bounds = locations;

        [self zoomToPointsAnimated:YES];
    }
    else if (legislator.district) {
        if (legislator.district == 0) {
            [_mapView setAccessibilityLabel:[NSString stringWithFormat:@"Map of %@, at-large", legislator.stateName]];
        }
        else {
            [_mapView setAccessibilityLabel:[NSString stringWithFormat:@"Map of %@ district %@", legislator.stateName, legislator.district]];
        }

        [service shapeForState:legislator.stateAbbreviation
                      district:legislator.district
               completionBlock: ^(NSArray *shapes) {
            NSArray *firstCoordinate = [[[shapes objectAtIndex:0] objectAtIndex:0] objectAtIndex:0];

            double northEastLatitude = [[firstCoordinate objectAtIndex:1] doubleValue];
            double northEastLongitude = [[firstCoordinate objectAtIndex:0] doubleValue];
            double southWestLatitude = northEastLatitude;
            double southWestLongitude = northEastLongitude;

            for (NSArray * shape in shapes) {
                for (NSArray * coordinates in shape) {
                    NSMutableArray *locations = [NSMutableArray arrayWithCapacity:[coordinates count]];
                    for (NSArray * coord in coordinates) {
                        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[[coord objectAtIndex:1] doubleValue]
                                                                     longitude:[[coord objectAtIndex:0] doubleValue]];
                        [locations addObject:loc];

                        northEastLatitude = MAX(northEastLatitude, loc.coordinate.latitude);
                        northEastLongitude = MAX(northEastLongitude, loc.coordinate.longitude);
                        southWestLatitude = MIN(southWestLatitude, loc.coordinate.latitude);
                        southWestLongitude = MIN(southWestLongitude, loc.coordinate.longitude);
                    }

                    RMPolygonAnnotation *annotation = [[RMPolygonAnnotation alloc] initWithMapView:_mapView points:locations];
                    RMShape *layer = (RMShape *)annotation.layer;
                    layer.lineWidth = 1.0;

                    if ([legislator.party isEqualToString:@"R"]) {
                        layer.fillColor = [UIColor colorWithRed:0.77f green:0.25f blue:0.14f alpha:0.2f];
                        layer.lineColor = [UIColor colorWithRed:0.77f green:0.25f blue:0.14f alpha:0.6f];
                    }
                    else if ([legislator.party isEqualToString:@"D"]) {
                        layer.fillColor = [UIColor colorWithRed:0.07f green:0.38f blue:0.61f alpha:0.2f];
                        layer.lineColor = [UIColor colorWithRed:0.07f green:0.38f blue:0.61f alpha:0.6f];
                    }
                    else {
                        layer.fillColor = [UIColor colorWithRed:0.77f green:0.66f blue:0.16f alpha:0.2f];
                        layer.lineColor = [UIColor colorWithRed:0.77f green:0.66f blue:0.16f alpha:0.6f];
                    }

                    [_mapView addAnnotation:annotation];
                }
            }

            _bounds = @[[[CLLocation alloc] initWithLatitude:southWestLatitude longitude:southWestLongitude],
                        [[CLLocation alloc] initWithLatitude:northEastLatitude longitude:northEastLongitude]];

            [self zoomToPointsAnimated:YES];
        }];
    }
    else if (legislator.stateAbbreviation) {
        [_mapView setAccessibilityLabel:[NSString stringWithFormat:@"Map of %@", legislator.stateName]];
        [service boundsForState:legislator.stateAbbreviation
                completionBlock: ^(CLLocationCoordinate2D southWest, CLLocationCoordinate2D northEast) {
            NSMutableArray *locations = [NSMutableArray arrayWithCapacity:2];

            [locations addObject:[[CLLocation alloc] initWithLatitude:southWest.latitude longitude:southWest.longitude]];
            [locations addObject:[[CLLocation alloc] initWithLatitude:northEast.latitude longitude:northEast.longitude]];

            _bounds = locations;

            [self zoomToPointsAnimated:YES];
        }];
    }
}

- (void)zoomToPointsAnimated:(BOOL)animated {
    if (_bounds) {
        CLLocation *southWest = _bounds[0];
        CLLocation *northEast = _bounds[1];

        double latitudeMargin = fabs(southWest.coordinate.latitude - northEast.coordinate.latitude) * 0.25f;
        double longitudeMargin = fabs(southWest.coordinate.longitude - northEast.coordinate.longitude) * 0.25f;

        CLLocation *paddedSouthWest = [[CLLocation alloc] initWithLatitude:southWest.coordinate.latitude - latitudeMargin
                                                                 longitude:southWest.coordinate.longitude - longitudeMargin];
        CLLocation *paddedNorthEast = [[CLLocation alloc] initWithLatitude:northEast.coordinate.latitude + latitudeMargin
                                                                 longitude:northEast.coordinate.longitude + longitudeMargin];

        [_mapView zoomWithLatitudeLongitudeBoundsSouthWest:paddedSouthWest.coordinate
                                                 northEast:paddedNorthEast.coordinate
                                                  animated:animated];
    }
}

- (void)zoomTo:(CGPoint)center {
    CLLocationCoordinate2D coord;
    coord.longitude = center.x;
    coord.latitude = center.y;
    [_mapView setCenterCoordinate:coord animated:YES];
}

@end
