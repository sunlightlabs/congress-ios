//
//  SFLegislatorDetailViewController.h
//  Congress
//
//  Created by Daniel Cloud on 12/13/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapbox.h>
#import <MessageUI/MessageUI.h>
#import "SFDistrictMapViewController.h"
#import "SFShareableViewController.h"
#import "SFFollowing.h"
#import "SFFollowButton.h"
#import "SFOCEmailConfirmationViewController.h"

@class SFLegislator;
@class SFLegislatorDetailView;

@interface SFLegislatorDetailViewController : SFShareableViewController <SFFollowing, UIViewControllerRestoration, MFMailComposeViewControllerDelegate, SFOCEmailConfirmationViewControllerDelegate>

+ (NSDictionary *)socialButtonImages;
- (void)handleEmailButtonPress;

@property (nonatomic, strong, setter = setLegislator:) SFLegislator *legislator;
@property (nonatomic, strong) SFLegislatorDetailView *legislatorDetailView;
@property (nonatomic, strong) SFDistrictMapViewController *mapViewController;

@end
