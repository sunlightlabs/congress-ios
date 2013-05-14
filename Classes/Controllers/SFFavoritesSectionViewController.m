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
#import "SFDataArchiver.h"
#import "SFFollowHowToView.h"

@implementation SFFavoritesSectionViewController
{
    SFMixedTableViewController *__tableVC;
    SFFollowHowToView *_howToView;
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

    _howToView.frame = self.view.bounds;
    [self.view addSubview:_howToView];
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

    _howToView = [[SFFollowHowToView alloc] initWithFrame:CGRectZero];
    _howToView.hidden = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataLoaded) name:SFDataArchiveLoadedNotification object:nil];
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
    BOOL showHelperImage = [__tableVC.items count] > 0 ? NO : YES;
    [self _helperImageVisible:showHelperImage];
}

- (void)_helperImageVisible:(BOOL)visible
{
    _howToView.hidden = !visible;
    __tableVC.tableView.hidden = visible;
    if (visible) {
        [_howToView layoutSubviews];
    }
}

- (void)handleDataLoaded
{
    [self _updateData];
}

#pragma mark - Application state

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {

    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {

    [super decodeRestorableStateWithCoder:coder];
}

@end
