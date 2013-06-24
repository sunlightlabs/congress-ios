//
//  SFSettingsSectionView.h
//  Congress
//
//  Created by Daniel Cloud on 4/26/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFLabel;
@class TTTAttributedLabel;
@class SFCongressButton;

@interface SFSettingsSectionView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, retain) SFCongressButton *editFavoritesButton;
@property (nonatomic, strong) SFLabel *headerLabel;
@property (nonatomic, strong) TTTAttributedLabel *descriptionLabel;
@property (nonatomic, strong) SFLabel *disclaimerLabel;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) SFCongressButton *donateButton;
@property (nonatomic, strong) SFCongressButton *feedbackButton;
@property (nonatomic, strong) SFCongressButton *joinButton;
@property (nonatomic, strong) UISwitch *analyticsOptOutSwitch;
@property (nonatomic, strong) SFLabel *analyticsOptOutSwitchLabel;

@end
