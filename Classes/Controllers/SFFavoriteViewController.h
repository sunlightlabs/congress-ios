//
//  SFFavoriteViewController.h
//  Congress
//
//  Created by Daniel Cloud on 1/24/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SynchronizedObject.h"

@protocol SFFavoriteViewControllerDelegate;

@interface SFFavoriteViewController : UIViewController

@property (nonatomic, retain) SynchronizedObject *object;
@property (nonatomic, weak) id<SFFavoriteViewControllerDelegate> delegate;

@end

@protocol SFFavoriteViewControllerDelegate <NSObject>

-(void)favoriteViewControllerDidDismiss:(SFFavoriteViewController *)viewController;

@end
