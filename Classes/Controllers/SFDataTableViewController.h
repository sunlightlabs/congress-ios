//
//  SFDataTableViewController.h
//  Congress
//
//  Created by Daniel Cloud on 2/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFCongressTableViewController.h"

typedef NSUInteger (^SFDataTableSortIntoSectionsBlock)(id obj, NSArray *sectionTitles);
typedef NSArray* (^SFDataTableSectionTitleGenerator)(NSArray *items);
typedef NSArray* (^SFDataTableSectionIndexTitleGenerator)(NSArray *sectionTitles);
typedef NSInteger (^SFDataTableSectionForSectionIndexHandler)(NSString *title, NSInteger index, NSArray *sectionTitles);
typedef NSArray* (^SFDataTableOrderItemsInSectionsBlock)(NSArray *sectionItems);
typedef id (^SFDataTableCellForIndexPathHandler)(NSIndexPath *indexPath);

@interface SFDataTableViewController : SFCongressTableViewController <UITableViewDataSource>

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSArray *sectionTitles;
@property (strong, nonatomic) NSArray *sectionIndexTitles;
@property (readwrite, copy) SFDataTableSortIntoSectionsBlock sortIntoSectionsBlock;
@property (readwrite, copy) SFDataTableOrderItemsInSectionsBlock orderItemsInSectionsBlock;
@property (readwrite, copy) SFDataTableSectionTitleGenerator sectionTitleGenerator;
@property (readwrite, copy) SFDataTableCellForIndexPathHandler cellForIndexPathHandler;

- (void)setSectionTitleGenerator:(SFDataTableSectionTitleGenerator)pSectionTitleGenerator
                sortIntoSections:(SFDataTableSortIntoSectionsBlock)pSectionSorter
            orderItemsInSections:(SFDataTableOrderItemsInSectionsBlock)pOrderItemsInSectionsBlock
         cellForIndexPathHandler:(SFDataTableCellForIndexPathHandler)pCellForIndexPathHandler;
- (void)setSectionIndexTitleGenerator:(SFDataTableSectionIndexTitleGenerator)pSectionIndexTitleGenerator
                  sectionIndexHandler:(SFDataTableSectionForSectionIndexHandler)sectionForSectionIndexHandler;
- (void)reloadTableView;
- (void)sortItemsIntoSections;
- (void)sortItemsIntoSectionsAndReload;

@end
