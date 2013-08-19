//
//  SFCommitteeDetailViewController.h
//  Congress
//
//  Created by Jeremy Carbaugh on 7/22/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFShareableViewController.h"
#import "SFFavoriting.h"
#import "SFCommittee.h"
#import "SFCommitteesTableViewController.h"
#import "SFLabel.h"
#import "SFFavoriteButton.h"

@interface SFCommitteeDetailViewController : SFShareableViewController <SFFavoriting, UIActionSheetDelegate>

@property (nonatomic, strong) SFLabel *nameLabel;
@property (nonatomic, strong) SFCommitteesTableViewController *committeeTableController;

- (void)updateWithCommittee:(SFCommittee *)committee;

@end
