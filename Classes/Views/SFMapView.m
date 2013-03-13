//
//  SFMapView.m
//  Congress
//
//  Created by Jeremy Carbaugh on 3/11/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFMapView.h"

@implementation SFMapView

@synthesize expandoButton = _expandoButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"creating new map view");
        [self _initialize];
    }
    return self;
}

- (void)_initialize
{
    _expandoButton = [[UIButton alloc] initWithFrame:CGRectMake(240.0f, 0.0f, 80.0f, 30.0f)];
    [_expandoButton setBackgroundColor:[[UIColor alloc] initWithRed:1.0 green:0.0 blue:0.0 alpha:0.8]];
    [_expandoButton setTitle:@"RESIZE" forState:UIControlStateNormal];
    [self addSubview:_expandoButton];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
