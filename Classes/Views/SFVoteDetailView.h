//
//  SFVoteDetailView.h
//  Congress
//
//  Created by Daniel Cloud on 2/7/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFVoteDetailView : UIView

@property (nonatomic, retain) SSLabel *titleLabel;
@property (nonatomic, retain) SSLabel *dateLabel;
@property (nonatomic, retain) SSLabel *resultLabel;
@property (nonatomic, retain) UITableView  *voteTable;

@end
