//
//  SFCommitteesSectionViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/19/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteesSectionViewController.h"
#import "SFCommitteeService.h"

@interface SFCommitteesSectionViewController ()

@end

@implementation SFCommitteesSectionViewController {
    NSArray *_sectionTitles;
}

@synthesize houseCommitteesController = _houseCommitteesController;
@synthesize senateCommitteesController = _senateCommitteesController;
@synthesize jointCommitteesController = _jointCommitteesController;
@synthesize segmentedController = _segmentedController;
@synthesize restorationSelectedSegment = _restorationSelectedSegment;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.screenName = @"Committee Section Screen";
        self.restorationIdentifier = NSStringFromClass(self.class);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.title = @"Committees";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem menuButtonWithTarget:self.viewDeckController action:@selector(toggleLeftView)];

    _segmentedController = [[SFSegmentedViewController alloc] init];
    [_segmentedController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addChildViewController:_segmentedController];

    _houseCommitteesController = [[SFCommitteesTableViewController alloc] initWithStyle:UITableViewStylePlain];
//    _houseCommitteesController.dataTableDataSource.orderItemsInSectionsBlock = nameOrderBlock;

    _senateCommitteesController = [[SFCommitteesTableViewController alloc] initWithStyle:UITableViewStylePlain];
//    _senateCommitteesController.dataTableDataSource.orderItemsInSectionsBlock = nameOrderBlock;

    _jointCommitteesController = [[SFCommitteesTableViewController alloc] initWithStyle:UITableViewStylePlain];
//    _jointCommitteesController.dataTableDataSource.orderItemsInSectionsBlock = nameOrderBlock;

    _sectionTitles = @[@"House", @"Senate", @"Joint"];
    [_segmentedController setViewControllers:@[_houseCommitteesController, _senateCommitteesController, _jointCommitteesController] titles:_sectionTitles];

    [self.view addSubview:_segmentedController.view];
    [_segmentedController didMoveToParentViewController:self];
    [_segmentedController displayViewForSegment:0];

    /* layout */

    NSDictionary *viewDict = @{ @"segments": _segmentedController.view,
                                @"house": _houseCommitteesController.view,
                                @"senate": _senateCommitteesController.view,
                                @"joint": _jointCommitteesController };

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[segments]|" options:0 metrics:nil views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[segments]|" options:0 metrics:nil views:viewDict]];
}

- (void)viewWillAppear:(BOOL)animated {
    [self update];
}

- (void)viewDidAppear:(BOOL)animated {
    if (_restorationSelectedSegment != nil) {
        [_segmentedController displayViewForSegment:_restorationSelectedSegment];
        _restorationSelectedSegment = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)update {
    [SFCommitteeService committeesWithCompletionBlock: ^(NSArray *resultsArray) {
        if (resultsArray) {
            NSMutableArray *house = [[NSMutableArray alloc] init];
            NSMutableArray *senate = [[NSMutableArray alloc] init];
            NSMutableArray *joint = [[NSMutableArray alloc] init];

            for (SFCommittee * committee in resultsArray) {
                if ([committee.chamber isEqualToString:@"house"]) {
                    [house addObject:committee];
                }
                else if ([committee.chamber isEqualToString:@"senate"]) {
                    [senate addObject:committee];
                }
                else if ([committee.chamber isEqualToString:@"joint"]) {
                    [joint addObject:committee];
                }
            }

            [_houseCommitteesController.dataProvider setItems:[NSArray arrayWithArray:house]];
            [_houseCommitteesController sortItemsIntoSectionsAndReload];

            [_senateCommitteesController.dataProvider setItems:[NSArray arrayWithArray:senate]];
            [_senateCommitteesController sortItemsIntoSectionsAndReload];

            [_jointCommitteesController.dataProvider setItems:[NSArray arrayWithArray:joint]];
            [_jointCommitteesController sortItemsIntoSectionsAndReload];
        }
    }];
}

#pragma mark - UIViewControllerRestoration

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    [coder encodeInteger:[_segmentedController currentSegmentIndex] forKey:@"selectedSegment"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    _restorationSelectedSegment = [coder decodeIntegerForKey:@"selectedSegment"];
}

@end
