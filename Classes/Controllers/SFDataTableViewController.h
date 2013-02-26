//
//  SFDataTableViewController.h
//  Congress
//
//  Created by Daniel Cloud on 2/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSUInteger (^SFDataTableSectionSorter)(id obj, NSArray *sectionTitles);
typedef NSArray* (^SFDataTableSectionTitleGenerator)(NSArray *items);

@interface SFDataTableViewController : UITableViewController <UITableViewDataSource>

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSArray *sectionTitles;
@property (readwrite, copy) SFDataTableSectionSorter sectionSorter;
@property (readwrite, copy) SFDataTableSectionTitleGenerator sectionTitleGenerator;

- (void)setSectionTitleGenerator:(SFDataTableSectionTitleGenerator)pSectionTitleGenerator sectionSorter:(SFDataTableSectionSorter)pSectionSorter;
- (void)reloadTableView;
- (void)sortItemsIntoSections;
- (void)sortItemsIntoSectionsAndReload;

@end
