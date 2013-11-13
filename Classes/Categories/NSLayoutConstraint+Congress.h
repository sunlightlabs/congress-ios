//
//  NSLayoutConstraint+Congress.h
//  Congress
//
//  Created by Jeremy Carbaugh on 10/18/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (Congress)

+ (id)constraintWithItem:(id)view attribute:(NSLayoutAttribute)attr constant:(CGFloat)constant;
+ (id)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr toItem:(id)view2;

@end
