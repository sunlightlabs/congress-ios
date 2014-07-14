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
#import <SAMLabel/SAMLabel.h>

@interface SFVoteDetailView : SFContentView

@property (nonatomic, strong) SFLabel *titleLabel;
@property (nonatomic, strong) SAMLabel *dateLabel;
@property (nonatomic, strong) SAMLabel *resultLabel;
@property (nonatomic, strong) UITableView *voteTable;
@property (nonatomic, strong) SAMLabel *followedVoterLabel;
@property (nonatomic, strong) UITableView *followedVoterTable;
@property (nonatomic, strong) SFCongressButton *billButton;
@property (nonatomic, strong) UIScrollView *scrollView;

@end
