//
//  SFContentView.m
//  Congress
//
//  Created by Jeremy Carbaugh on 10/18/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFContentView.h"

@implementation SFContentView

@synthesize constraints = _constraints;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentInset = 20;
        self.constraints = [NSMutableArray array];
    }
    return self;
}

- (void)updateConstraints
{
    [self removeConstraints:_constraints];
    [_constraints removeAllObjects];
    
    [self updateContentConstraints];
    
    [self addConstraints:_constraints];
    [super updateConstraints];
}

- (void)updateContentConstraints
{
    // something, something, something
}

@end
