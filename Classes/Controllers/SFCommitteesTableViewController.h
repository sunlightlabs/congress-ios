//
//  SFCommitteesTableViewController.h
//  Congress
//
//  Created by Jeremy Carbaugh on 7/19/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFDataTableViewController.h"

extern SFDataTableOrderItemsInSectionsBlock const primaryNameOrderBlock;
extern SFDataTableSectionTitleGenerator const subcommitteeSectionGenerator;
extern SFDataTableSortIntoSectionsBlock const subcommitteeSectionSorter;

@interface SFCommitteesTableViewController : SFDataTableViewController <UITableViewDelegate, UIDataSourceModelAssociation>

@end
