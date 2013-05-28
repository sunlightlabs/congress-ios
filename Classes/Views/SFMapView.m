//
//  SFMapView.m
//  Congress
//
//  Created by Jeremy Carbaugh on 3/11/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFMapView.h"
#import "SFMapToggleButton.h"

@implementation SFMapView

@synthesize expandoButton = _expandoButton;
@synthesize borderLine = _borderLine;

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
    [self addSubview:_expandoButton];
    
    self.showLogoBug = NO;
    self.hideAttribution = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _expandoButton.top = -_expandoButton.verticalPadding;
    _borderLine.top = 0;
    _borderLine.width = self.width;
    _expandoButton.center = CGPointMake(self.center.x, _expandoButton.center.y);
}

- (void)showExpandoButton
{
    [_expandoButton setHidden:NO];
}

- (void)hideExpandoButton
{
    [_expandoButton setHidden:YES];
}

@end
