//
//  SFAppDelegate.h
//  Congress
//
//  Created by Daniel Cloud on 11/15/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFViewDeckController.h"
#import <UAPush.h>

@class SFDataArchiver;
@class SFTagManager;

@interface SFAppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate, UAPushNotificationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SFViewDeckController *mainController;
@property (strong, nonatomic) SFDataArchiver *dataArchiver;
@property (strong, nonatomic) SFTagManager *tagManager;
@property (nonatomic, strong) NSDictionary *settingsToNotificationTypes;

@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (nonatomic) BOOL wasLastUnreachable;

@end
