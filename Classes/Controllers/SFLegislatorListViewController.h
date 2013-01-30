//
//  SFLegislatorListViewController.h
//  Congress
//
//  Created by Daniel Cloud on 1/29/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFLegislatorListViewController : UITableViewController <UITableViewDataSource>

@property (strong, nonatomic) NSArray *legislatorList;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSArray *sectionTitles;

- (void)setUpSectionsUsingSectionTitlePredicate:(NSPredicate *)predicate;

@end
