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

@end
