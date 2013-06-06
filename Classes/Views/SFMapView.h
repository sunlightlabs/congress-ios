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

@property (nonatomic, retain) SFMapToggleButton *expandoButton;
@property (nonatomic, retain) SSLineView *borderLine;
@property (nonatomic, retain) id<RMTileSource> offlineTileSource;
@property (nonatomic, retain) id<RMTileSource> onlineTileSource;
@property (nonatomic) BOOL isOnline;

- (id)initWithRetinaSupport;

- (void)useOfflineTiles;
- (void)useOnlineTiles;

- (void)hideExpandoButton;
- (void)showExpandoButton;

- (NSInteger)maximumZoom;

@end
