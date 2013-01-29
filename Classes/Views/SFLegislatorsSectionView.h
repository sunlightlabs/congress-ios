//
//  SFLegislatorListView.h
//  Congress
//
//  Created by Daniel Cloud on 1/28/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFLegislatorsSectionView : UIView

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UISegmentedControl *scopeBar;
@property (nonatomic, retain) NSArray *scopeBarSegmentTitles;

- (void)setScopeBarSegmentTitles:(NSArray *)segments;

@end
