//
//  SFDataTableViewController.h
//  Congress
//
//  Created by Daniel Cloud on 2/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFCongressTableViewController.h"
#import "SFDataTableDataSource.h"

@interface SFDataTableViewController : SFCongressTableViewController

@property (nonatomic, strong) SFDataTableDataSource *dataProvider;

- (void)reloadTableView;
- (void)sortItemsIntoSectionsAndReload;

@end
