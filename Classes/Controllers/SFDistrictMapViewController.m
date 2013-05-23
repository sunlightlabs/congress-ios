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

@implementation SFDistrictMapViewController {
    NSArray *_bounds;
}

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
    RMMapBoxSource *tileSource = [[RMMapBoxSource alloc] initWithMapID:@"sunfoundation.map-3l6khrw5"];
    [_mapView setTileSource:tileSource];
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

#pragma mark - Public

- (void)loadBoundaryForLegislator:(SFLegislator *)legislator
{
    SFBoundaryService *service = [SFBoundaryService sharedInstance];
    if ([[legislator.stateAbbreviation uppercaseString] isEqualToString:@"AK"])
    {
        NSMutableArray *locations = [NSMutableArray arrayWithCapacity:2];
        
        [locations addObject:[[CLLocation alloc] initWithLatitude:56.316537 longitude:-168.750000]];
        [locations addObject:[[CLLocation alloc] initWithLatitude:74.663663 longitude:-138.691406]];
        
        _bounds = locations;
        
        [self zoomToPointsAnimated:NO];
    }
    else if (legislator.district)
    {   
        [service shapeForState:legislator.stateAbbreviation
                      district:legislator.district
               completionBlock:^(NSArray *shapes) {
                   
                    NSArray *firstCoordinate = [[[shapes objectAtIndex:0] objectAtIndex:0] objectAtIndex:0];
                   
                    double margin = 0.5;

                    double northEastLatitude = [[firstCoordinate objectAtIndex:1] doubleValue];
                    double northEastLongitude = [[firstCoordinate objectAtIndex:0] doubleValue];
                    double southWestLatitude = northEastLatitude;
                    double southWestLongitude = northEastLongitude;
                   
                    for (NSArray *shape in shapes) {
                        
                        for (NSArray *coordinates in shape) {
                            
                            NSMutableArray *locations = [NSMutableArray arrayWithCapacity:[coordinates count]];
                            for (NSArray *coord in coordinates) {
                                CLLocation *loc = [[CLLocation alloc] initWithLatitude: [[coord objectAtIndex:1] doubleValue]
                                                                             longitude: [[coord objectAtIndex:0] doubleValue]];
                                [locations addObject:loc];
                                
                                northEastLatitude = MAX(northEastLatitude, loc.coordinate.latitude);
                                northEastLongitude = MAX(northEastLongitude, loc.coordinate.longitude);
                                southWestLatitude = MIN(southWestLatitude, loc.coordinate.latitude);
                                southWestLongitude = MIN(southWestLongitude, loc.coordinate.longitude);
                            }
                            
                            RMPolygonAnnotation *annotation = [[RMPolygonAnnotation alloc] initWithMapView:_mapView points:locations];
                            RMShape *shape = (RMShape *)annotation.layer;
                            shape.lineWidth = 1.0;
                            
                            if ([legislator.party isEqualToString:@"R"])
                            {
                                shape.fillColor = [UIColor colorWithRed:0.77f green:0.25f blue:0.14f alpha:0.2f];
                                shape.lineColor = [UIColor colorWithRed:0.77f green:0.25f blue:0.14f alpha:0.6f];
                            }
                            else if ([legislator.party isEqualToString:@"D"])
                            {
                                shape.fillColor = [UIColor colorWithRed:0.44f green:0.71f blue:0.72f alpha:0.2f];
                                shape.lineColor = [UIColor colorWithRed:0.44f green:0.71f blue:0.72f alpha:0.6f];
                            }
                            else
                            {
                                shape.fillColor = [UIColor colorWithRed:0.77f green:0.66f blue:0.16f alpha:0.2f];
                                shape.lineColor = [UIColor colorWithRed:0.77f green:0.66f blue:0.16f alpha:0.6f];
                            }
                            
                            [_mapView addAnnotation:annotation];
                        }
                    }
                   
                   _bounds = @[[[CLLocation alloc] initWithLatitude:southWestLatitude - margin longitude:southWestLongitude - margin],
                               [[CLLocation alloc] initWithLatitude:northEastLatitude + margin longitude:northEastLongitude + margin]];
                   
                   [self zoomToPointsAnimated:NO];

                }];
    }
    else if (legislator.stateAbbreviation)
    {
        [service boundsForState:legislator.stateAbbreviation
                completionBlock:^(CLLocationCoordinate2D southWest, CLLocationCoordinate2D northEast) {
                    
                    double margin = 1.0;
                
                    NSMutableArray *locations = [NSMutableArray arrayWithCapacity:2];
                    
                    [locations addObject:[[CLLocation alloc] initWithLatitude:southWest.latitude - margin longitude:southWest.longitude - margin]];
                    [locations addObject:[[CLLocation alloc] initWithLatitude:northEast.latitude + margin longitude:northEast.longitude + margin]];
                    
                    _bounds = locations;
                    
                    [self zoomToPointsAnimated:NO];
                    
                }];
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
    CGRect expandedBounds = CGRectInset(self.parentViewController.view.frame, 0, 4.0);
    expandedBounds = CGRectSetHeight(expandedBounds, self.parentViewController.view.height - 4.0f);

    _originalFrame = _mapView.frame;
 
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                        [_mapView setFrame:expandedBounds];
                     }
                     completion:^(BOOL finished) {
                        [_mapView setDraggingEnabled:YES];
                        [_mapView.expandoButton setSelected:YES];
                        [self zoomToPointsAnimated:YES];
                     }];
    _isExpanded = YES;
}

- (void)shrink
{
    [_mapView setDraggingEnabled:NO];
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                        [_mapView setFrame:_originalFrame];
                     }
                     completion:^(BOOL finished) {
                        [_mapView.expandoButton setSelected:NO];
                        [self zoomToPointsAnimated:YES];
                     }];
    _isExpanded = NO;
}

-(void)zoomToPointsAnimated:(BOOL)animated {
    
    if (_bounds) {
        CLLocation *southWest = _bounds[0];
        CLLocation *northEast = _bounds[1];
        [_mapView zoomWithLatitudeLongitudeBoundsSouthWest:southWest.coordinate
                                                 northEast:northEast.coordinate
                                                  animated:animated];
    }
    
}

- (void)zoomTo:(CGPoint)center
{
    CLLocationCoordinate2D coord;
    coord.longitude = center.x;
    coord.latitude = center.y;
    [_mapView setCenterCoordinate:coord animated:YES];
}

@end
