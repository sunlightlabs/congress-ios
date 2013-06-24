//
//  SFLegislatorVotingRecordTableViewController.h
//  Congress
//
//  Created by Daniel Cloud on 6/5/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFDataTableViewController.h"

@class SFLegislator;

extern SFDataTableSectionTitleGenerator const votedAtTitleBlock;
extern SFDataTableSortIntoSectionsBlock const votedAtSorterBlock;

@interface SFLegislatorVotingRecordTableViewController : SFDataTableViewController

@property (nonatomic, strong) SFLegislator *legislator;

@end
