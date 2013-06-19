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
#import "SFSegmentedViewController.h"
#import "SFBillsTableViewController.h"
#import "SFLegislatorTableViewController.h"
#import "SFDataArchiver.h"
#import "SFFollowHowToView.h"

@implementation SFFavoritesSectionViewController
{
    SFSegmentedViewController *_segmentedVC;
    SFBillsTableViewController *_billsVC;
    SFLegislatorTableViewController *_legislatorsVC;
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

    _segmentedVC = [[self class] newSegmentedViewController];
    [self addChildViewController:_segmentedVC];

    _billsVC = [[self class] newBillsTableViewController];
    _billsVC.sectionTitleGenerator = lastActionAtTitleBlock;
    _billsVC.sortIntoSectionsBlock = lastActionAtSorterBlock;

    _legislatorsVC = [[self class] newLegislatorTableViewController];
    _legislatorsVC.sectionTitleGenerator = chamberTitlesGenerator;
    _legislatorsVC.sortIntoSectionsBlock = byChamberSorterBlock;
    _legislatorsVC.orderItemsInSectionsBlock = lastNameFirstOrderBlock;
    [_segmentedVC setViewControllers:@[_billsVC, _legislatorsVC] titles:@[@"Bills", @"Legislators"]];

    _howToView = [[SFFollowHowToView alloc] initWithFrame:CGRectZero];
    _howToView.hidden = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataLoaded) name:SFDataArchiveLoadedNotification object:nil];
}

- (void)_updateData
{
    NSArray *bills  = [SFBill allObjectsToPersist];

    NSSortDescriptor *lastActionAtSort = [NSSortDescriptor sortDescriptorWithKey:@"lastActionAt" ascending:NO];
    NSArray *orderedBills = [bills sortedArrayUsingDescriptors:@[lastActionAtSort]];

    _billsVC.items = orderedBills;
    [_billsVC sortItemsIntoSectionsAndReload];

    _legislatorsVC.items = [SFLegislator allObjectsToPersist];
    [_legislatorsVC sortItemsIntoSectionsAndReload];

    BOOL showHelperImage = ([_billsVC.items count] == 0  && [_legislatorsVC.items count] == 0) ? YES : NO;
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

#pragma mark - Application state

#pragma mark - UIViewControllerRestoration

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    [coder encodeInteger:_segmentedVC.currentSegmentIndex forKey:@"currentSegment"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    NSInteger currentSegmentIndex = [coder decodeIntegerForKey:@"currentSegment"];
    [_segmentedVC displayViewForSegment:currentSegmentIndex];
}

@end
