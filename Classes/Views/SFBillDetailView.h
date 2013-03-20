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
#import "SFFavoriteButton.h"
#import "SFCongressButton.h"

@interface SFBillDetailView : SFInsetsView
{
    UIScrollView *_scrollView;
}

@property (nonatomic, retain) SFLabel *titleLabel;
@property (nonatomic, retain) SSLabel *subtitleLabel;
@property (nonatomic, retain) SFLabel *summary;
@property (nonatomic, retain) SFCongressButton *sponsorButton;
@property (nonatomic, retain) SFCongressButton *cosponsorsButton;
@property (nonatomic, retain) SFCongressButton *linkOutButton;
@property (nonatomic, strong) SFFavoriteButton *favoriteButton;

@end
