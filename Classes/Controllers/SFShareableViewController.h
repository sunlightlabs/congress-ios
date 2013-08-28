//
//  SFShareableViewController.h
//  Congress
//
//  Created by Daniel Cloud on 1/18/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface SFShareableViewController : GAITrackedViewController
{
    UIBarButtonItem *_socialButton;
}

- (NSArray *)activityItems;
- (NSArray *)applicationActivities;

@end
