//
//  SFVoteDetailViewController.h
//  Congress
//
//  Created by Daniel Cloud on 2/7/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@class SFVoteDetailView;
@class SFRollCallVote;

@interface SFVoteDetailViewController : GAITrackedViewController <UIViewControllerRestoration>

@property (nonatomic, retain) SFVoteDetailView * voteDetailView;
@property (nonatomic, retain) SFRollCallVote *vote;

@end
