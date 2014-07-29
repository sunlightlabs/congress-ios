//
//  SFMapView.h
//  Congress
//
//  Created by Jeremy Carbaugh on 3/11/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Mapbox.h>
#import "SFLineView.h"

@interface SFMapView : RMMapView

@property (nonatomic, strong) SFLineView *borderLine;
@property (nonatomic, strong) id <RMTileSource> offlineTileSource;
@property (nonatomic, strong) id <RMTileSource> onlineTileSource;
@property (nonatomic) BOOL isOnline;

- (id)initWithRetinaSupport;

- (void)useOfflineTiles;
- (void)useOnlineTiles;

- (NSInteger)maximumZoom;

@end
