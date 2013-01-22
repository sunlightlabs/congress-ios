//
//  SFShareableViewController.m
//  Congress
//
//  Created by Daniel Cloud on 1/18/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFShareableViewController.h"
#import "SFAddFavoriteActivity.h"

@implementation SFShareableViewController

#pragma mark - Private

-(void)setUpShareUIElements
{
    _socialButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActivityViewController)];
}

#pragma mark - UIActivityViewController

-(void)showActivityViewController
{
    SFAddFavoriteActivity *addFavActivity = [[SFAddFavoriteActivity alloc] init];
    NSArray *customServices = @[addFavActivity];
    UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:_shareableObjects
                                      applicationActivities:customServices];
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
