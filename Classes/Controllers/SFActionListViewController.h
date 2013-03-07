//
//  SFActionListViewController.h
//  Congress
//
//  Created by Daniel Cloud on 1/31/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFCongressTableViewController.h"

@interface SFActionListViewController : SFCongressTableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSArray *sectionTitles;

@end
