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
#import "SFFollowButton.h"
#import "SFCongressButton.h"
#import <SAMLabel/SAMLabel.h>

@interface SFBillDetailView : SFContentView

@property (nonatomic, strong) SFLabel *titleLabel;
@property (nonatomic, strong) SAMLabel *dateLabel;
@property (nonatomic, strong) SFLabel *summary;
@property (nonatomic, strong) SFCongressButton *sponsorButton;
@property (nonatomic, strong) SFCongressButton *cosponsorsButton;
@property (nonatomic, strong) SFCongressButton *linkOutButton;
@property (nonatomic, strong) SFFollowButton *followButton;

@end
