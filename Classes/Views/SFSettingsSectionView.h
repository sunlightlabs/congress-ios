//
//  SFSettingsSectionView.h
//  Congress
//
//  Created by Daniel Cloud on 4/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFContentView.h"

@class SFLabel;
@class TTTAttributedLabel;
@class SFCongressButton;

@interface SFSettingsSectionView : SFContentView

@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, strong) SFLabel *headerLabel;
@property (nonatomic, strong) SFLabel *disclaimerLabel;
@property (nonatomic, strong) UITableView *settingsTable;

@property (nonatomic, strong) UISwitch *analyticsOptOutSwitch;
@property (nonatomic, strong) SFLabel *analyticsOptOutSwitchLabel;

@end
