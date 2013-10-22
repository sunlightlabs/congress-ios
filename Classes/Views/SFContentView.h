//
//  SFContentView.h
//  Congress
//
//  Created by Jeremy Carbaugh on 10/18/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFContentView : UIView

@property (nonatomic) NSUInteger contentOffset;
@property (nonatomic) NSUInteger paddingOffset;
@property (nonatomic, strong) NSMutableArray *constraints;

- (void)updateContentConstraints;

@end
