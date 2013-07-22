//
//  SFCommitteeSegmentedViewController.h
//  Congress
//
//  Created by Jeremy Carbaugh on 7/20/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFShareableViewController.h"
#import "SFCommittee.h"
#import "SFSegmentedViewController.h"
#import "SFLegislatorTableViewController.h"
#import "SFCommitteesTableViewController.h"

@interface SFCommitteeSegmentedViewController : SFShareableViewController <UIViewControllerRestoration>

@property (nonatomic, strong) SFSegmentedViewController *segmentedController;
@property (nonatomic, strong) SFLegislatorTableViewController *membersController;
@property (nonatomic, strong) SFCommitteesTableViewController *subcommitteesController;

- (id)initWithCommittee:(SFCommittee *)committee;
- (id)initWithCommitteeId:(NSString *)committeeId;
- (void)updateWithCommittee:(SFCommittee *)committee;

@end
