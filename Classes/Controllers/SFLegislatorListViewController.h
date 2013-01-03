//
//  SFLegislatorListViewController.h
//  Congress
//
//  Created by Daniel Cloud on 12/5/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFMainDeckTableViewController.h"

@interface SFLegislatorListViewController : SFMainDeckTableViewController

@property (strong, nonatomic) NSMutableArray *legislatorList;
@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) NSArray *sectionTitles;
@property (readonly, nonatomic) NSNumber *perPage;

-(BOOL)isUpdating;

@end
