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

@property (nonatomic, retain) UIScrollView *scrollView;
//@property (nonatomic, retain) SFCongressButton *editFavoritesButton;
@property (nonatomic, retain) SFLabel *headerLabel;
@property (nonatomic, retain) TTTAttributedLabel *descriptionLabel;
@property (nonatomic, retain) SFLabel *disclaimerLabel;
@property (nonatomic, retain) UIImageView *logoView;
@property (nonatomic, retain) SFCongressButton *donateButton;
@property (nonatomic, retain) SFCongressButton *feedbackButton;
@property (nonatomic, retain) SFCongressButton *joinButton;
@property (nonatomic, retain) UISwitch *analyticsOptOutSwitch;
@property (nonatomic, retain) SFLabel *analyticsOptOutSwitchLabel;

@end
