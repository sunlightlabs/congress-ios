//
//  SFPartyAnnotation.m
//  Congress
//
//  Created by Jeremy Carbaugh on 5/22/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFPartyAnnotation.h"

@implementation SFPartyAnnotation

@synthesize party = _party;

- (id)initWithMapView:(RMMapView *)aMapView coordinate:(CLLocationCoordinate2D)aCoordinate party:(NSString *)party andTitle:(NSString *)aTitle
{
    _party = party;
    return [super initWithMapView:aMapView coordinate:aCoordinate andTitle:aTitle];
}

@end
