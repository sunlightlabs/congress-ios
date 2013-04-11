//
//  SFPanopticCell.h
//  Congress
//
//  Created by Daniel Cloud on 3/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFTableCell.h"

@class SFOpticView;

extern CGFloat const SFOpticViewHeight;
extern CGFloat const SFOpticViewsOffset;
extern CGFloat const SFOpticViewMarginVertical;

@interface SFPanopticCell : SFTableCell

@property (nonatomic, strong) NSMutableArray *panels;
@property (nonatomic, strong) UIView *panelsView;
- (void)addPanelView:(SFOpticView *)panelView;
- (void)setPersistStyle:(BOOL)persist;

@end
