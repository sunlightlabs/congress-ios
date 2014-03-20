//
//  SFMapView.m
//  Congress
//
//  Created by Jeremy Carbaugh on 3/11/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFMapView.h"

@implementation SFMapView {
    BOOL _isRetina;
}

@synthesize borderLine = _borderLine;
@synthesize offlineTileSource = _offlineTileSource;
@synthesize onlineTileSource = _onlineTileSource;
@synthesize isOnline = _isOnline;

- (id)initWithRetinaSupport {
    _isRetina = [[UIScreen mainScreen] scale] > 1.0;
    self = [self initWithFrame:CGRectMake(0.0, 0.0, 1.0, 1.0)];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)_initialize {
    _borderLine = [[SSLineView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1.0f)];
    _borderLine.lineColor = [UIColor mapBorderLineColor];
    [self addSubview:_borderLine];


    self.showLogoBug = NO;
    self.hideAttribution = YES;

    [self useOnlineTiles];
}

- (void)useOfflineTiles {
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

- (void)useOnlineTiles {
    if (_onlineTileSource == nil) {
        _onlineTileSource = [[RMMapboxSource alloc] initWithMapID:_isRetina ? @"sunfoundation.map-3l6khrw5":@"sunfoundation.map-f10t1goc"];
    }
    [self setTileSource:_onlineTileSource];
    [self setAdjustTilesForRetinaDisplay:NO];
    _isOnline = YES;
}

- (NSInteger)maximumZoom {
    return _isOnline ? 20 : 7;
}

#pragma mark - UIAccessibility

- (BOOL)isAccessibilityElement {
    return YES;
}

@end
