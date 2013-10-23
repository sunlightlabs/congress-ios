//
//  SFVoteDetailView.h
//  Congress
//
//  Created by Daniel Cloud on 2/7/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFContentView.h"
#import "SFLabel.h"
#import "SFCongressButton.h"

@interface SFVoteDetailView : SFContentView

@property (nonatomic, strong) SFLabel *titleLabel;
@property (nonatomic, strong) SSLabel *dateLabel;
@property (nonatomic, strong) SSLabel *resultLabel;
@property (nonatomic, strong) UITableView  *voteTable;
@property (nonatomic, strong) SSLabel *followedVoterLabel;
@property (nonatomic, strong) UITableView  *followedVoterTable;
@property (nonatomic, strong) SFCongressButton *billButton;

@end
