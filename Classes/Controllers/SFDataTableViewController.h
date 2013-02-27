//
//  SFDataTableViewController.h
//  Congress
//
//  Created by Daniel Cloud on 2/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSUInteger (^SFDataTableSortIntoSectionsBlock)(id obj, NSArray *sectionTitles);
typedef NSArray* (^SFDataTableSectionTitleGenerator)(NSArray *items);
typedef NSArray* (^SFDataTableOrderItemsInSectionsBlock)(NSArray *sectionItems);

@interface SFDataTableViewController : UITableViewController <UITableViewDataSource>

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSArray *sectionTitles;
@property (readwrite, copy) SFDataTableSortIntoSectionsBlock sortIntoSectionsBlock;
@property (readwrite, copy) SFDataTableOrderItemsInSectionsBlock orderItemsInSectionsBlock;
@property (readwrite, copy) SFDataTableSectionTitleGenerator sectionTitleGenerator;

- (void)setSectionTitleGenerator:(SFDataTableSectionTitleGenerator)pSectionTitleGenerator
                sortIntoSections:(SFDataTableSortIntoSectionsBlock)pSectionSorter
            orderItemsInSections:(SFDataTableOrderItemsInSectionsBlock)pOrderItemsInSectionsBlock;
- (void)reloadTableView;
- (void)sortItemsIntoSections;
- (void)sortItemsIntoSectionsAndReload;

@end
