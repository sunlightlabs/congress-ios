//
//  SFFavoriteViewController.m
//  Congress
//
//  Created by Daniel Cloud on 1/24/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFFavoriteViewController.h"
#import "SFFavoriteView.h"

@implementation SFFavoriteViewController

@synthesize object;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _initialize];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (object) {
        SFFavoriteView *fView = ((SFFavoriteView *)self.view);
        fView.toggleSwitch.on = object.persist;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

-(void)_initialize
{
    self.view = [[SFFavoriteView alloc] initWithFrame:CGRectZero];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    SFFavoriteView *fView = ((SFFavoriteView *)self.view);
	[fView.dismissButton addTarget:self action:@selector(handleDismissButtonPress) forControlEvents:UIControlEventTouchUpInside];

    [fView.toggleSwitch addTarget:self action:@selector(handleSwitchToggle) forControlEvents:UIControlEventValueChanged];

}

- (void)handleSwitchToggle
{
    SFFavoriteView *fView = ((SFFavoriteView *)self.view);
    object.persist = [fView.toggleSwitch isOn];
}

- (void)handleDismissButtonPress
{
    if ([self.delegate respondsToSelector:@selector(favoriteViewControllerDidDismiss:)]) {
        [self.delegate favoriteViewControllerDidDismiss:self];
    }
}

@end
