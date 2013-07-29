//
//  SFInputAccessoryButton.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/29/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFInputAccessoryButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation SFInputAccessoryButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init
{
    UIFont *buttonFont = [UIFont fontWithName:@"Helvetica-Bold" size:10.0f];
    [self.titleLabel setFont:buttonFont];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [[self layer] setBorderWidth:0.5];
    [[self layer] setBorderColor:[[UIColor tableSeparatorColor] CGColor]];
    
    [self setBackgroundColor:[UIColor primaryBackgroundColor]];
    [self setTitleColor:[UIColor primaryTextColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor linkHighlightedTextColor] forState:UIControlStateHighlighted];
}

@end
