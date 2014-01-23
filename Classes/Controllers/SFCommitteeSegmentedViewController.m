//
//  SFCommitteeSegmentedViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/20/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteeSegmentedViewController.h"
#import "SFCommitteeService.h"
#import "SFHearingService.h"
#import "SFCommitteeActivityItemSource.h"

SFDataTableSectionTitleGenerator const memberSectionGenerator = ^NSArray *(NSArray *items) {
    return @[@"Leadership", @"Members"];
};

SFDataTableSortIntoSectionsBlock const memberSectionSorter = ^NSUInteger (id item, NSArray *sectionTitles) {
    return [((SFCommitteeMember *)item).title isEqual :[NSNull null]] ? 1 : 0;
};

@interface SFCommitteeSegmentedViewController ()

@end

@implementation SFCommitteeSegmentedViewController {
    NSString *_committeeId;
    SFCommittee *_committee;
    NSInteger *_currentSegmentIndex;
    NSArray *_segmentTitles;
}

@synthesize segmentedController = _segmentedController;
@synthesize detailController = _detailController;
@synthesize membersController = _membersController;
@synthesize hearingsController = _hearingsController;

- (id)initWithCommittee:(SFCommittee *)committee {
    self = [self initWithNibName:nil bundle:nil];
    _committee = committee;
    return self;
}

- (id)initWithCommitteeId:(NSString *)committeeId {
    self = [self initWithNibName:nil bundle:nil];
    _committeeId = committeeId;
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.restorationIdentifier = NSStringFromClass(self.class);
        self.restorationClass = [self class];
        [self _init];
    }
    return self;
}

- (void)_init {
    _segmentTitles = @[@"About", @"Members", @"Hearings"];

    _detailController = [[SFCommitteeDetailViewController alloc] initWithNibName:nil bundle:nil];
    _membersController = [[SFCommitteeMembersTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _hearingsController = [[SFCommitteeHearingsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _segmentedController = [[SFSegmentedViewController alloc] initWithNibName:nil bundle:nil];

    [self addChildViewController:_segmentedController];
}

- (void)loadView {
    UIView *view = [[UIView alloc] init];
    [view setFrame:[[UIScreen mainScreen] bounds]];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;

    [_segmentedController.view setFrame:self.view.frame];

    [_segmentedController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_segmentedController setViewControllers:@[_detailController, _membersController, _hearingsController]
                                      titles:_segmentTitles];
    [self.view addSubview:_segmentedController.view];

    [_segmentedController didMoveToParentViewController:self];
    [_segmentedController displayViewForSegment:0];

    if (_committee) {
        [self updateWithCommittee:_committee];
    }

    /* layout */

    NSDictionary *viewDict = @{ @"segments" : _segmentedController.view };

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[segments]|" options:0 metrics:nil views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[segments]|" options:0 metrics:nil views:viewDict]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_committeeId && _committee == nil) {
        [SFCommitteeService committeeWithId:_committeeId completionBlock: ^(SFCommittee *committee) {
            [self updateWithCommittee:committee];
        }];
    }
    if (_currentSegmentIndex) {
        [_segmentedController displayViewForSegment:_currentSegmentIndex];
        _currentSegmentIndex = nil;
    }
    if (_committee) {
        [[[GAI sharedInstance] defaultTracker] send:
         [[GAIDictionaryBuilder createEventWithCategory:@"Committee"
                                                 action:@"View"
                                                  label:[NSString stringWithFormat:@"%@ %@", _committee.prefixName, _committee.primaryName]
                                                  value:nil] build]];
    }
}

#pragma mark - public

- (void)updateWithCommittee:(SFCommittee *)committee {
    _committee = committee;
    _committeeId = committee.committeeId;

    self.title = [committee primaryName];

    [_detailController updateWithCommittee:committee];

    _detailController.nameLabel.text = committee.name;
    [_detailController.nameLabel setAccessibilityLabel:@"Name of committee"];
    [_detailController.nameLabel setAccessibilityValue:committee.name];

//    NSArray *members = [[committee members] valueForKey:@"legislator"];
    NSArray *members = [committee members];
    members = [members sortedArrayUsingComparator: ^NSComparisonResult (id obj1, id obj2) {
        return [[(SFLegislator *)obj1 valueForKeyPath : @"legislator.lastName"] compare:[(SFLegislator *)obj2 valueForKeyPath : @"legislator.lastName"]];
    }];

    [_membersController.dataProvider setItems:members];
    [_membersController.dataProvider setSectionTitleGenerator:memberSectionGenerator];
    [_membersController.dataProvider setSortIntoSectionsBlock:memberSectionSorter];
    [_membersController sortItemsIntoSectionsAndReload];

    [SFHearingService hearingsForCommitteeId:committee.committeeId completionBlock: ^(NSArray *hearings) {
        if ([hearings count] > 0) {
            [_hearingsController.dataProvider setItems:hearings];
            [_hearingsController.dataProvider setSectionTitleGenerator:hearingSectionGenerator];
            [_hearingsController.dataProvider setSortIntoSectionsBlock:hearingSectionSorter];
            [_hearingsController sortItemsIntoSectionsAndReload];
        }
        else {
            SFLabel *blankLabel = [[SFLabel alloc] initWithFrame:CGRectMake(0, 100, 320, 40)];
            [blankLabel setBackgroundColor:[UIColor primaryBackgroundColor]];
            [blankLabel setFont:[UIFont bodyTextFont]];
            [blankLabel setText:@"No hearings scheduled."];
            [blankLabel setTextColor:[UIColor secondaryTextColor]];
            [blankLabel setTextAlignment:NSTextAlignmentCenter];

            UIView *blankView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            [blankView setBackgroundColor:[UIColor primaryBackgroundColor]];
            [blankView addSubview:blankLabel];

            _hearingsController.view = blankView;
        }
    }];
}

- (void)setVisibleSegment:(NSString *)segmentName {
    NSUInteger segmentIndex = [_segmentTitles indexOfObjectPassingTest: ^BOOL (id obj, NSUInteger idx, BOOL *stop) {
        if ([segmentName caseInsensitiveCompare:(NSString *)obj] == NSOrderedSame) {
            stop = YES;
            return YES;
        }
        return NO;
    }];
    _currentSegmentIndex = segmentIndex != NSNotFound ? segmentIndex : 0;
}

#pragma mark - SFActivity

- (NSArray *)activityItems {
    if (_committee) {
        return @[[[SFCommitteeTextActivityItemSource alloc] initWithCommittee:_committee],
                 [[SFCommitteeURLActivityItemSource alloc] initWithCommittee:_committee]];
    }
    return nil;
}

#pragma mark - UIViewControllerRestoration

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {
    return [[SFCommitteeSegmentedViewController alloc] initWithNibName:nil bundle:nil];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    NSString *committeeId = _committee ? _committee.committeeId : _committeeId;
    [coder encodeObject:committeeId forKey:@"committeeId"];
    [coder encodeInteger:[_segmentedController currentSegmentIndex] forKey:@"segmentIndex"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    _committeeId = [coder decodeObjectForKey:@"committeeId"];
    _currentSegmentIndex = [coder decodeIntegerForKey:@"segmentIndex"];
}

@end
