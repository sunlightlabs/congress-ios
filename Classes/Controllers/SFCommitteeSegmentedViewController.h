//
//  SFCommitteeSegmentedViewController.h
//  Congress
//
//  Created by Jeremy Carbaugh on 7/20/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFShareableViewController.h"
#import "SFCommittee.h"
#import "SFCommitteeDetailViewController.h"
#import "SFSegmentedViewController.h"
#import "SFCommitteesTableViewController.h"
#import "SFCommitteeMembersTableViewController.h"
#import "SFCommitteeHearingsTableViewController.h"

@interface SFCommitteeSegmentedViewController : SFShareableViewController <UIViewControllerRestoration>

@property (nonatomic, strong) SFSegmentedViewController *segmentedController;
@property (nonatomic, strong) SFCommitteeDetailViewController *detailController;
@property (nonatomic, strong) SFCommitteeMembersTableViewController *membersController;
@property (nonatomic, strong) SFCommitteeHearingsTableViewController *hearingsController;

- (id)initWithCommittee:(SFCommittee *)committee;
- (id)initWithCommitteeId:(NSString *)committeeId;
- (void)updateWithCommittee:(SFCommittee *)committee;
- (void)setVisibleSegment:(NSString *)segmentName;

@end
