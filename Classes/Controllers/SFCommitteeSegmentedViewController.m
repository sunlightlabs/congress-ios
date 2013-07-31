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

@interface SFCommitteeSegmentedViewController ()

@end

@implementation SFCommitteeSegmentedViewController {
    NSString *_committeeId;
    SFCommittee *_committee;
    NSInteger *_currentSegmentIndex;
}

@synthesize segmentedController = _segmentedController;
@synthesize detailController = _detailController;
@synthesize membersController = _membersController;
@synthesize hearingsController = _hearingsController;

- (id)initWithCommittee:(SFCommittee *)committee
{
    self = [self initWithNibName:nil bundle:nil];
    [self updateWithCommittee:committee];
    return self;
}

- (id)initWithCommitteeId:(NSString *)committeeId
{
    self = [self initWithNibName:nil bundle:nil];
    _committeeId = committeeId;
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.restorationIdentifier = NSStringFromClass(self.class);
        self.restorationClass = [self class];
        [self _init];
    }
    return self;
}

- (void)_init
{
    _detailController = [[SFCommitteeDetailViewController alloc] initWithNibName:nil bundle:nil];
    _membersController = [[SFCommitteeMembersTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _hearingsController = [[SFHearingsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _segmentedController = [[SFSegmentedViewController alloc] initWithNibName:nil bundle:nil];
    
    [self addChildViewController:_segmentedController];

}

- (void)loadView
{
    UIView *view = [[UIView alloc] init];
    [view setFrame:[[UIScreen mainScreen] bounds]];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_segmentedController.view setFrame:self.view.frame];
    
    [_segmentedController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_segmentedController setViewControllers:@[_detailController, _membersController, _hearingsController]
                                      titles:@[@"About", @"Members", @"Hearings"]];
    [self.view addSubview:_segmentedController.view];
    
    [_segmentedController didMoveToParentViewController:self];
    [_segmentedController displayViewForSegment:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_committeeId && _committee == nil) {
        [SFCommitteeService committeeWithId:_committeeId completionBlock:^(SFCommittee *committee) {
            [self updateWithCommittee:committee];
        }];
    }
    if (_currentSegmentIndex) {
        [_segmentedController displayViewForSegment:_currentSegmentIndex];
        _currentSegmentIndex = nil;
    }
}

#pragma mark - public
         
- (void)updateWithCommittee:(SFCommittee *)committee
{
    _committee = committee;
    _committeeId = committee.committeeId;
    
    self.title = committee.isSubcommittee ? @"Subcommittee" : @"Committee";
    
    _shareableObjects = [NSMutableArray array];
    [_shareableObjects addObject:[NSString stringWithFormat:@"%@ via @congress_app", _committee.name]];
    [_shareableObjects addObject:_committee.shareURL];
    
    _detailController.favoriteButton.selected = committee.persist;
    [_detailController.favoriteButton setAccessibilityLabel:@"Follow commmittee"];
    [_detailController.favoriteButton setAccessibilityValue:committee.persist ? @"Following" : @"Not Following"];
    [_detailController.favoriteButton setAccessibilityHint:@"Follow this committee to see the lastest updates in the Following section."];
    
    _detailController.nameLabel.text = committee.name;
    [_detailController.nameLabel setAccessibilityLabel:@"Name of committee"];
    [_detailController.nameLabel setAccessibilityValue:committee.name];
    
//    NSArray *members = [[committee members] valueForKey:@"legislator"];
    NSArray *members = [committee members];
    members = [members sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[(SFLegislator *)obj1 valueForKeyPath:@"legislator.lastName"] compare:[(SFLegislator *)obj2 valueForKeyPath:@"legislator.lastName"]];
    }];
    [_membersController setItems:members];
    [_membersController sortItemsIntoSectionsAndReload];
    
    if (committee.isSubcommittee) {
        [_detailController.committeeTableController.tableView setHidden:YES];
        [_detailController.committeeTableController.view setHidden:YES];
    } else {
        [SFCommitteeService subcommitteesForCommittee:_committeeId completionBlock:^(NSArray *subcommittees) {
            [_detailController.committeeTableController setItems:subcommittees];
            [_detailController.committeeTableController sortItemsIntoSectionsAndReload];
        }];
    }
    
    [SFHearingService hearingsForCommitteeId:committee.committeeId completionBlock:^(NSArray *hearings) {
        [_hearingsController setItems:hearings];
        [_hearingsController setSectionTitleGenerator:hearingSectionGenerator];
        [_hearingsController setSortIntoSectionsBlock:hearingSectionSorter];
        [_hearingsController sortItemsIntoSectionsAndReload];
    }];
    
    [_detailController updateWithCommittee:committee];
}
         
#pragma mark - UIViewControllerRestoration

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
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
