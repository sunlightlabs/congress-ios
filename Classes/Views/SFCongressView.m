//
//  SFCongressView.m
//  Congress
//
//  Created by Daniel Cloud on 3/7/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCongressView.h"

@implementation SFCongressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor primaryBackgroundColor];
        self.opaque = YES;
    }
    return self;
}

@end
