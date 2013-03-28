//
//  SFCongressNavigationController.h
//  Congress
//
//  Created by Daniel Cloud on 3/21/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString * const CongressActivityRestorationId;
FOUNDATION_EXPORT NSString * const CongressFavoritesRestorationId;
FOUNDATION_EXPORT NSString * const CongressBillsRestorationId;
FOUNDATION_EXPORT NSString * const CongressLegislatorsRestorationId;
FOUNDATION_EXPORT NSString * const CongressSettingsRestorationId;


@interface SFCongressNavigationController : UINavigationController <UINavigationControllerDelegate>

@end
