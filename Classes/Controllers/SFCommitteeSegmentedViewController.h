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
#import "SFLegislatorTableViewController.h"

@interface SFCommitteeSegmentedViewController : SFShareableViewController <UIViewControllerRestoration>

@property (nonatomic, strong) SFSegmentedViewController *segmentedController;
@property (nonatomic, strong) SFCommitteeDetailViewController *detailController;
@property (nonatomic, strong) SFLegislatorTableViewController *membersController;

- (id)initWithCommittee:(SFCommittee *)committee;
- (id)initWithCommitteeId:(NSString *)committeeId;
- (void)updateWithCommittee:(SFCommittee *)committee;

@end
