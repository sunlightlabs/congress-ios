//
//  SFBillListViewController.h
//  Congress
//
//  Created by Daniel Cloud on 11/30/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFMainDeckTableViewController.h"

@interface SFBillListViewController : SFMainDeckTableViewController

@property (strong, nonatomic) NSMutableArray *billList;

-(BOOL)isUpdating;

@end
