//
//  SFLegislatorListViewController.h
//  Congress
//
//  Created by Daniel Cloud on 12/5/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"

@class SFLegislatorListView;

@interface SFLegislatorListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SFLegislatorListView *legislatorListView;
@property (nonatomic, strong) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *legislatorList;
@property (strong, nonatomic) NSMutableArray *sections;
@property (strong, nonatomic) NSArray *sectionTitles;
@property (readonly, nonatomic) NSNumber *perPage;

-(BOOL)isUpdating;

@end
