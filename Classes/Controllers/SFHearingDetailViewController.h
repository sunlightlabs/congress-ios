//
//  SFHearingDetailViewController.h
//  Congress
//
//  Created by Jeremy Carbaugh on 8/23/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFHearingDetailView.h"
#import "SFHearing.h"

@interface SFHearingDetailViewController : GAITrackedViewController

@property (nonatomic, strong) SFHearingDetailView *detailView;

- (void)updateWithHearing:(SFHearing *)hearing;

@end
