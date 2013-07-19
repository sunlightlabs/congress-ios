//
//  SFCommitteesSectionViewController.h
//  Congress
//
//  Created by Jeremy Carbaugh on 7/19/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "GAITrackedViewController.h"
#import "SFCommitteesTableViewController.h"
#import "SFSegmentedViewController.h"

@interface SFCommitteesSectionViewController : GAITrackedViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SFCommitteesTableViewController *houseCommitteesController;
@property (nonatomic, strong) SFCommitteesTableViewController *senateCommitteesController;
@property (nonatomic, strong) SFCommitteesTableViewController *jointCommitteesController;
@property (nonatomic, strong) SFSegmentedViewController *segmentedController;

@end
