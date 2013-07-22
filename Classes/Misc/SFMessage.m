//
//  SFMessage.m
//  Congress
//
//  Created by Jeremy Carbaugh on 5/30/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFMessage.h"
#import <TSMessageView.h>
#import "SFAppDelegate.h"

NSString * const SFMessageDefaultTitle = @"Aw, shucks";
NSString * const SFMessageDefaultMessage = @"The app encountered an error.";

@implementation SFMessage

+ (UIViewController *)defaultViewController
{
    SFAppDelegate *appDelegate = (SFAppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.mainController;
}

+ (void)showDefaultErrorMessageInViewController:(UIViewController *)viewController
{
    [[self class] showNotificationInViewController:viewController
                                         withTitle:SFMessageDefaultTitle withMessage:SFMessageDefaultMessage
                                          withType:TSMessageNotificationTypeError];
}

+ (void)showErrorMessageInViewController:(UIViewController *)viewController withMessage:(NSString *)message
{
    [[self class] showNotificationInViewController:viewController
                                         withTitle:SFMessageDefaultTitle withMessage:message
                                          withType:TSMessageNotificationTypeError];
}

+ (void)showErrorMessageInViewController:(UIViewController *)viewController withMessage:(NSString *)message callback:(void (^)())callback
{
    [[self class] showNotificationInViewController:viewController withTitle:SFMessageDefaultTitle withMessage:message withType:TSMessageNotificationTypeError withDuration:TSMessageNotificationDurationEndless withCallback:callback];
}

@end
