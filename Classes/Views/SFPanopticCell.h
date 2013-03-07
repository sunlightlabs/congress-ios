//
//  SFPanopticCell.h
//  Congress
//
//  Created by Daniel Cloud on 3/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFTableCell.h"

@interface SFPanopticCell : SFTableCell

@property (readonly) CGFloat cellHeight;
@property (nonatomic, strong) NSMutableArray *panels;
@property (nonatomic, strong) UIView *panelsView;
- (void)addPanelView:(UIView *)panelView;

@end
