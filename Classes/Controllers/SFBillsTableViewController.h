//
//  SFBillsTableViewController.h
//  Congress
//
//  Created by Daniel Cloud on 2/15/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFDataTableViewController.h"

extern SFDataTableSectionTitleGenerator const lastActionAtTitleBlock;
extern SFDataTableSortIntoSectionsBlock const lastActionAtSorterBlock;

@interface SFBillsTableViewController : SFDataTableViewController <UITableViewDelegate>

@end
