//
//  SFLegislatorBillsTableViewController.h
//  Congress
//
//  Created by Daniel Cloud on 6/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFBillsTableViewController.h"
#import "SFLegislator.h"

@interface SFLegislatorBillsTableViewController : SFBillsTableViewController

@property (nonatomic, strong) SFLegislator *legislator;

@end
