//
//  SFBillDetailView.h
//  Congress
//
//  Created by Daniel Cloud on 12/4/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFContentView.h"
#import "SFLabel.h"
#import "SFFavoriteButton.h"
#import "SFCongressButton.h"

@interface SFBillDetailView : SFContentView
{
    UIScrollView *_scrollView;
}

@property (nonatomic, strong) SFLabel *titleLabel;
@property (nonatomic, strong) SSLabel *subtitleLabel;
@property (nonatomic, strong) SFLabel *summary;
@property (nonatomic, strong) SFCongressButton *sponsorButton;
@property (nonatomic, strong) SFCongressButton *cosponsorsButton;
@property (nonatomic, strong) SFCongressButton *linkOutButton;
@property (nonatomic, strong) SFFavoriteButton *favoriteButton;

@end
