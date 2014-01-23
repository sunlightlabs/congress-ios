//
//  SFDeckedTableViewController.m
//  Congress
//
//  Created by Daniel Cloud on 12/6/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFMainDeckTableViewController.h"
#import "IIViewDeckController.h"

@implementation SFMainDeckTableViewController

- (id)init {
    self = [super init];
    if (self) {
        self.restorationIdentifier = NSStringFromClass(self.class);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem menuButtonWithTarget:self.viewDeckController action:@selector(toggleLeftView)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Application state

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
}

@end
