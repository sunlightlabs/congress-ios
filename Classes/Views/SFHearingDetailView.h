//
//  SFHearingDetailView.h
//  Congress
//
//  Created by Jeremy Carbaugh on 8/23/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFInsetsView.h"
#import "SFLabel.h"
#import "SFCongressButton.h"
#import "SFCalloutBackgroundView.h"

@interface SFHearingDetailView : SFContentView

@property (nonatomic, strong) SSLabel *committeePrefixLabel;
@property (nonatomic, strong) SFLabel *committeePrimaryLabel;
@property (nonatomic, strong) SFLabel *descriptionLabel;
@property (nonatomic, strong) SFLabel *locationLabel;
@property (nonatomic, strong) SFLabel *locationLabelLabel;
@property (nonatomic, strong) SFLabel *occursAtLabel;
@property (nonatomic, strong) SFCongressButton *urlButton;
@property (nonatomic, strong) SFCalloutBackgroundView *calloutBackground;
@property (nonatomic, strong) SSLineView *lineView;
@property (nonatomic, strong) UIView *billsTableView;

@property (nonatomic, strong) SSLineView *relatedBillsLine;
@property (nonatomic, strong) SFLabel *relatedBillsLabel;

@end
