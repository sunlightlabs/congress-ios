//
//  SFMapView.m
//  Congress
//
//  Created by Jeremy Carbaugh on 3/11/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFMapView.h"
#import "SFMapToggleButton.h"

@implementation SFMapView {
    BOOL _isRetina;
}

@synthesize expandoButton = _expandoButton;
@synthesize borderLine = _borderLine;
@synthesize offlineTileSource = _offlineTileSource;
@synthesize onlineTileSource = _onlineTileSource;
@synthesize isOnline = _isOnline;

- (id)initWithRetinaSupport
{
    _isRetina = [[UIScreen mainScreen] scale] > 1.0;
    self = [self initWithFrame:CGRectMake(0.0, 0.0, 1.0, 1.0)];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)_initialize
{
    _borderLine = [[SSLineView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1.0f)];
    _borderLine.lineColor = [UIColor mapBorderLineColor];
    [self addSubview:_borderLine];
    
    _expandoButton = [SFMapToggleButton button];
    [_expandoButton sizeToFit];
    [_expandoButton setHidden:YES];
    [_expandoButton setIsAccessibilityElement:YES];
    [_expandoButton setAccessibilityLabel:@"Expand map to full screen"];
    [_expandoButton setAccessibilityValue:@"Collapsed"];
    [_expandoButton setAccessibilityValue:@"Tap button to make map full screen and interactive."];
    [self addSubview:_expandoButton];
    
    self.showLogoBug = NO;
    self.hideAttribution = YES;
    
    [self useOnlineTiles];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _expandoButton.top = -_expandoButton.verticalPadding;
    _borderLine.top = 0;
    _borderLine.width = self.width;
    _expandoButton.center = CGPointMake(self.center.x, _expandoButton.center.y);
}

- (void)useOfflineTiles
{
//    if (_offlineTileSource == nil) {
//        _offlineTileSource = [[RMMBTilesSource alloc] initWithTileSetResource:@"congress-ios-offline-1.0" ofType:@"mbtiles"];
//    }
//    [self setTileSource:_offlineTileSource];
//    [self setAdjustTilesForRetinaDisplay:_isRetina];
    if ([self.tileSources count] > 0) {
        [self removeTileSourceAtIndex:0];
    }
    _isOnline = NO;
}

- (void)useOnlineTiles
{
    if (_onlineTileSource == nil) {
        _onlineTileSource = [[RMMapBoxSource alloc] initWithMapID:_isRetina ? @"sunfoundation.map-3l6khrw5" : @"sunfoundation.map-f10t1goc"];
    }
    [self setTileSource:_onlineTileSource];
    [self setAdjustTilesForRetinaDisplay:NO];
    _isOnline = YES;
}

- (NSInteger)maximumZoom
{
    return _isOnline ? 20 : 7;
}

- (void)showExpandoButton
{
    [_expandoButton setHidden:NO];
}

- (void)hideExpandoButton
{
    [_expandoButton setHidden:YES];
}

#pragma mark - UIAccessibility

- (BOOL)isAccessibilityElement
{
    return YES;
}

@end
