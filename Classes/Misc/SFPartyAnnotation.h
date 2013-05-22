//
//  SFPartyAnnotation.h
//  Congress
//
//  Created by Jeremy Carbaugh on 5/22/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "RMAnnotation.h"

@interface SFPartyAnnotation : RMAnnotation

@property (nonatomic, retain) NSString *party;

- (id)initWithMapView:(RMMapView *)aMapView coordinate:(CLLocationCoordinate2D)aCoordinate party:(NSString *)party andTitle:(NSString *)aTitle;

@end
