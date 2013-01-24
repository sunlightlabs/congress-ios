//
//  SFFavoriteView.m
//  Congress
//
//  Created by Daniel Cloud on 1/24/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFFavoriteView.h"

@implementation SFFavoriteView

@synthesize toggleSwitch = _toggleSwitch;
@synthesize dismissButton = _dismissButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();

    CGRect windowBounds = [[UIScreen mainScreen] bounds];
    CGSize windowSize = windowBounds.size;
    CGRect contentFrame = CGRectMake(roundf((windowSize.width - _overlaySize.width) / 2.0f),
									 roundf((windowSize.height - _overlaySize.height) / 2.0f),
									 _overlaySize.width, _overlaySize.height);

    // Set a 50% gray fill
	CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 0.5f);
    CGContextAddRect(context, contentFrame);
    CGContextFillPath(context);

    self.frame = windowBounds;
}

- (void)layoutSubviews
{
    CGSize frameSize = self.bounds.size;

    // Layout toggle switch
    [_toggleSwitch sizeToFit];
    CGSize switchSize = _toggleSwitch.bounds.size;
    _toggleSwitch.frame = CGRectMake(roundf((frameSize.width-switchSize.width)/2.0f),
                                     roundf((frameSize.height-switchSize.height)/2.0f), switchSize.width, switchSize.height);

    // lay out dismiss button
    [_dismissButton sizeToFit];
    CGSize dismissButtonSize = CGSizeMake(roundf(_overlaySize.width*2/3), _dismissButton.frame.size.height);
    CGFloat offset_y = _toggleSwitch.frame.origin.y + _toggleSwitch.frame.size.height + 10.0f;
    _dismissButton.frame = CGRectMake(roundf((frameSize.width-dismissButtonSize.width)/2.0f),
                                      offset_y, dismissButtonSize.width, dismissButtonSize.height);

}


#pragma mark - Private
-(void)_initialize
{
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];

    _overlaySize = CGSizeMake(250.0f, 200.0f);

    _toggleSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    _toggleSwitch.opaque = YES;
    _toggleSwitch.autoresizingMask = UIViewAutoresizingNone;
    _toggleSwitch.contentMode = UIViewContentModeCenter;
    [self addSubview:_toggleSwitch];


    _dismissButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [self addSubview:_dismissButton];
}

@end
