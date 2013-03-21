//
//  SFCongressNavigationController.m
//  Congress
//
//  Created by Daniel Cloud on 3/21/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCongressNavigationController.h"

@interface SFCongressNavigationController ()

@end

@implementation SFCongressNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    navigationController.visibleViewController.navigationItem.backBarButtonItem = [UIBarButtonItem backButton];
    [navigationController.visibleViewController.navigationItem.backBarButtonItem setTitle:@" "];
}

@end
