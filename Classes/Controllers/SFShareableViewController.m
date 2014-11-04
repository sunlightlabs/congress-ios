//
//  SFShareableViewController.m
//  Congress
//
//  Created by Daniel Cloud on 1/18/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFShareableViewController.h"

@implementation SFShareableViewController

#pragma mark - Private

- (void)setUpShareUIElements {
    _socialButton = [UIBarButtonItem actionButtonWithTarget:self action:@selector(showActivityViewController)];
    [_socialButton setAccessibilityLabel:@"Share"];
    [_socialButton setAccessibilityHint:@"Share with your friends on Facebook, Twitter, and more."];
}

#pragma mark - UIActivityViewController

- (void)showActivityViewController {
    NSArray *items = [self activityItems];

    if (items != nil && [items count] > 0) {
        NSArray *applicationActivities = [self applicationActivities];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items
                                                                                             applicationActivities:applicationActivities];
        activityViewController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
            if (completed) {
                NSString *service = activityType;

                if ([activityType isEqualToString:UIActivityTypeMail]) {
                    service = @"Mail";
                }
                else if ([activityType isEqualToString:UIActivityTypeAddToReadingList]) {
                    service = @"Reading List";
                }
                else if ([activityType isEqualToString:UIActivityTypeAirDrop]) {
                    service = @"AirDrop";
                }
                else if ([activityType isEqualToString:UIActivityTypeCopyToPasteboard]) {
                    service = @"Clipboard";
                }
                else if ([activityType isEqualToString:UIActivityTypeMessage]) {
                    service = @"Message";
                }
                else if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
                    service = @"Facebook";
                }
                else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
                    service = @"Twitter";
                }
                else if ([activityType isEqualToString:UIActivityTypePostToWeibo]) {
                    service = @"Weibo";
                }
                else if ([activityType isEqualToString:UIActivityTypePrint]) {
                    service = @"Print";
                }

                NSURL *shareUrl = nil;
                for (NSObject * obj in items) {
                    if ([obj isKindOfClass:[NSURL class]]) {
                        shareUrl = (NSURL *)obj;
                        break;
                    }
                }

                if (shareUrl) {
                    [[[GAI sharedInstance] defaultTracker] send:
                     [[GAIDictionaryBuilder createSocialWithNetwork:service
                                                             action:@"Share"
                                                             target:[shareUrl absoluteString]] build]];
                }
            }
            NSLog(@"completed dialog - activity: %@ - finished flag: %d", activityType, completed);
        };
        activityViewController.modalPresentationStyle = UIModalPresentationPopover;

        UIPopoverPresentationController *presentationController = [activityViewController popoverPresentationController];
        presentationController.barButtonItem = _socialButton;

        [self presentViewController:activityViewController animated:YES completion:NULL];
    }
}

- (NSArray *)activityItems {
    return @[];
}

- (NSArray *)applicationActivities {
    return nil;
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpShareUIElements];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationItem setRightBarButtonItem:_socialButton];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
