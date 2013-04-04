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

@implementation SFDistrictMapViewController

@synthesize isExpanded = _isExpanded;
@synthesize originalFrame = _originalFrame;
@synthesize mapView = _mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        [self _initialize];
        self.trackedViewName = @"District Map Screen";
        self.restorationIdentifier = NSStringFromClass(self.class);
    }
    return self;
}

- (void) loadView {
    _mapView.frame = [[UIScreen mainScreen] applicationFrame];
    _mapView.autoresizesSubviews = YES;
    self.view = _mapView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    RMMapBoxSource *tileSource = [[RMMapBoxSource alloc] initWithMapID:@"jcarbaugh.map-u3za2ty4"];
    [_mapView setTileSource:tileSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

-(void)_initialize{
    if (!_mapView) {
        _mapView = [[SFMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1.0, 1.0)];
        [_mapView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_mapView setDelegate:self];
        [_mapView setDraggingEnabled:NO];
        [_mapView.expandoButton setTarget:self action:@selector(handleMapResizeButtonPress) forControlEvents:UIControlEventTouchUpInside];
    }
    _originalFrame = CGRectZero;
}

#pragma mark - RMMapViewDelegate

- (void)afterMapMove:(RMMapView *)map byUser:(BOOL)wasUserAction
{
    NSLog(@"map meters per pixel: %f", map.metersPerPixel);
}

- (void)afterMapZoom:(RMMapView *)map byUser:(BOOL)wasUserAction
{
    NSLog(@"map meters per pixel: %f", map.metersPerPixel);
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{                
    if (annotation.isUserLocationAnnotation)
        return nil;

    RMShape *shape = [[RMShape alloc] initWithView:mapView];

    shape.lineColor = [UIColor colorWithRed:0.77f green:0.66f blue:0.16f alpha:1.0f];
    shape.lineWidth = 1.0;
    shape.fillColor = [UIColor colorWithRed:0.77f green:0.66f blue:0.16f alpha:0.3f];

    for (NSArray *points in self.shapes) {
    
        CLLocation *firstPoint = [points objectAtIndex:0];
        NSLog(@"first point: %@", firstPoint);
        [shape moveToCoordinate:firstPoint.coordinate];
    
        for (CLLocation *point in points) {
            [shape addLineToCoordinate:point.coordinate];
        }
        
    }
    return shape;
}

#pragma mark - Public

- (void)loadBoundaryForLegislator:(SFLegislator *)legislator
{
    if (legislator.district) {
        SFBoundaryService *service = [SFBoundaryService sharedInstance];
        [service centroidForState:legislator.stateAbbreviation
                         district:legislator.district
                  completionBlock:^(CLLocationCoordinate2D centroid) {  
                        [_mapView setZoom:6];
                        [_mapView setCenterCoordinate:centroid];
                        NSLog(@"boundary service centroid: %f, %f", centroid.latitude, centroid.longitude);
                        [service shapeForState:legislator.stateAbbreviation
                                      district:legislator.district
                               completionBlock:^(NSArray *shapes) {
                                    self.shapes = [NSMutableArray arrayWithCapacity:[shapes count]];
                                    for (NSArray *shape in shapes) {
                                        for (NSArray *coordinates in shape) {
                                            NSMutableArray *locations = [NSMutableArray arrayWithCapacity:[coordinates count]];
                                            for (NSArray *coord in coordinates) {
                                                CLLocation *loc = [[CLLocation alloc] initWithLatitude: [[coord objectAtIndex:1] doubleValue]
                                                                                             longitude: [[coord objectAtIndex:0] doubleValue]];
                                                [locations addObject:loc];
                                            }
                                            [self.shapes addObject:locations];
                                        }
                                    }
                                   
                                    RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:_mapView
                                                                                          coordinate:_mapView.centerCoordinate
                                                                                            andTitle:@"Congressional District"];
                                    [_mapView addAnnotation:annotation];
                                    [annotation setBoundingBoxFromLocations:[self.shapes objectAtIndex:0]];
                                }];
                    }];
        
    } else {
        // just center on state
    }
}

-(void)handleMapResizeButtonPress
{
    if (_isExpanded) {
        [self shrink];
    } else {
        [self expand];
    }
}

- (void)expand
{
    CLLocationCoordinate2D centerCoord = _mapView.centerCoordinate;
    CGRect expandedBounds = self.parentViewController.view.frame;

    _originalFrame = _mapView.frame;
    NSLog(@"setting original map frame: %@", NSStringFromCGRect(_originalFrame));
 
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                        [_mapView setFrame:expandedBounds];
                     }
                     completion:^(BOOL finished) {
                        [_mapView setCenterCoordinate:centerCoord animated:YES];
                        [_mapView setDraggingEnabled:YES];
                         [_mapView.expandoButton setSelected:YES];
                        NSLog(@"map expansion complete");
                     }];
    
    _isExpanded = YES;
}

- (void)shrink
{
    CLLocationCoordinate2D centerCoord = _mapView.centerCoordinate;
    [_mapView setDraggingEnabled:NO];
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                        [_mapView setFrame:_originalFrame];
                     }
                    completion:^(BOOL finished) {
                        [_mapView setCenterCoordinate:centerCoord animated:YES];
                        [_mapView.expandoButton setSelected:NO];
                        NSLog(@"map shrink complete");
                     }];
    
    _isExpanded = NO;
}

- (void)zoomTo:(CGPoint)center
{
    CLLocationCoordinate2D coord;
    coord.longitude = center.x;
    coord.latitude = center.y;
    [_mapView setCenterCoordinate:coord animated:YES];
}

@end
