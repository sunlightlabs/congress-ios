//
//  SFFavoritesSectionViewController.m
//  Congress
//
//  Created by Daniel Cloud on 2/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFFavoritesSectionViewController.h"
#import "IIViewDeckController.h"
#import "SFBill.h"
#import "SFLegislator.h"
#import "SFMixedTableViewController.h"

@implementation SFFavoritesSectionViewController
{
    SFMixedTableViewController *__tableVC;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self _initialize];
        self.trackedViewName = @"Favorites List Screen";
        self.restorationIdentifier = NSStringFromClass(self.class);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

//    __tableVC.view.frame = self.view.frame;
    [self addChildViewController:__tableVC];
    [self.view addSubview:__tableVC.tableView];
    [__tableVC didMoveToParentViewController:self];
    [self _updateData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self _updateData];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)_initialize
{
    self.title = @"Following";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem menuButtonWithTarget:self.viewDeckController action:@selector(toggleLeftView)];

    __tableVC = [[SFMixedTableViewController alloc] initWithStyle:UITableViewStylePlain];
    __tableVC.items = [NSMutableArray array];
}

- (void)_updateData
{
     NSArray *items = [[SFBill allObjectsToPersist] arrayByAddingObjectsFromArray:[SFLegislator allObjectsToPersist]];
    __tableVC.items = [NSMutableArray arrayWithArray:items];
    [__tableVC reloadTableView];
}

#pragma mark - Application state

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {

    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {

    [super decodeRestorableStateWithCoder:coder];
}

@end
