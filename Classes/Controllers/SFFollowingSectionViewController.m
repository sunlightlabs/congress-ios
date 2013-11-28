//
//  SFFollowingSectionViewController.m
//  Congress
//
//  Created by Daniel Cloud on 2/4/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFFollowingSectionViewController.h"
#import "IIViewDeckController.h"
#import "SFBill.h"
#import "SFLegislator.h"
#import "SFCommittee.h"
#import "SFSegmentedViewController.h"
#import "SFBillsTableViewController.h"
#import "SFLegislatorTableViewController.h"
#import "SFCommitteesTableViewController.h"
#import "SFDataArchiver.h"
#import "SFFollowHowToView.h"
#import "SFEditFollowedItemsDataSource.h"

@implementation SFFollowingSectionViewController
{
    SFSegmentedViewController *_segmentedVC;
    SFBillsTableViewController *_billsVC;
    SFLegislatorTableViewController *_legislatorsVC;
    SFCommitteesTableViewController *_committeesVC;
    SFFollowHowToView *_howToView;
    NSInteger _currentSegmentIndex;
    BOOL _isEditingFollowed;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self _initialize];
        self.screenName = @"Favorites List Screen";
        self.restorationIdentifier = NSStringFromClass(self.class);
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self _initializeViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor primaryBackgroundColor];

    _segmentedVC.view.frame = [[UIScreen mainScreen] bounds];
    [self.view addSubview:_segmentedVC.view];
    [_segmentedVC didMoveToParentViewController:self];
    [_segmentedVC displayViewForSegment:_segmentedVC.currentSegmentIndex];

    _howToView.frame = self.view.bounds;
    [self.view addSubview:_howToView];
    [self _updateData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self _updateData];
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self _setFollowedEditable:NO];
    [super viewDidDisappear:animated];
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    if (!parent) {
        [self _setFollowedEditable:NO];
    }
    [super didMoveToParentViewController:parent];
}

#pragma mark - Private

- (void)_initialize
{
    self.title = @"Following";

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem menuButtonWithTarget:self.viewDeckController action:@selector(toggleLeftView)];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleCurrentViewEditable)];
    [self.navigationItem setRightBarButtonItem:editItem];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataLoaded) name:SFDataArchiveLoadedNotification object:nil];
}

- (id)_initializeViews
{
    _segmentedVC = [[self class] newSegmentedViewController];
    [_segmentedVC.segmentedView.segmentedControl addTarget:self action:@selector(updateSegmentIndex:) forControlEvents:UIControlEventValueChanged];
    [self addChildViewController:_segmentedVC];

    _billsVC = [[self class] newBillsTableViewController];
    _billsVC.dataProvider = [SFEditFollowedItemsDataSource new];
    _billsVC.dataProvider.sectionTitleGenerator = lastActionAtTitleBlock;
    _billsVC.dataProvider.sortIntoSectionsBlock = lastActionAtSorterBlock;

    _legislatorsVC = [[self class] newLegislatorTableViewController];
    _legislatorsVC.dataProvider = [SFEditFollowedItemsDataSource new];
    _legislatorsVC.dataProvider.sectionTitleGenerator = chamberTitlesGenerator;
    _legislatorsVC.dataProvider.sortIntoSectionsBlock = byChamberSorterBlock;
    _legislatorsVC.dataProvider.orderItemsInSectionsBlock = lastNameFirstOrderBlock;

    _committeesVC = [[self class] newCommitteesTableViewController];
    _committeesVC.dataProvider = [SFEditFollowedItemsDataSource new];

    [_segmentedVC setViewControllers:@[_billsVC, _legislatorsVC, _committeesVC] titles:@[@"Bills", @"Legislators", @"Committees"]];

    _howToView = [[SFFollowHowToView alloc] initWithFrame:CGRectZero];
    _howToView.hidden = YES;

    return _segmentedVC.view;
}

