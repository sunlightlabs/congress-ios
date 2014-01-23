//
//  SFHearingsSectionViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 8/23/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFHearingsSectionViewController.h"
#import "SFHearingService.h"

SFDataTableOrderItemsInSectionsBlock const ascendingDateBlock = ^NSArray *(NSArray *sectionItems) {
    return [sectionItems sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"occursAt" ascending:YES]]];
};

SFDataTableOrderItemsInSectionsBlock const descendingDateBlock = ^NSArray *(NSArray *sectionItems) {
    return [sectionItems sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"occursAt" ascending:NO]]];
};

@interface SFHearingsSectionViewController ()

@end

@implementation SFHearingsSectionViewController

@synthesize recentHearingsController = _recentHearingsController;
@synthesize upcomingHearingsController = _upcomingHearingsController;
@synthesize segmentedController = _segmentedController;
@synthesize restorationSelectedSegment = _restorationSelectedSegment;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.screenName = @"Hearing Section Screen";
        self.restorationIdentifier = NSStringFromClass(self.class);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.title = @"Hearings";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem menuButtonWithTarget:self.viewDeckController action:@selector(toggleLeftView)];

    _segmentedController = [[SFSegmentedViewController alloc] init];
    [_segmentedController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addChildViewController:_segmentedController];

    _recentHearingsController = [[SFHearingsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _upcomingHearingsController = [[SFHearingsTableViewController alloc] initWithStyle:UITableViewStylePlain];

    [_segmentedController setViewControllers:@[_upcomingHearingsController, _recentHearingsController]
                                      titles:@[@"Upcoming", @"Recent"]];

    [self.view addSubview:_segmentedController.view];

    [_segmentedController didMoveToParentViewController:self];
    [_segmentedController displayViewForSegment:0];

    /* layout */

    NSDictionary *viewDict = @{ @"segments": _segmentedController.view,
                                @"recent": _recentHearingsController.view,
                                @"upcoming": _upcomingHearingsController.view };

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

- (void)update {
    [SFHearingService upcomingHearingsWithCompletionBlock: ^(NSArray *hearings) {
        if (hearings) {
            [_upcomingHearingsController.dataProvider setItems:hearings];
            [_upcomingHearingsController.dataProvider setOrderItemsInSectionsBlock:ascendingDateBlock];
            [_upcomingHearingsController sortItemsIntoSectionsAndReload];
        }
    }];
    [SFHearingService recentHearingsWithCompletionBlock: ^(NSArray *hearings) {
        if (hearings) {
            [_recentHearingsController.dataProvider setItems:hearings];
            [_recentHearingsController.dataProvider setOrderItemsInSectionsBlock:descendingDateBlock];
            [_recentHearingsController sortItemsIntoSectionsAndReload];
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
