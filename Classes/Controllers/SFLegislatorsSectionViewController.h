//
//  SFLegislatorsSectionViewController.h
//  Congress
//
//  Created by Daniel Cloud on 12/5/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"

@class SFLegislatorsSectionView;
@class SFLegislatorListViewController;

@interface SFLegislatorsSectionViewController : UIViewController <UITableViewDelegate>

@property (nonatomic, strong) SFLegislatorsSectionView *legislatorsSectionView;
@property (nonatomic, strong) SFLegislatorListViewController *currentListVC;
@property (nonatomic, strong) NSDictionary *listViewControllers;
@property (strong, nonatomic) NSMutableArray *legislatorList;

-(BOOL)isUpdating;

@end
