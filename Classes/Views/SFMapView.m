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

@synthesize borderLine;
@synthesize offlineTileSource;
@synthesize onlineTileSource;
@synthesize isOnline;

- (id)initWithRetinaSupport {
    _isRetina = [[UIScreen mainScreen] scale] > 1.0;
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:_isRetina ? @"sunfoundation.map-3l6khrw5":@"sunfoundation.map-f10t1goc"];
    self = [self initWithFrame:CGRectMake(0.0, 0.0, 1.0, 1.0) andTilesource:tileSource];
    if (self) {
        self.onlineTileSource = tileSource;
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
    self.borderLine = [[SFLineView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1.0f)];
    self.borderLine.lineColor = [UIColor mapBorderLineColor];
    [self addSubview:self.borderLine];


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
    self.isOnline = NO;
}

- (void)useOnlineTiles {
    if (self.onlineTileSource == nil) {
        self.onlineTileSource = [[RMMapboxSource alloc] initWithMapID:_isRetina ? @"sunfoundation.map-3l6khrw5":@"sunfoundation.map-f10t1goc"];
    }
    if (self.tileSource != self.onlineTileSource) {
        self.tileSource = self.onlineTileSource;
    }
    [self setAdjustTilesForRetinaDisplay:NO];
    self.isOnline = YES;
}

- (NSInteger)maximumZoom {
    return self.isOnline ? 20 : 7;
}

#pragma mark - UIAccessibility

- (BOOL)isAccessibilityElement {
    return YES;
}

@end
