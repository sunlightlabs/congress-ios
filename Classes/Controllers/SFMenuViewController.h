//
//  SFNavViewController.h
//  Congress
//
//  Created by Daniel Cloud on 11/29/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFImageButton;

@interface SFMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SFImageButton *settingsButton;

-(id)initWithControllers:(NSArray *)controllers menuLabels:(NSArray *)menuLabels settings:(UIViewController *)settingsViewController;

@end
