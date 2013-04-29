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
    UIImageView *_imageView;
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
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view.backgroundColor = [UIColor primaryBackgroundColor];

    __tableVC.view.frame = self.view.bounds;
    [self addChildViewController:__tableVC];
    [self.view addSubview:__tableVC.tableView];
    [__tableVC didMoveToParentViewController:self];
    [self.view addSubview:_imageView];
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

    _imageView = [[UIImageView alloc] initWithImage:[UIImage favoritesHelpImage]];
}

- (void)_updateData
{
    NSArray *bills  = [SFBill allObjectsToPersist];
    // sortedArrayUsingDescriptors???
    NSSortDescriptor *lastActionAtSort = [NSSortDescriptor sortDescriptorWithKey:@"lastActionAt" ascending:NO];
    NSArray *orderedBills = [bills sortedArrayUsingDescriptors:@[lastActionAtSort]];
    NSArray *items = [orderedBills arrayByAddingObjectsFromArray:[SFLegislator allObjectsToPersist]];
    __tableVC.items = [NSMutableArray arrayWithArray:items];
//    __tableVC.tableView
    [__tableVC reloadTableView];
    BOOL showHelperImage = [__tableVC.items count] > 0 ? YES : NO;
    [self _helperImageVisible:showHelperImage];
}

- (void)_helperImageVisible:(BOOL)visible
{
    _imageView.hidden = visible;
    __tableVC.tableView.hidden = !visible;
}

#pragma mark - Application state

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {

    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {

    [super decodeRestorableStateWithCoder:coder];
}

@end
