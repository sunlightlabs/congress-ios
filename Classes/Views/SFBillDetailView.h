//
//  SFBillDetailView.h
//  Congress
//
//  Created by Daniel Cloud on 12/4/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFInsetsView.h"
#import "SFLabel.h"

@interface SFBillDetailView : SFInsetsView
{
    UIScrollView *_scrollView;
}

@property (nonatomic, retain) SFLabel *titleLabel;
@property (nonatomic, retain) SSLabel *subtitleLabel;
@property (nonatomic, retain) SFLabel *summary;
@property (nonatomic, retain) UIButton *sponsorButton;
@property (nonatomic, retain) UIButton *linkOutButton;

@end
