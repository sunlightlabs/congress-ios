//
//  SFCommitteeSegmentedViewController.m
//  Congress
//
//  Created by Jeremy Carbaugh on 7/20/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFCommitteeSegmentedViewController.h"
#import "SFCommitteeService.h"

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
@synthesize subcommitteesController = _subcommitteesController;

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
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor blueColor]];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    _detailController = [[SFCommitteeDetailViewController alloc] init];
    [_detailController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_detailController.view];
    
    _segmentedController = [[SFSegmentedViewController alloc] init];
    [_segmentedController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_segmentedController setViewControllers:@[_detailController, _detailController] titles:@[@"About", @"Members"]];
    [self.view addSubview:_segmentedController.view];
    
    [_segmentedController didMoveToParentViewController:self];
    [_segmentedController displayViewForSegment:0];
    
    /* auto layout */
    
    NSDictionary *viewDict = @{ @"segments": _segmentedController.view, @"detail": _detailController.view };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[segments]|" options:0 metrics:nil views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[segments]|" options:0 metrics:nil views:viewDict]];
    
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[detail(100)]|" options:0 metrics:nil views:viewDict]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[detail(100)]|" options:0 metrics:nil views:viewDict]];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (_committeeId && _committee == nil) {
        [SFCommitteeService committeeWithId:_committeeId completionBlock:^(SFCommittee *committee) {
            [self updateWithCommittee:committee];
        }];
    }
}

#pragma mark - public
         
- (void)updateWithCommittee:(SFCommittee *)committee
{
    _committee = committee;
    _committeeId = committee.committeeId;
    
    [_detailController updateWithCommittee:committee];
    
    self.title = committee.name;
    
    if (_currentSegmentIndex) {
        [_segmentedController displayViewForSegment:_currentSegmentIndex];
        _currentSegmentIndex = nil;
    }
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
