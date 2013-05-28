//
//  SFLegislatorListViewController.h
//  Congress
//
//  Created by Daniel Cloud on 1/29/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFDataTableViewController.h"

extern SFDataTableSectionTitleGenerator const chamberTitlesGenerator;
extern SFDataTableSortIntoSectionsBlock const byChamberSorterBlock;
extern SFDataTableSectionTitleGenerator const stateTitlesGenerator;
extern SFDataTableSectionIndexTitleGenerator const stateSectionIndexTitleGenerator;
extern SFDataTableSectionForSectionIndexHandler const legSectionIndexHandler;
extern SFDataTableSortIntoSectionsBlock const byStateSorterBlock;
extern SFDataTableSectionTitleGenerator const lastNameTitlesGenerator;
extern SFDataTableSortIntoSectionsBlock const byLastNameSorterBlock;
extern SFDataTableOrderItemsInSectionsBlock const lastNameFirstOrderBlock;

@interface SFLegislatorTableViewController : SFDataTableViewController <UITableViewDelegate, UIViewControllerRestoration>

@end
