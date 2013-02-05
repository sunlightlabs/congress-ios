//
//  SFBillListViewController.h
//  Congress
//
//  Created by Daniel Cloud on 11/30/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFMainDeckTableViewController.h"

@class SFBillListView;

@interface SFBillListViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *billList;
@property (strong, nonatomic) NSArray *dataArray;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) SFBillListView *billListView;

-(BOOL)isUpdating;

@end
