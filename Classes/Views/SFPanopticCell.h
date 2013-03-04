//
//  SFPanopticCell.h
//  Congress
//
//  Created by Daniel Cloud on 3/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFPanopticCell : UITableViewCell

@property (readonly) CGFloat cellHeight;
@property (nonatomic, strong) NSMutableArray *panels;
@property (nonatomic, strong) UIView *panelsView;
- (void)addPanelView:(UIView *)panelView;

@end
