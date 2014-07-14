//
//  SFCommitteeDetailView.h
//  Congress
//
//  Created by Jeremy Carbaugh on 8/14/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFContentView.h"
#import "SFLabel.h"
#import "SFCongressButton.h"
#import "SFFollowButton.h"
#import "SFImageButton.h"
#import <SAMLabel/SAMLabel.h>

@interface SFCommitteeDetailView : SFContentView

@property (nonatomic, strong) SAMLabel *prefixNameLabel;
@property (nonatomic, strong) SFLabel *primaryNameLabel;
@property (nonatomic, strong) SFFollowButton *followButton;
@property (nonatomic, strong) SFCongressButton *callButton;
@property (nonatomic, strong) SFImageButton *websiteButton;
@property (nonatomic, strong) UIView *subcommitteeListView;

@property (nonatomic, strong) SFLabel *noSubcommitteesLabel;

@end
