//
//  SFAppDelegate.h
//  Congress
//
//  Created by Daniel Cloud on 11/15/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFDataArchiver;

@interface SFAppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *leftController;
@property (strong, nonatomic) UIViewController *mainController;
@property (strong, nonatomic) SFDataArchiver *dataArchiver;
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (nonatomic) BOOL wasLastUnreachable;

@end
