//
//  SFTableHeaderView.h
//  Congress
//
//  Created by Daniel Cloud on 4/12/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const SFTableHeaderViewHeight;

@interface SFTableHeaderView : UIView

@property(nonatomic, readonly, retain) UILabel* textLabel;

@property (nonatomic, retain) UIView *backgroundView;

@property (nonatomic, readonly, copy) NSString *reuseIdentifier;

@end
