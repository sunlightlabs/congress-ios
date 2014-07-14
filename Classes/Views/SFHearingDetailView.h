//
//  SFHearingDetailView.h
//  Congress
//
//  Created by Jeremy Carbaugh on 8/23/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFContentView.h"
#import "SFLabel.h"
#import "SFCongressButton.h"
#import "SFCalloutBackgroundView.h"
#import "SFLineView.h"
#import <SAMLabel/SAMLabel.h>

@interface SFHearingDetailView : SFContentView

@property (nonatomic, strong) SAMLabel *committeePrefixLabel;
@property (nonatomic, strong) SFLabel *committeePrimaryLabel;
@property (nonatomic, strong) SFLabel *descriptionLabel;
@property (nonatomic, strong) SFLabel *locationLabel;
@property (nonatomic, strong) SFLabel *locationLabelLabel;
@property (nonatomic, strong) SFLabel *occursAtLabel;
@property (nonatomic, strong) SFCongressButton *urlButton;
@property (nonatomic, strong) SFCalloutBackgroundView *calloutBackground;
@property (nonatomic, strong) SFLineView *lineView;
@property (nonatomic, strong) UIView *billsTableView;

@property (nonatomic, strong) SFLineView *relatedBillsLine;
@property (nonatomic, strong) SFLabel *relatedBillsLabel;

@end
