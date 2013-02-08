//
//  SFVoteDetailViewController.h
//  Congress
//
//  Created by Daniel Cloud on 2/7/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFVoteDetailView;
@class SFRollCallVote;

@interface SFVoteDetailViewController : UIViewController

@property (nonatomic, retain) SFVoteDetailView * voteDetailView;
@property (nonatomic, retain) SFRollCallVote *vote;

@end
