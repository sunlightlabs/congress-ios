//
//  SFSegmentedView.h
//  Congress
//
//  Created by Daniel Cloud on 2/1/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFContentView.h"

@interface SFSegmentedView : SFContentView

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIView *contentView;

@end
