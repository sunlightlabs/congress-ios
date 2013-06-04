//
//  SFShareableViewController.m
//  Congress
//
//  Created by Daniel Cloud on 1/18/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFShareableViewController.h"
#import <GAI.h>

@implementation SFShareableViewController

#pragma mark - Private

-(void)setUpShareUIElements
{
    _socialButton = [UIBarButtonItem actionButtonWithTarget:self action:@selector(showActivityViewController)];
    [_socialButton setAccessibilityLabel:@"Share"];
    [_socialButton setAccessibilityHint:@"Share with your friends on Facebook, Twitter, and more."];
}

#pragma mark - UIActivityViewController

-(void)showActivityViewController
{
    UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:_shareableObjects
                                      applicationActivities:nil];
    [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) {
        if (completed) {
            
            NSString *service = activityType;
            
            if ([activityType isEqualToString:UIActivityTypeMail]) {
                service = @"Mail";
            } else if ([activityType isEqualToString:UIActivityTypeCopyToPasteboard]) {
                service = @"Clipboard";
            } else if ([activityType isEqualToString:UIActivityTypeMessage]) {
                service = @"Message";
            } else if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
                service = @"Facebook";
            } else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
                service = @"Twitter";
            } else if ([activityType isEqualToString:UIActivityTypePostToWeibo]) {
                service = @"Weibo";
            } else if ([activityType isEqualToString:UIActivityTypePrint]) {
                service = @"Print";
            }
            
            NSURL *shareUrl = nil;
            for (NSObject *obj in _shareableObjects) {
                if ([obj isKindOfClass:[NSURL class]]) {
                    shareUrl = (NSURL *)obj;
                    break;
                }
            }
            
            if (shareUrl) {
                [[[GAI sharedInstance] defaultTracker] sendSocial:service
                                                       withAction:@"Share"
                                                       withTarget:[shareUrl absoluteString]];
            }
        }
        NSLog(@"completed dialog - activity: %@ - finished flag: %d", activityType, completed);
    }];
    [self presentViewController:activityViewController animated:YES completion:NULL];
}


#pragma mark - UIViewController methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setUpShareUIElements];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setRightBarButtonItem:_socialButton];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
