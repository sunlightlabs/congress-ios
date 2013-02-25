//
//  SFInsetView.h
//  Congress
//
//  Created by Daniel Cloud on 2/25/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFInsetsView : UIView

@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) CGFloat leftInset;
@property (nonatomic, assign) CGFloat topInset;
@property (nonatomic, assign) CGFloat rightInset;
@property (nonatomic, assign) CGFloat bottomInset;
@property (nonatomic, readonly) CGFloat insetsWidth;
@property (nonatomic, assign) CGRect insetsRect;

- (CGRect)frameThatFitsInInsets:(UIView *)view;

@end
