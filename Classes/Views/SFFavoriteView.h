//
//  SFFavoriteView.h
//  Congress
//
//  Created by Daniel Cloud on 1/24/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFFavoriteView : UIView

@property (nonatomic, retain) UISwitch *toggleSwitch;
@property (nonatomic, retain) UIButton *dismissButton;
@property (nonatomic, assign) CGSize overlaySize;

@end
