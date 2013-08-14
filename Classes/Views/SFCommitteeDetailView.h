//
//  SFCommitteeDetailView.h
//  Congress
//
//  Created by Jeremy Carbaugh on 8/14/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFInsetsView.h"
#import "SFLabel.h"
#import "SFFavoriteButton.h"

@interface SFCommitteeDetailView : SFInsetsView

@property (nonatomic, strong) SSLabel *prefixNameLabel;
@property (nonatomic, strong) SFLabel *primaryNameLabel;
@property (nonatomic, strong) SFFavoriteButton *favoriteButton;
@property (nonatomic, strong) UIView *subcommitteeListView;

@end
