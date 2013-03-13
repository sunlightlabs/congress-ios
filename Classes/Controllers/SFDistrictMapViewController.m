//
//  SFDistrictMapViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 1/11/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFDistrictMapViewController.h"

@implementation SFDistrictMapViewController

@synthesize isExpanded = _isExpanded;
@synthesize originalFrame = _originalFrame;
@synthesize mapView = _mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        [self _initialize];
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

#pragma mark - RMMapViewDelegate methods

- (void)afterMapMove:(RMMapView *)map byUser:(BOOL)wasUserAction
{
    NSLog(@"map meters per pixel: %f", map.metersPerPixel);
}

- (void)afterMapZoom:(RMMapView *)map byUser:(BOOL)wasUserAction
{
    NSLog(@"map meters per pixel: %f", map.metersPerPixel);
}

#pragma mark - Public

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
    
//    float degreesPerMeter = 0.000009009f;
//    float degrees = _mapView.metersPerPixel * _mapView.frame.origin.y * degreesPerMeter;
//    
//    CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(
//        _mapView.centerCoordinate.latitude + degrees, _mapView.centerCoordinate.longitude);
 
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                        [_mapView setFrame:expandedBounds];
                     }
                     completion:^(BOOL finished) {
                        [_mapView setCenterCoordinate:centerCoord animated:YES];
                        [_mapView setDraggingEnabled:YES];
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
