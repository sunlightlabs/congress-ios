//
//  SFBillListView.h
//  Congress
//
//  Created by Daniel Cloud on 2/5/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFCongressView.h"

@interface SFBillsSectionView : SFCongressView

@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UISearchBar *searchBar;

@end
