//
//  SFActivityListViewController.h
//  Congress
//
//  Created by Daniel Cloud on 11/30/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFActivityListViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *activityList;

-(BOOL)isUpdating;

@end
