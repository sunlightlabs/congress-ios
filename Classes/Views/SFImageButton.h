//
//  SFButton.h
//  Congress
//
//  Created by Daniel Cloud on 4/1/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFImageButton : UIButton

+ (instancetype)button;
+ (instancetype)buttonWithDefaultImage:(UIImage *)image;

@property (nonatomic, readonly) CGFloat horizontalPadding;
@property (nonatomic, readonly) CGFloat verticalPadding;

@end
