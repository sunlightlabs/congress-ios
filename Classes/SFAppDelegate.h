//
//  SFAppDelegate.h
//  Congress
//
//  Created by Daniel Cloud on 11/15/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFViewDeckController.h"

@class SFDataArchiver;

@interface SFAppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SFViewDeckController *mainController;
@property (strong, nonatomic) SFDataArchiver *dataArchiver;
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (nonatomic) BOOL wasLastUnreachable;

@end
