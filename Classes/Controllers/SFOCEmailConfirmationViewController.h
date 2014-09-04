//
//  SFOCEmailConfirmationViewController.h
//  Congress
//
//  Created by Jeremy Carbaugh on 8/29/14.
//  Copyright (c) 2014 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SFOCEmailConfirmationViewControllerDelegate;

@protocol SFOCEmailConfirmationViewControllerDelegate <NSObject>
@required
- (void)setShouldShowEmailComposer:(BOOL)shouldShow;
@end


@interface SFOCEmailConfirmationViewController : UIViewController

@property (nonatomic, weak) id<SFOCEmailConfirmationViewControllerDelegate> ocEmailConfirmationDelegate;

@end
