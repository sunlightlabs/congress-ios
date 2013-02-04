//
//  SFFavoritesListViewController.h
//  Congress
//
//  Created by Daniel Cloud on 2/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFMainDeckTableViewController.h"

@interface SFFavoritesListViewController : SFMainDeckTableViewController <UITableViewDataSource>

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSArray *sections;

@end
