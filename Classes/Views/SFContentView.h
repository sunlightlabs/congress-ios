//
//  SFContentView.h
//  Congress
//
//  Created by Jeremy Carbaugh on 10/18/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFContentView : UIView

@property (nonatomic) UIEdgeInsets contentInset;
@property (nonatomic, strong) NSMutableArray *contentConstraints;

- (void)setInsetForAllEdges:(CGFloat)insetValue;
- (CGRect)insetRectForRect:(CGRect)rect;
- (CGFloat)insetWidthForRect:(CGRect)rect;
- (CGFloat)insetHeightForRect:(CGRect)rect;
- (void)updateContentConstraints;

@end
