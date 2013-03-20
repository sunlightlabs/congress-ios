//
//  SFCalloutView.h
//  Congress
//
//  Created by Daniel Cloud on 3/19/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFInsetsView.h"

@interface SFCalloutView : SFInsetsView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, readonly) CGSize contentSize;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end
