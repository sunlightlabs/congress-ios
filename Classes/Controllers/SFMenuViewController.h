//
//  SFNavViewController.h
//  Congress
//
//  Created by Daniel Cloud on 11/29/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFImageButton;

@interface SFMenuViewController : UIViewController <UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SFImageButton *settingsButton;
@property (nonatomic, strong) SFImageButton *infoButton;
@property (nonatomic, strong) UIImageView *headerImageView;

- (id)initWithControllers:(NSArray *)controllers menuLabels:(NSArray *)menuLabels
                 settings:(UIViewController *)settingsViewController info:(UIViewController *)informationViewController;
- (void)selectMenuItemForController:(UIViewController *)controller animated:(BOOL)animated;

@end
