//
//  SFHearingsTableViewController.h
//  Congress
//
//  Created by Jeremy Carbaugh on 7/30/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFDataTableViewController.h"

extern SFDataTableSectionTitleGenerator const hearingSectionGenerator;
extern SFDataTableSortIntoSectionsBlock const hearingSectionSorter;

@interface SFHearingsTableViewController : SFDataTableViewController <UITableViewDelegate, UIDataSourceModelAssociation>

@end
