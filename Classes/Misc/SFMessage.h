//
//  SFMessage.h
//  Congress
//
//  Created by Jeremy Carbaugh on 5/30/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "TSMessage.h"

extern NSString *const SFMessageDefaultTitle;
extern NSString *const SFMessageDefaultMessage;

@interface SFMessage : TSMessage

+ (void)showInternetError;
+ (void)showDefaultErrorMessageInViewController:(UIViewController *)viewController;
+ (void)showErrorMessageInViewController:(UIViewController *)viewController withMessage:(NSString *)message;
+ (void)showErrorMessageInViewController:(UIViewController *)viewController withMessage:(NSString *)message callback:(void (^) ())callback;

@end
