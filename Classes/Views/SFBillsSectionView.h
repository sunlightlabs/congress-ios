//
//  SFBillListView.h
//  Congress
//
//  Created by Daniel Cloud on 2/5/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFContentView.h"

@interface SFBillsSectionView : SFContentView

@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UISearchBar *searchBar;

@end
