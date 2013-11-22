//
//  SFCommitteeDetailViewController.h
//  Congress
//
//  Created by Jeremy Carbaugh on 7/22/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFShareableViewController.h"
#import "SFFollowing.h"
#import "SFCommittee.h"
#import "SFCommitteesTableViewController.h"
#import "SFLabel.h"
#import "SFFollowButton.h"

@interface SFCommitteeDetailViewController : SFShareableViewController <SFFollowing, UIActionSheetDelegate>

@property (nonatomic, strong) SFLabel *nameLabel;
@property (nonatomic, strong) SFCommitteesTableViewController *committeeTableController;

- (void)updateWithCommittee:(SFCommittee *)committee;

@end
