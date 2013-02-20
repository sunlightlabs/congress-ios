//
//  SFMixedCellTableViewController.h
//  Congress
//
//  Created by Daniel Cloud on 2/20/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFMixedTableViewController : UITableViewController <UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *items;

@end
