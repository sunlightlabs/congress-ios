//
//  SFBillsTableViewController.h
//  Congress
//
//  Created by Daniel Cloud on 2/15/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFBillsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *dataArray;

-(void)reloadTableView;

@end
