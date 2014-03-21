//
//  NSLayoutConstraint+Congress.m
//  Congress
//
//  Created by Jeremy Carbaugh on 10/18/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "NSLayoutConstraint+Congress.h"

@implementation NSLayoutConstraint (Congress)

+ (instancetype)constraintWithItem:(id)view attribute:(NSLayoutAttribute)attr constant:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:attr
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                        attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1.0
                                         constant:constant];
}

+ (instancetype)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr toItem:(id)view2 {
    return [NSLayoutConstraint constraintWithItem:view1
                                        attribute:attr
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:view2
                                        attribute:attr
                                       multiplier:1.0
                                         constant:0.0];
}

@end
