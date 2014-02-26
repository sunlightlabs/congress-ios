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
#import "SFFollowingBillsTableViewController.h"
#import "SFLegislatorTableViewController.h"
#import "SFCommitteesTableViewController.h"
#import "SFDataArchiver.h"
#import "SFFollowHowToView.h"
#import "SFEditFollowedItemsDataSource.h"

@interface SFFollowingSectionViewController () <UITableViewDelegate>

@end

@implementation SFFollowingSectionViewController
{
    SFSegmentedViewController *_segmentedVC;
    SFFollowingBillsTableViewController *_billsVC;
    SFLegislatorTableViewController *_legislatorsVC;
    SFCommitteesTableViewController *_committeesVC;
    SFFollowHowToView *_howToView;
    NSInteger _currentSegmentIndex;
    BOOL _isEditingFollowed;
    UIToolbar *_editBar;
    NSLayoutConstraint *_editContentConstraint;
    NSLayoutConstraint *_segmentBottomConstraint;
    
    UIBarButtonItem *editBarButtonItem;
    UIBarButtonItem *cancelBarButtonItem;
}

- (id)init {
    self = [super init];
    if (self) {
        [self _initialize];
        self.screenName = @"Favorites List Screen";
        self.restorationIdentifier = NSStringFromClass(self.class);
    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self _initializeViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor primaryBackgroundColor];

//    _segmentedVC.view.frame = [[UIScreen mainScreen] bounds];
    [self.view addSubview:_segmentedVC.view];
    [_segmentedVC didMoveToParentViewController:self];
    [_segmentedVC displayViewForSegment:_segmentedVC.currentSegmentIndex];

    [self.view addSubview:_editBar];

    _howToView.frame = self.view.bounds;
    [self.view addSubview:_howToView];

    NSDictionary *views = @{ @"editBar":_editBar, @"content":_segmentedVC.view };

    _editContentConstraint = [NSLayoutConstraint constraintWithItem:_segmentedVC.view attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_editBar attribute:NSLayoutAttributeTop
                                                         multiplier:1.0 constant:0];

    _segmentBottomConstraint = [NSLayoutConstraint constraintWithItem:_segmentedVC.view attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0f constant:0];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[editBar]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[editBar]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[content]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[content]" options:0 metrics:nil views:views]];
    [self.view addConstraint:_segmentBottomConstraint];
    [self.view setNeedsUpdateConstraints];

    [self _updateData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self _updateData];
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self _setFollowedEditable:NO];
    [super viewDidDisappear:animated];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    if (!parent) {
        [self _setFollowedEditable:NO];
    }
    [super didMoveToParentViewController:parent];
}

#pragma mark - Private

- (void)_initialize {
    self.title = @"Following";

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem menuButtonWithTarget:self.viewDeckController action:@selector(toggleLeftView)];
    
    editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleViewEditable)];
    [editBarButtonItem setTintColor:[UIColor navigationBarTextColor]];

    cancelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(toggleViewEditable)];
    [cancelBarButtonItem setTintColor:[UIColor navigationBarTextColor]];
    
    [self.navigationItem setRightBarButtonItem:editBarButtonItem];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataLoaded) name:SFDataArchiveLoadedNotification object:nil];
}

- (id)_initializeViews {
    _segmentedVC = [[self class] newSegmentedViewController];
    _segmentedVC.view.translatesAutoresizingMaskIntoConstraints = NO;
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
    for (UITableViewController *vc in _segmentedVC.viewControllers) {
        [vc.tableView setAllowsMultipleSelectionDuringEditing:YES];
    }
    
    UIBarButtonItem *unfollowButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Unfollow"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(_deleteSelectedCells)];
    [unfollowButtonItem setTintColor:[UIColor navigationBarTextColor]];

    _editBar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    _editBar.translatesAutoresizingMaskIntoConstraints = NO;
    [_editBar setItems:@[unfollowButtonItem]];
    [_editBar setHidden:YES];

    _howToView = [[SFFollowHowToView alloc] initWithFrame:CGRectZero];
    _howToView.hidden = YES;

    return _segmentedVC.view;
}

