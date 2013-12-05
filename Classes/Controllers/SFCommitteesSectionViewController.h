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

@interface SFCommitteesSectionViewController : GAITrackedViewController <UISearchBarDelegate>

@property (nonatomic, strong) SFCommitteesTableViewController *houseCommitteesController;
@property (nonatomic, strong) SFCommitteesTableViewController *senateCommitteesController;
@property (nonatomic, strong) SFCommitteesTableViewController *jointCommitteesController;
@property (nonatomic, strong) SFSegmentedViewController *segmentedController;

@property (nonatomic) NSInteger *restorationSelectedSegment;

@end
