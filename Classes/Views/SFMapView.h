//
//  SFMapView.h
//  Congress
//
//  Created by Jeremy Carbaugh on 3/11/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <MapBox/MapBox.h>

@class SFMapToggleButton;

@interface SFMapView : RMMapView

@property (nonatomic, strong) SFMapToggleButton *expandoButton;
@property (nonatomic, strong) SSLineView *borderLine;
@property (nonatomic, strong) id<RMTileSource> offlineTileSource;
@property (nonatomic, strong) id<RMTileSource> onlineTileSource;
@property (nonatomic) BOOL isOnline;

- (id)initWithRetinaSupport;

- (void)useOfflineTiles;
- (void)useOnlineTiles;

- (void)hideExpandoButton;
- (void)showExpandoButton;

- (NSInteger)maximumZoom;

@end