- (void)_updateData {
    NSArray *bills  = [SFBill allObjectsToPersist];

    NSSortDescriptor *lastActionAtSort = [NSSortDescriptor sortDescriptorWithKey:@"lastActionAt" ascending:NO];
    NSArray *orderedBills = [bills sortedArrayUsingDescriptors:@[lastActionAtSort]];

    _billsVC.dataProvider.items = orderedBills;
    [_billsVC sortItemsIntoSectionsAndReload];

    _legislatorsVC.dataProvider.items = [SFLegislator allObjectsToPersist];
    [_legislatorsVC sortItemsIntoSectionsAndReload];

    _committeesVC.dataProvider.items = [SFCommittee allObjectsToPersist];
    [_committeesVC sortItemsIntoSectionsAndReload];

    if (_currentSegmentIndex) {
        [_segmentedVC displayViewForSegment:_currentSegmentIndex];
    }
    else {
        if ([_billsVC.dataProvider.items count] > 0) {
            [self _helperImageVisible:NO];
            [_segmentedVC displayViewForSegment:0];
        }
        else if ([_legislatorsVC.dataProvider.items count] > 0) {
            [self _helperImageVisible:NO];
            [_segmentedVC displayViewForSegment:1];
        }
        else if ([_committeesVC.dataProvider.items count] > 0) {
            [self _helperImageVisible:NO];
            [_segmentedVC displayViewForSegment:2];
        }
    }

    BOOL showHelperImage = ([_billsVC.dataProvider.items count] == 0  &&
                            [_legislatorsVC.dataProvider.items count] == 0 &&
                            [_committeesVC.dataProvider.items count] == 0) ? YES : NO;
    [self _helperImageVisible:showHelperImage];
}

- (void)_helperImageVisible:(BOOL)visible {
    _howToView.hidden = !visible;
    if (visible) {
        [_howToView layoutSubviews];
    }
}

- (void)handleDataLoaded {
    [self _updateData];
}

- (void)updateSegmentIndex:(id)sender {
    _currentSegmentIndex = [(UISegmentedControl *)sender selectedSegmentIndex];
    [self setViewEditable:NO];
}

#pragma mark - Edit & UITableViewDelegate Edit

- (void)_deleteSelectedCells {
    SFDataTableViewController *vc = (SFDataTableViewController *)_segmentedVC.currentViewController;
    SFEditFollowedItemsDataSource *dataSrc = (SFEditFollowedItemsDataSource *)vc.dataProvider;
    NSArray *deletionIndexes = [vc.tableView indexPathsForSelectedRows];
    if (deletionIndexes) {
        [dataSrc tableView:vc.tableView unfollowObjectsAtIndexPaths:deletionIndexes completion: ^(BOOL isComplete) {
            if (_isEditingFollowed) {
                [self toggleViewEditable];
            }
        }];
    }
}

- (void)toggleViewEditable {
    [self setViewEditable:!_isEditingFollowed];
}

- (void)setViewEditable:(BOOL)isEditable {
    [self _setFollowedEditable:isEditable];
    if ([_editBar isHidden] == isEditable) {
        if ([_editBar isHidden]) {
            _editBar.alpha = 0;
            [_editBar setHidden:!isEditable];
            [self.navigationItem setRightBarButtonItem:cancelBarButtonItem];
        }
        else {
            _editBar.alpha = 1.0f;
            [self.navigationItem setRightBarButtonItem:editBarButtonItem];
        }
//        Animate to show/hide _editBar & update constraints
        [UIView animateWithDuration:0.2f animations: ^{
            _editBar.alpha = isEditable ? 1.0f : 0;
        } completion: ^(BOOL finished) {
            if (!isEditable) {
                [_editBar setHidden:YES];
                [self.view removeConstraint:_editContentConstraint];
                [self.view addConstraint:_segmentBottomConstraint];
            }
            else {
                [self.view removeConstraint:_segmentBottomConstraint];
                [self.view addConstraint:_editContentConstraint];
            }
            [_segmentedVC.view setNeedsUpdateConstraints];
            [self.view setNeedsUpdateConstraints];
        }];
    }
}

- (void)_setFollowedEditable:(BOOL)isEditable {
    _isEditingFollowed = isEditable;
    for (UITableViewController *vc in _segmentedVC.viewControllers) {
        [vc.tableView setEditing:_isEditingFollowed animated:YES];
        [vc.tableView layoutSubviews];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - UIViewControllerRestoration

+ (SFSegmentedViewController *)newSegmentedViewController {
    SFSegmentedViewController *vc = [SFSegmentedViewController new];
    vc.restorationIdentifier = NSStringFromClass([vc class]);
    vc.restorationClass = [self class];
    return vc;
}

+ (SFFollowingBillsTableViewController *)newBillsTableViewController {
    SFFollowingBillsTableViewController *vc = [[SFFollowingBillsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.restorationIdentifier = NSStringFromClass([vc class]);
    vc.restorationClass = [self class];
    return vc;
}

+ (SFLegislatorTableViewController *)newLegislatorTableViewController {
    SFLegislatorTableViewController *vc = [[SFLegislatorTableViewController alloc] initWithStyle:UITableViewStylePlain];
    vc.restorationIdentifier = NSStringFromClass([vc class]);
    vc.restorationClass = [self class];
    return vc;
}

+ (SFCommitteesTableViewController *)newCommitteesTableViewController {
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