- (void)_updateData
{
    NSArray *bills  = [SFBill allObjectsToPersist];

    NSSortDescriptor *lastActionAtSort = [NSSortDescriptor sortDescriptorWithKey:@"lastActionAt" ascending:NO];
    NSArray *orderedBills = [bills sortedArrayUsingDescriptors:@[lastActionAtSort]];

    _billsVC.dataProvider.items = orderedBills;
    [_billsVC sortItemsIntoSectionsAndReload];

    _legislatorsVC.dataProvider.items = [SFLegislator allObjectsToPersist];
    [_legislatorsVC sortItemsIntoSectionsAndReload];
    
    _committeesVC.dataProvider.items = [SFCommittee allObjectsToPersist];
    [_committeesVC sortItemsIntoSectionsAndReload];
    
    if (_currentSegmentIndex)
    {
        [_segmentedVC displayViewForSegment:_currentSegmentIndex];
    }
    else
    {
        if ([_billsVC.dataProvider.items count] > 0)
        {
            [self _helperImageVisible:NO];
            [_segmentedVC displayViewForSegment:0];
        }
        else if ([_legislatorsVC.dataProvider.items count] > 0)
        {
            [self _helperImageVisible:NO];
            [_segmentedVC displayViewForSegment:1];
        }
        else if ([_committeesVC.dataProvider.items count] > 0)
        {
            [self _helperImageVisible:NO];
            [_segmentedVC displayViewForSegment:2];
        }
    }

    BOOL showHelperImage = ([_billsVC.dataProvider.items count] == 0  &&
                            [_legislatorsVC.dataProvider.items count] == 0 &&
                            [_committeesVC.dataProvider.items count] == 0) ? YES : NO;
    [self _helperImageVisible:showHelperImage];
}

- (void)_helperImageVisible:(BOOL)visible
{
    _howToView.hidden = !visible;
    if (visible) {
        [_howToView layoutSubviews];
    }
}

- (void)handleDataLoaded
{
    [self _updateData];
}

- (void)updateSegmentIndex:(id)sender
{
    _currentSegmentIndex = [(UISegmentedControl *)sender selectedSegmentIndex];
}

#pragma mark - Edit & UITableViewDelegate Edit

- (void)toggleCurrentViewEditable
{
    [self _setFollowedEditable:!_isEditingFollowed];
}

- (void)_setFollowedEditable:(BOOL)isEditable
{
    _isEditingFollowed = isEditable;
    for (UITableViewController *vc in _segmentedVC.viewControllers) {
        [vc.tableView setAllowsMultipleSelection:_isEditingFollowed];
        [vc setEditing:_isEditingFollowed animated:YES];
    }
}

#pragma mark - UIViewControllerRestoration

+ (SFSegmentedViewController *)newSegmentedViewController
{
    SFSegmentedViewController *vc = [SFSegmentedViewController new];
    vc.restorationIdentifier = NSStringFromClass([vc class]);
    vc.restorationClass = [self class];
    return vc;
}

+ (SFBillsTableViewController *)newBillsTableViewController
{
    SFBillsTableViewController *vc = [[SFBillsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.restorationIdentifier = NSStringFromClass([vc class]);
    vc.restorationClass = [self class];
    return vc;
}

+ (SFLegislatorTableViewController *)newLegislatorTableViewController
{
    SFLegislatorTableViewController *vc = [[SFLegislatorTableViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.restorationIdentifier = NSStringFromClass([vc class]);
    vc.restorationClass = [self class];
    return vc;
}

+ (SFCommitteesTableViewController *)newCommitteesTableViewController
{
    SFCommitteesTableViewController *vc = [[SFCommitteesTableViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.restorationIdentifier = NSStringFromClass([vc class]);
    vc.restorationClass = [self class];
    return vc;
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    [coder encodeInteger:_segmentedVC.currentSegmentIndex forKey:@"currentSegment"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    _currentSegmentIndex = [coder decodeIntegerForKey:@"currentSegment"];
}

@end
