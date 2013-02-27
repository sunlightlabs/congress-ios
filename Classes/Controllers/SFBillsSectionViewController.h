//
//  SFBillsSectionViewController.h
//  Congress
//
//  Created by Daniel Cloud on 11/30/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFMainDeckTableViewController.h"
#import "SFBillsTableViewController.h"

@class SFBillsSectionView;

@interface SFBillsSectionViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *introducedBills;
@property (strong, nonatomic) NSMutableArray *activeBills;
@property (strong, nonatomic) NSMutableArray *billsSearched;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UIViewController *currentVC;

- (void)searchAfterDelay;

@end
